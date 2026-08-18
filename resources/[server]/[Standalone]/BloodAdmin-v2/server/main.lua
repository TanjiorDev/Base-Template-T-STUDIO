-- ============================================================
--  BLOODADMIN — SERVER/MAIN.LUA
-- ============================================================

-- Ce fichier sert de point d'entrée et gère les boucles globales.
-- La logique est répartie dans le dossier server/modules/

local startTime = os.time()

-- ── Boucle métriques serveur ─────────────────────────────────
Citizen.CreateThread(function()
    while true do
        Wait(5000)
        local totalPlayers = #GetPlayers()
        local uptime       = math.floor(GetGameTimer() / 1000)
        
        -- Calculate Global Average Ping
        local avgPing = 0
        if totalPlayers > 0 then
            local totalPing = 0
            for _, pid in ipairs(GetPlayers()) do
                totalPing = totalPing + GetPlayerPing(pid)
            end
            avgPing = math.floor(totalPing / totalPlayers)
        end
        
        -- Get simulated high-fidelity metrics
        local simulated = GetSimulatedServerMetrics()
        
        -- AdminPlayers est défini globalement dans modules/utils.lua
        if AdminPlayers then
            for src, _ in pairs(AdminPlayers) do
                TriggerClientEvent('bl_admin:updateServerMetrics', src, {
                    totalPlayers = totalPlayers,
                    serverMem    = simulated.serverMem,
                    fxMem        = simulated.fxMem,
                    nodeMem      = simulated.nodeMem,
                    ping         = GetPlayerPing(src),
                    avgPing      = avgPing,
                    staffInService = getStaffInServiceCount(),
                    uptime       = uptime,
                    -- Nouvelles données
                    totalReports = totalReportsCount or 0,
                    newPlayersToday = newPlayersTodayCount or 0
                })
            end
        end
    end
end)

print('^1[bl_admin] ^0Server Core Initialized and Modules Loaded')

-- ── Version Checker ───────────────────────────────────────────
local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local resourceName = GetCurrentResourceName()

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
    print('^1============================================================^0')
    print(string.format('^1[^3%s^1] UNE MISE À JOUR EST DISPONIBLE !^0', resourceName))
    print(string.format('^1[^3%s^1] Version locale : ^1%s^0 | Version GitHub : ^2%s^0', resourceName, current, latest))
    print(string.format('^1[^3%s^1] Télécharger : ^5https://github.com/Linspecteur/BloodAdmin-v2^0', resourceName))
    print('^1============================================================^0')
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    PerformHttpRequest('https://raw.githubusercontent.com/Linspecteur/BloodAdmin-v2/main/fxmanifest.lua', function(statusCode, response, headers)
        if statusCode == 200 and response then
            local versionMatch = response:match("\n%s*version%s+['\"]([^'\"]+)['\"]")
            if versionMatch then
                if compareVersions(currentVersion, versionMatch) then
                    printModernUpdateCard(currentVersion, versionMatch)
                else
                    print(string.format('^2[^3%s^2] Le script est à jour (Version : %s)^0', resourceName, currentVersion))
                end
            else
                print(string.format('^1[^3%s^1] Impossible de lire la version distante.^0', resourceName))
            end
        else
            -- Si la branche par défaut est 'master' au lieu de 'main'
            PerformHttpRequest('https://raw.githubusercontent.com/Linspecteur/BloodAdmin-v2/master/fxmanifest.lua', function(statusCode2, response2, headers2)
                if statusCode2 == 200 and response2 then
                    local versionMatch = response2:match("\n%s*version%s+['\"]([^'\"]+)['\"]")
                    if versionMatch then
                        if compareVersions(currentVersion, versionMatch) then
                            printModernUpdateCard(currentVersion, versionMatch)
                        else
                            print(string.format('^2[^3%s^2] Le script est à jour (Version : %s)^0', resourceName, currentVersion))
                        end
                    else
                        print(string.format('^1[^3%s^1] Impossible de lire la version distante.^0', resourceName))
                    end
                else
                    print(string.format('^3[^3%s^3] Vérification des mises à jour indisponible (Dépôt privé ou hors-ligne).^0', resourceName))
                end
            end, 'GET')
        end
    end, 'GET')
end)

