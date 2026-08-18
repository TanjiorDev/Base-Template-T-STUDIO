-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — SERVER/ADMIN.LUA
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

-- Fallback de normalisation universelle pour les points de spawn
if not normalizeSpawnPoints then
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
end


-- Helper de permission d'administration
function isAdmin(source)
    if source == 0 then return true end
    
    -- 1. Vérification par permission FiveM globale 'command' (Tous les admins autorisés via txAdmin / server.cfg)
    if IsPlayerAceAllowed(source, "command") or IsPlayerAceAllowed(source, "command.bl_garage_admin") then
        debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès accordé par Ace Permission command/bl_garage_admin (source %s)^0", tostring(source)))
        return true
    end

    -- 2. Vérification par Identifiant Garanti (Config.AdminIdentifiers)
    local xPlayerSafe = nil
    if ESX then
        xPlayerSafe = ESX.GetPlayerFromId(source)
    end
    
    if xPlayerSafe and xPlayerSafe.identifier then
        if Config.AdminIdentifiers then
            for _, ident in ipairs(Config.AdminIdentifiers) do
                if string.lower(xPlayerSafe.identifier) == string.lower(ident) then
                    debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès garanti accordé pour l'identifiant %s (source %s)^0", tostring(xPlayerSafe.identifier), tostring(source)))
                    return true
                end
            end
        end
    end

    -- 3. Vérification par License FiveM brute (sécurité supplémentaire si ESX n'est pas encore prêt)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    if playerIdentifiers and Config.AdminIdentifiers then
        for _, playerIdent in ipairs(playerIdentifiers) do
            for _, ident in ipairs(Config.AdminIdentifiers) do
                if string.lower(playerIdent) == string.lower(ident) then
                    debugPrint(string.format("^2[bl_garage DEBUG] isAdmin: Accès garanti accordé par License FiveM brute %s (source %s)^0", tostring(playerIdent), tostring(source)))
                    return true
                end
            end
        end
    end

    if ESX == nil then 
        debugPrint("^1[bl_garage DEBUG] isAdmin: ESX est NIL! Impossible de vérifier le groupe ESX.^0")
        return false 
    end
    local xPlayer = xPlayerSafe or ESX.GetPlayerFromId(source)
    if not xPlayer then 
        debugPrint(string.format("^1[bl_garage DEBUG] isAdmin: xPlayer est NIL pour la source %s!^0", tostring(source)))
        return false 
    end
    
    local group = nil
    if type(xPlayer.getGroup) == 'function' then
        group = xPlayer.getGroup()
    elseif xPlayer.group then
        group = xPlayer.group
    elseif type(xPlayer.get) == 'function' then
        group = xPlayer.get('group')
    end

    if group then
        group = string.lower(tostring(group))
    end

    debugPrint(string.format("^3[bl_garage DEBUG] Player source: %s | Identifier: %s | Group: %s^0", tostring(source), tostring(xPlayer.identifier), tostring(group)))

    if group and Config.AdminGroups and Config.AdminGroups[group] then
        return true
    end
    if group == 'admin' or group == 'superadmin' or group == 'mod' then
        return true
    end
    
    debugPrint(string.format("^1[bl_garage DEBUG] isAdmin: Accès refusé pour la source %s (Groupe: %s)^0", tostring(source), tostring(group)))
    return false
end

-- Enregistrer les Callbacks administratifs une fois ESX disponible
function registerAdminCallbacks()
    -- Callback : Enregistrer/Modifier un point de garage ou fourrière (Admin)
    ESX.RegisterServerCallback('bl_garage:saveImpound', function(source, cb, garageId, data)
        debugPrint(string.format("^3[bl_garage DEBUG] saveImpound déclenché pour l'ID: %s par le joueur: %s^0", tostring(garageId), tostring(source)))
        debugPrint(string.format("^3[bl_garage DEBUG] Données brutes reçues: %s^0", json.encode(data)))

        if not isAdmin(source) then
            debugPrint("^1[bl_garage DEBUG] ÉCHEC DE PERMISSION : Le joueur " .. tostring(source) .. " n'est pas admin !^0")
            cb(false)
            return
        end

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

        data.pedModel = data.pedModel or "s_m_y_xmech_01"
        data.blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label }

        -- Récupérer les propriétés d'origine si existantes
        local originalDelete = nil
        local originalJob = nil
        if Config.Garages[garageId] then
            originalDelete = Config.Garages[garageId].delete
            originalJob = Config.Garages[garageId].job
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

        -- Convertir pour le Config local du serveur
        local localData = {
            label = data.label,
            type = pointType,
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            pedModel = data.pedModel,
            pedHeading = tonumber(data.pedHeading) or 0.0,
            spawn = spawnPoints,
            delete = (pointType ~= "impound") and (data.delete and vector3(data.delete.x, data.delete.y, data.delete.z) or vector3(firstSpawn.x or 0.0, firstSpawn.y or 0.0, firstSpawn.z or 0.0)) or nil,
            deleteSize = type(data.deleteSize) == 'number' and data.deleteSize or (type(data.deleteSize) == 'string' and tonumber(data.deleteSize) or 7.0),
            blipSprite = blipSprite,
            blipColor = blipColor,
            blip = data.blip,
            job = originalJob
        }

        Config.Garages[garageId] = localData

        -- Mettre à jour notre cache en mémoire
        CustomGarages[garageId] = data
        
        -- Diagnostic d'enregistrement en BDD pour validation
        print(string.format("^3[bl_garage SERVER SAVE] garageId: %s | Nom: %s | spawnData (encode): %s^0", tostring(garageId), tostring(data.label), json.encode(data.spawn)))

        -- Sauvegarder dans la base de données (100% Persistant et immunisé contre les écrasements de fichiers)
        MySQL.update("INSERT INTO bl_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {
            garageId,
            json.encode(data),
            json.encode(data)
        }, function()
            debugPrint(string.format("^2[bl_garage DEBUG] Sauvegarde de %s dans la table bl_garages réussie !^0", garageId))
        end)

        -- Synchroniser avec tous les clients
        TriggerClientEvent('bl_garage:syncGarages', -1, CustomGarages, true)
        cb(true)
    end)

    -- Callback : Supprimer un point de garage ou fourrière (Admin)
    ESX.RegisterServerCallback('bl_garage:deleteGarage', function(source, cb, garageId)
        if not isAdmin(source) then
            cb(false)
            return
        end

        -- Supprimer du Config local
        Config.Garages[garageId] = nil

        -- Si c'est un point custom, on peut complètement le supprimer de CustomGarages & de la BDD
        -- Si c'est un point par défaut, on le marque comme deleted pour que ce soit persistant après reboot
        if string.match(tostring(garageId), "^impound_custom_") then
            CustomGarages[garageId] = nil
            MySQL.update("DELETE FROM bl_garages WHERE id = ?", { garageId }, function()
                debugPrint(string.format("^2[bl_garage DEBUG] Suppression de %s de la table bl_garages réussie !^0", garageId))
            end)
        else
            CustomGarages[garageId] = { deleted = true }
            MySQL.update("INSERT INTO bl_garages (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {
                garageId,
                json.encode({ deleted = true }),
                json.encode({ deleted = true })
            }, function()
                debugPrint(string.format("^2[bl_garage DEBUG] Masquage persistant de %s dans la table bl_garages réussi !^0", garageId))
            end)
        end

        -- Synchroniser avec tous les clients
        TriggerClientEvent('bl_garage:syncGarages', -1, CustomGarages, true)
        cb(true)
    end)
end

-- Commandes Admin /garageadmin et /admingarage pour ouvrir le menu de configuration global en jeu
local function openAdminPanel(source)
    local src = source
    if src == 0 then
        print("[bl_garage] Cette commande doit être exécutée en jeu par un administrateur.")
        return
    end

    if isAdmin(src) then
        TriggerClientEvent('bl_garage:openMasterAdmin', src)
    else
        TriggerClientEvent('esx:showNotification', src, "~r~Vous n'avez pas la permission d'utiliser cette commande.")
    end
end

RegisterCommand('garageadmin', function(source, args, rawCommand)
    openAdminPanel(source)
end, false)

RegisterCommand('admingarage', function(source, args, rawCommand)
    openAdminPanel(source)
end, false)

-- Commande Admin /exportgarages pour exporter tous les garages actuels (Config + BDD) sous forme de table Lua propre
RegisterCommand('exportgarages', function(source, args, rawCommand)
    if source ~= 0 and not isAdmin(source) then
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas la permission de faire cela.")
        return
    end

    MySQL.query("SELECT * FROM bl_garages", {}, function(results)
        local exported = "-- ============================================================\n"
        exported = exported .. "-- BLOODLEAK PREMIUM 2026 - CONFIGURATION DU PARC AUTO EXPORTÉE\n"
        exported = exported .. "-- Copiez ce tableau et remplacez Config.Garages dans votre config.lua\n"
        exported = exported .. "-- ============================================================\n\n"
        exported = exported .. "Config.Garages = {\n"

        -- Récupérer la config par défaut actuelle (pour exclure les supprimés)
        local defaultGarages = {}
        for id, g in pairs(Config.Garages) do
            if not string.match(tostring(id), "^impound_custom_") then
                defaultGarages[id] = g
            end
        end

        local function formatVec3(v)
            if not v then return "nil" end
            return string.format("vector3(%.2f, %.2f, %.2f)", v.x or v[1] or 0.0, v.y or v[2] or 0.0, v.z or v[3] or 0.0)
        end

        local function formatVec4(v)
            if not v then return "nil" end
            return string.format("vector4(%.2f, %.2f, %.2f, %.2f)", v.x or v[1] or 0.0, v.y or v[2] or 0.0, v.z or v[3] or 0.0, v.w or v[4] or v.heading or 0.0)
        end

        local allGarages = {}
        for id, g in pairs(defaultGarages) do
            allGarages[id] = g
        end

        -- Fusionner avec la base de données
        if results then
            for _, row in ipairs(results) do
                local data = safeJsonDecode(row.data)
                if data then
                    if data.deleted then
                        allGarages[row.id] = nil
                    else
                        local pointType = data.type or "impound"
                        local blipSprite = tonumber(data.blipSprite) or 357
                        local blipColor = tonumber(data.blipColor) or 3
                        
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

                        allGarages[row.id] = {
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
                            blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label }
                        }
                    end
                end
            end
        end

        -- Trier les clés pour avoir un ordre propre
        local keys = {}
        for k in pairs(allGarages) do table.insert(keys, k) end
        table.sort(keys)

        for _, id in ipairs(keys) do
            local g = allGarages[id]
            exported = exported .. string.format("    [\"%s\"] = {\n", id)
            exported = exported .. string.format("        label = \"%s\",\n", g.label)
            exported = exported .. string.format("        type = \"%s\",\n", g.type)
            exported = exported .. string.format("        coords = %s,\n", formatVec3(g.coords))
            exported = exported .. string.format("        pedModel = \"%s\",\n", g.pedModel)
            exported = exported .. string.format("        pedHeading = %.2f,\n", g.pedHeading or 0.0)
            
            -- Spawn points
            if type(g.spawn) == 'table' and #g.spawn > 0 then
                if #g.spawn > 1 then
                    exported = exported .. "        spawn = {\n"
                    for _, sp in ipairs(g.spawn) do
                        exported = exported .. string.format("            %s,\n", formatVec4(sp))
                    end
                    exported = exported .. "        },\n"
                else
                    exported = exported .. string.format("        spawn = %s,\n", formatVec4(g.spawn[1]))
                end
            else
                exported = exported .. string.format("        spawn = %s,\n", formatVec4(g.spawn))
            end

            if g.delete then
                exported = exported .. string.format("        delete = %s,\n", formatVec3(g.delete))
                exported = exported .. string.format("        deleteSize = %.1f,\n", g.deleteSize or 7.0)
            else
                exported = exported .. "        delete = nil,\n"
            end

            local bSprite = g.blipSprite or (g.blip and g.blip.sprite) or 357
            local bColor = g.blipColor or (g.blip and g.blip.color) or 3
            exported = exported .. string.format("        blip = { active = true, sprite = %d, color = %d, scale = 0.8, label = \"%s\" },\n", bSprite, bColor, g.label)
            exported = exported .. "        job = nil\n"
            exported = exported .. "    },\n"
        end

        exported = exported .. "}\n"

        SaveResourceFile(GetCurrentResourceName(), "config_exported.lua", exported, -1)
        
        if source == 0 then
            print("^2[bl_garage] Exportation reussie ! Le fichier 'config_exported.lua' a ete genere a la racine du script.^0")
        else
            TriggerClientEvent('esx:showNotification', source, "~g~Exportation reussie ! Voir config_exported.lua a la racine.")
        end
    end)
end, false)

-- Hook d'initialisation decouple de l'ordre du manifeste
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
    registerAdminCallbacks()
end)

