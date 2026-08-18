-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — SERVER/MAIN.LUA
-- ============================================================

-- Sécurité globale : S'assurer que vector3 et vector4 sont définis côté serveur (compatibilité anciens FXServer)
if not vector3 then
    function vector3(x, y, z)
        return { x = x or 0.0, y = y or 0.0, z = z or 0.0 }
    end
end

if not vector4 then
    function vector4(x, y, z, w)
        return { x = x or 0.0, y = y or 0.0, z = z or 0.0, w = w or 0.0 }
    end
end

-- Helper de normalisation universelle pour les points de spawn (indépendant du type d'indexation CEF)
function normalizeSpawnPoints(spawn)
    if not spawn then return nil end
    local normalized = {}
    
    -- Si c'est déjà un vecteur FiveM natif directement
    if type(spawn) == 'userdata' or type(spawn) == 'vector4' or type(spawn) == 'vector3' then
        return { { x = spawn.x, y = spawn.y, z = spawn.z, w = spawn.w or spawn.heading or 0.0 } }
    end

    if type(spawn) ~= 'table' then return nil end

    -- Si c'est un point unique indexé par ses axes (ex: { x = ..., y = ... })
    if spawn.x then
        return { { x = tonumber(spawn.x) or 0.0, y = tonumber(spawn.y) or 0.0, z = tonumber(spawn.z) or 0.0, w = tonumber(spawn.w or spawn.heading) or 0.0 } }
    end

    -- Si c'est un tableau de points (avec des clés numériques, chaînes ou des structures complexes)
    for k, v in pairs(spawn) do
        if type(v) == 'table' or type(v) == 'userdata' or type(v) == 'vector4' or type(v) == 'vector3' then
            local x = tonumber(v.x or v[1]) or 0.0
            local y = tonumber(v.y or v[2]) or 0.0
            local z = tonumber(v.z or v[3]) or 0.0
            local w = tonumber(v.w or v[4] or v.heading) or 0.0
            table.insert(normalized, { x = x, y = y, z = z, w = w })
        end
    end

    return #normalized > 0 and normalized or nil
end


if ESX == nil then
    local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
    if ok and result then
        ESX = result
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end

-- Variables globales partagées
CustomGarages = {}

-- Helper de décodage JSON sécurisé (Anti-Crash)
function safeJsonDecode(str)
    if not str or str == "" then return {} end
    local ok, result = pcall(json.decode, str)
    if ok and result then
        return result
    else
        return {}
    end
end

-- 1. Chargement sécurisé de l'objet ESX (Export + Legacy)
Citizen.CreateThread(function()
    while ESX == nil do
        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then
            ESX = result
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Citizen.Wait(100)
    end
end)

-- 2. Adaptateur SQL pour oxmysql & mysql-async (Détection dynamique robuste)
MySQL = {
    query = function(query, params, cb)
        if GetResourceState('oxmysql') == 'started' then
            exports.oxmysql:query(query, params, function(res) if cb then cb(res) end end)
        elseif GetResourceState('mysql-async') == 'started' then
            exports['mysql-async']:mysql_fetch_all(query, params, function(res) if cb then cb(res) end end)
        else
            print('^1[bl_garage] ERREUR : Aucun driver SQL détecté (oxmysql ou mysql-async).^0')
            if cb then cb({}) end
        end
    end,
    update = function(query, params, cb)
        if GetResourceState('oxmysql') == 'started' then
            exports.oxmysql:update(query, params, cb)
        elseif GetResourceState('mysql-async') == 'started' then
            exports['mysql-async']:mysql_execute(query, params, cb)
        end
    end
}

-- 3. Détection dynamique des colonnes de stockage et Helper SQL
local hasStoredColumn = false
local hasStateColumn = false

Citizen.CreateThread(function()
    Citizen.Wait(3000) -- Attendre le chargement complet des bases
    
    -- Créer la table bl_garages pour la persistance robuste en base de données
    MySQL.update([[
        CREATE TABLE IF NOT EXISTS `bl_garages` (
            `id` VARCHAR(50) NOT NULL,
            `data` LONGTEXT NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
        print('^2[bl_garage] SQL : Table bl_garages vérifiée/prête pour une persistance 100% robuste.^0')
        loadGaragesFromDatabase()
    end)

    MySQL.query("SHOW COLUMNS FROM `owned_vehicles` LIKE 'garage'", {}, function(cols)
        if not cols or #cols == 0 then
            MySQL.query("ALTER TABLE `owned_vehicles` ADD COLUMN `garage` VARCHAR(50) DEFAULT 'Legion'", {}, function()
                print('^2[bl_garage] SQL : Colonne "garage" ajoutée avec succès à la table owned_vehicles.^0')
            end)
        else
            print('^2[bl_garage] SQL : Structure de table owned_vehicles vérifiée et prête.^0')
        end
    end)
    
    MySQL.query("SHOW COLUMNS FROM `owned_vehicles` LIKE 'stored'", {}, function(cols)
        if cols and #cols > 0 then
            hasStoredColumn = true
            print('^2[bl_garage] SQL : Colonne "stored" détectée dans la table owned_vehicles.^0')
        end
    end)
    
    MySQL.query("SHOW COLUMNS FROM `owned_vehicles` LIKE 'state'", {}, function(cols)
        if cols and #cols > 0 then
            hasStateColumn = true
            print('^2[bl_garage] SQL : Colonne "state" détectée dans la table owned_vehicles.^0')
        end
    end)
end)

function updateVehicleStorage(plate, stateVal, garageId, ownerIdentifier, props, cb)
    local cleanPlate = string.gsub(plate or "", "^%s*(.-)%s*$", "%1"):upper()
    local noSpacePlate = string.gsub(plate or "", "[^%w]", ""):upper()
    local query = "UPDATE owned_vehicles SET "
    local params = {}

    local sets = {}
    if hasStoredColumn then
        table.insert(sets, "`stored` = ?")
        table.insert(params, stateVal)
    end
    if hasStateColumn then
        table.insert(sets, "`state` = ?")
        table.insert(params, stateVal)
    end
    if garageId then
        table.insert(sets, "`garage` = ?")
        table.insert(params, garageId)
    end
    if props then
        table.insert(sets, "`vehicle` = ?")
        table.insert(params, json.encode(props))
    end

    if #sets > 0 then
        query = query .. table.concat(sets, ", ")
        if ownerIdentifier then
            query = query .. " WHERE (`plate` = ? OR REPLACE(`plate`, ' ', '') = ?) AND `owner` = ?"
            table.insert(params, cleanPlate)
            table.insert(params, noSpacePlate)
            table.insert(params, ownerIdentifier)
        else
            query = query .. " WHERE `plate` = ? OR REPLACE(`plate`, ' ', '') = ?"
            table.insert(params, cleanPlate)
            table.insert(params, noSpacePlate)
        end
        MySQL.update(query, params, function(affectedRows)
            if cb then cb(affectedRows) end
        end)
    else
        if cb then cb(0) end
    end
end

-- 5. Événement : Changer l'état d'un véhicule (Stocké ou Sorti)
RegisterNetEvent('bl_garage:setStoredState')
AddEventHandler('bl_garage:setStoredState', function(plate, state, props, garageId)
    local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1"):upper()
    if props then
        updateVehicleStorage(cleanPlate, state, garageId, nil, props)
    else
        updateVehicleStorage(cleanPlate, state, garageId)
    end
end)

-- Thread de nettoyage automatique des véhicules abandonnés
Citizen.CreateThread(function()
    while true do
        -- Récupérer la configuration de nettoyage
        local autoImpoundCfg = Config.AutoImpound or {}
        local isEnabled = autoImpoundCfg.Enabled ~= false -- true par défaut si non spécifié
        local checkInterval = autoImpoundCfg.CheckInterval or 120000 -- 2 minutes par défaut
        local abandonTime = autoImpoundCfg.AbandonTime or 600 -- 10 minutes par défaut

        Citizen.Wait(checkInterval) -- Attendre l'intervalle configuré

        if isEnabled then
            local allVehicles = GetAllVehicles()
            
            for _, vehicle in ipairs(allVehicles) do
                if DoesEntityExist(vehicle) then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    if plate then
                        local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1"):upper()
                        
                        -- Vérifier si le véhicule est vide (pas de chauffeur ni de passagers)
                        local isPedInside = false
                        for i = -1, 5 do
                            local ped = GetPedInVehicleSeat(vehicle, i)
                            if ped and ped ~= 0 and IsPedAPlayer(ped) then
                                isPedInside = true
                                break
                            end
                        end
                        
                        -- Si personne n'est dans le véhicule
                        if not isPedInside then
                            -- Initialiser ou incrémenter le compteur de temps vide
                            if not Entity(vehicle).state.emptySince then
                                Entity(vehicle).state.emptySince = os.time()
                            else
                                local secondsEmpty = os.time() - Entity(vehicle).state.emptySince
                                -- Si vide depuis plus longtemps que le temps configuré
                                if secondsEmpty >= abandonTime then
                                    -- Vérifier si c'est un véhicule possédé par un joueur
                                    MySQL.query("SELECT plate FROM owned_vehicles WHERE plate = ?", { cleanPlate }, function(results)
                                        if results and #results > 0 then
                                            -- Supprimer l'entité côté serveur
                                            DeleteEntity(vehicle)
                                            -- Mettre à jour en BDD à la Fourrière (stored = 2)
                                            updateVehicleStorage(cleanPlate, 2)
                                            print(string.format("^3[bl_garage]^0 Véhicule abandonné %s supprimé et envoyé à la Fourrière (Auto-Impound).", cleanPlate))
                                        end
                                    end)
                                end
                            end
                        else
                            -- Réinitialiser si quelqu'un remonte dedans
                            Entity(vehicle).state.emptySince = nil
                        end
                    end
                end
            end
        end
    end
end)

-- Helper de fusion des données de garage/fourrière dans la configuration active du serveur et client
function mergeGarageConfig(id, data)
    if not data then return end
    
    if data.deleted then
        Config.Garages[id] = nil
        CustomGarages[id] = { deleted = true } -- Nécessaire pour que le client reçoive la consigne de suppression
        return
    end

    if data.coords and data.spawn then
        local pointType = data.type or "impound"
        local blipSprite = tonumber(data.blipSprite)
        local blipColor = tonumber(data.blipColor)
        
        if not blipSprite or blipSprite == 0 then
            blipSprite = 357
            if pointType == "boat" then blipSprite = 427
            elseif pointType == "air" then blipSprite = 307
            elseif pointType == "helicopter" then blipSprite = 422
            elseif pointType == "impound" then blipSprite = 68
            elseif pointType == "impound_boat" then blipSprite = 427
            elseif pointType == "impound_air" then blipSprite = 307
            elseif pointType == "impound_helicopter" then blipSprite = 422 end
        end

        if not blipColor or blipColor == 0 then
            blipColor = 3
            if pointType == "impound" then blipColor = 5 end
        end

        local originalDelete = nil
        local originalJob = nil
        if Config.Garages[id] then
            originalDelete = Config.Garages[id].delete
            originalJob = Config.Garages[id].job
        end

        local normalized = normalizeSpawnPoints(data.spawn)
        local spawnPoints = {}
        local firstSpawn = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
        if normalized then
            for _, pt in ipairs(normalized) do
                table.insert(spawnPoints, vector4(pt.x, pt.y, pt.z, pt.w))
            end
            firstSpawn = normalized[1]
        else
            spawnPoints = { vector4(0.0, 0.0, 0.0, 0.0) }
        end

        data.spawn = normalized

        local localData = {
            label = data.label,
            type = pointType,
            coords = vector3(data.coords.x or 0.0, data.coords.y or 0.0, data.coords.z or 0.0),
            pedModel = data.pedModel or "s_m_y_xmech_01",
            pedHeading = tonumber(data.pedHeading) or 0.0,
            spawn = spawnPoints,
            delete = (pointType ~= "impound") and (data.delete and vector3(data.delete.x or 0.0, data.delete.y or 0.0, data.delete.z or 0.0) or vector3(firstSpawn.x or 0.0, firstSpawn.y or 0.0, firstSpawn.z or 0.0)) or nil,
            deleteSize = type(data.deleteSize) == 'number' and data.deleteSize or (type(data.deleteSize) == 'string' and tonumber(data.deleteSize) or 7.0),
            blipSprite = blipSprite,
            blipColor = blipColor,
            blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label },
            job = originalJob
        }
        Config.Garages[id] = localData
        CustomGarages[id] = data
    end
end

-- 6. Chargement principal depuis la Base de Données (bl_garages)
function loadGaragesFromDatabase()
    MySQL.query("SELECT * FROM bl_garages", {}, function(results)
        local count = 0
        if results and #results > 0 then
            for _, row in ipairs(results) do
                local data = safeJsonDecode(row.data)
                if data then
                    mergeGarageConfig(row.id, data)
                    count = count + 1
                end
            end
            if count > 0 then
                print(string.format('^2[bl_garage] SQL : %d garage(s)/fourrière(s) personnalisée(s) chargée(s) avec succès depuis la BDD (bl_garages)^0', count))
            end
        else
            -- Si la BDD est vide, charger depuis impounds.json en guise de fallback (migration automatique)
            print("^3[bl_garage] SQL : Aucun point trouvé en base de données. Tentative de récupération depuis impounds.json...^0")
            local fileContent = LoadResourceFile(GetCurrentResourceName(), "impounds.json")
            if fileContent then
                local loaded = safeJsonDecode(fileContent)
                if loaded and next(loaded) ~= nil then
                    for id, data in pairs(loaded) do
                        if data then
                            mergeGarageConfig(id, data)
                            count = count + 1
                            -- Sauvegarder automatiquement en BDD pour migrer définitivement
                            MySQL.update("INSERT INTO bl_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {
                                id,
                                json.encode(data),
                                json.encode(data)
                            })
                        end
                    end
                    if count > 0 then
                        print(string.format('^2[bl_garage] SQL : %d garage(s)/fourrière(s) personnalisée(s) migrée(s) avec succès de impounds.json vers la BDD !^0', count))
                    end
                end
            end
        end

        -- Synchroniser dynamiquement avec tous les clients connectés une fois le chargement BDD terminé
        TriggerClientEvent('bl_garage:syncGarages', -1, CustomGarages, false)
    end)
end

-- 7. Événement de demande de synchronisation par les clients
RegisterNetEvent('bl_garage:requestSync')
AddEventHandler('bl_garage:requestSync', function()
    local src = source
    TriggerClientEvent('bl_garage:syncGarages', src, CustomGarages, false)
end)

local function getLocalVersion()
    local fileContent = LoadResourceFile(GetCurrentResourceName(), "fxmanifest.lua")
    if fileContent then
        for line in fileContent:gmatch("[^\r\n]+") do
            local trimmed = line:match("^%s*(.-)%s*$")
            local v = trimmed:match("^version%s+['\"]([^'\"]+)['\"]") or trimmed:match("^version%s*=%s*['\"]([^'\"]+)['\"]")
            if v then
                return v
            end
        end
    end
    
    local metadata = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    if metadata and metadata ~= "" then
        return metadata
    end
    
    return "0.0.0"
end

local currentVersion = getLocalVersion()

local function compareVersions(v1, v2)
    -- Retourne true si v2 (GitHub) est strictement supérieur à v1 (Local)
    local p1 = {}
    for part in string.gmatch(v1 or "", "[^%.]+") do
        table.insert(p1, tonumber(part) or 0)
    end
    local p2 = {}
    for part in string.gmatch(v2 or "", "[^%.]+") do
        table.insert(p2, tonumber(part) or 0)
    end
    for i = 1, math.max(#p1, #p2) do
        local n1 = p1[i] or 0
        local n2 = p2[i] or 0
        if n2 > n1 then return true end
        if n2 < n1 then return false end
    end
    return false
end

local function printModernUpdateCard(current, latest)
    print(string.format("^3[Blood-Garage-Creator] ^1▲ MISE À JOUR DISPONIBLE ^7| ^1v%s ^7-> ^2v%s ^7| ^5https://github.com/Linspecteur/Blood-Garage-Creator^0", current, latest))
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    
    -- Recharger dynamiquement la version locale au moment du test pour éviter le cache de FiveM
    currentVersion = getLocalVersion()
    
    local function extractVersion(text)
        if not text then return nil end
        for line in text:gmatch("[^\r\n]+") do
            local trimmed = line:match("^%s*(.-)%s*$")
            local v = trimmed:match("^version%s+['\"]([^'\"]+)['\"]") or trimmed:match("^version%s*=%s*['\"]([^'\"]+)['\"]")
            if v then
                return v
            end
        end
        return nil
    end

    local urlMain = 'https://raw.githubusercontent.com/Linspecteur/Blood-Garage-Creator/main/fxmanifest.lua?t=' .. os.time()
    local urlMaster = 'https://raw.githubusercontent.com/Linspecteur/Blood-Garage-Creator/master/fxmanifest.lua?t=' .. os.time()

    PerformHttpRequest(urlMain, function(statusCode, response, headers)
        if statusCode == 200 and response then
            local versionMatch = extractVersion(response)
            if versionMatch then
                if compareVersions(currentVersion, versionMatch) then
                    printModernUpdateCard(currentVersion, versionMatch)
                else
                    print(string.format('^3[Blood-Garage-Creator] ^2✔ Script à jour ^7| ^2v%s (GitHub: v%s)^0', currentVersion, versionMatch))
                end
            else
                print('^3[Blood-Garage-Creator] ^8⚠ Impossible de lire la version distante (Format de version invalide).^0')
            end
        else
            -- Si la branche par défaut est 'master' au lieu de 'main'
            PerformHttpRequest(urlMaster, function(statusCode2, response2, headers2)
                if statusCode2 == 200 and response2 then
                    local versionMatch = extractVersion(response2)
                    if versionMatch then
                        if compareVersions(currentVersion, versionMatch) then
                            printModernUpdateCard(currentVersion, versionMatch)
                        else
                            print(string.format('^3[Blood-Garage-Creator] ^2✔ Script à jour ^7| ^2v%s (GitHub: v%s)^0', currentVersion, versionMatch))
                        end
                    else
                        print('^3[Blood-Garage-Creator] ^8⚠ Impossible de lire la version distante (Format de version invalide).^0')
                    end
                else
                    print('^3[Blood-Garage-Creator] ^8⚠ Vérification des mises à jour indisponible (Dépôt privé ou hors-ligne).^0')
                end
            end, 'GET')
        end
    end, 'GET')
end)
