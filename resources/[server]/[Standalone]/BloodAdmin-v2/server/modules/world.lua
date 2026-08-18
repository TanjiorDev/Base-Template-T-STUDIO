-- ============================================================
--  BLOODADMIN — SERVER/MODULES/WORLD.LUA
-- ============================================================

WorldState = {
    weather = "EXTRASUNNY",
    hour = 12,
    minute = 0,
    freezeTime = false,
    freezeWeather = false,
    blackout = false
}

function broadcastWorldState()
    TriggerClientEvent('bl_admin:syncWorldState', -1, WorldState)
end

RegisterNetEvent('bl_admin:requestWorldState')
AddEventHandler('bl_admin:requestWorldState', function()
    local src = source
    TriggerClientEvent('bl_admin:syncWorldState', src, WorldState)
end)

RegisterNetEvent('bl_admin:toggleFreezeTime')
AddEventHandler('bl_admin:toggleFreezeTime', function(data)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.world') then return end

    local active = false
    if type(data) == 'table' then active = data.active else active = data end

    ExecuteCommand('freezetime')
    WorldState.freezeTime = active
    broadcastWorldState()
    addLog('world', 'FREEZE_TIME', GetPlayerName(src), src, 'SERVEUR', 0, active and 'Temps figé' or 'Temps libéré')
end)

RegisterNetEvent('bl_admin:toggleFreezeWeather')
AddEventHandler('bl_admin:toggleFreezeWeather', function(data)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.world') then return end

    local active = false
    if type(data) == 'table' then active = data.active else active = data end

    ExecuteCommand('freezeweather')
    WorldState.freezeWeather = active
    broadcastWorldState()
    addLog('world', 'FREEZE_WEATHER', GetPlayerName(src), src, 'SERVEUR', 0, active and 'Météo figée' or 'Météo libérée')
end)

RegisterNetEvent('bl_admin:globalAction')
AddEventHandler('bl_admin:globalAction', function(action)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then 
        TriggerClientEvent('bl_admin:toast', src, "Erreur: Vous devez être en service !", "error")
        return 
    end
    if not checkPermission(src, 'bl.staff') then return end

    if action == 'revive' then
        if not checkPermission(src, 'bl.revive') then return end
        TriggerClientEvent('esx_ambulancejob:revive', -1)
        TriggerClientEvent('bl_admin:toast', -1, "Revive général par un administrateur", "info")
        addLog('moderation', 'REVIVE_ALL', GetPlayerName(src), src, 'SERVEUR', 0, 'Réanimation générale')
    elseif action == 'dv' then
        if not checkPermission(src, 'bl.delveh') then return end
        TriggerClientEvent('bl_admin:clearVehicles', -1)
        addLog('world', 'WIPE_VEH', GetPlayerName(src), src, 'SERVEUR', 0, 'Suppression de tous les véhicules')
    elseif action == 'kickall' then
        if not checkPermission(src, 'bl.kick') then return end
        local players = GetPlayers()
        for _, pId in ipairs(players) do
            if tonumber(pId) ~= src then
                DropPlayer(pId, "Le serveur a été vidé par un administrateur.")
            end
        end
        addLog('moderation', 'KICK_ALL', GetPlayerName(src), src, 'SERVEUR', 0, 'Expulsion de tous les joueurs')
    elseif action == 'clearchat' then
        if not checkPermission(src, 'bl.staff') then return end -- Chat clean is basic staff
        TriggerClientEvent('chat:clear', -1)
        TriggerClientEvent('bl_admin:toast', -1, "Le chat a été nettoyé par un administrateur", "info")
        addLog('world', 'CLEAR_CHAT', GetPlayerName(src), src, 'SERVEUR', 0, 'Nettoyage du chat global')
    elseif action == 'wipepeds' then
        if not checkPermission(src, 'bl.staff') then return end
        TriggerClientEvent('bl_admin:wipeEntities', -1, 'peds')
        addLog('world', 'WIPE_PEDS', GetPlayerName(src), src, 'SERVEUR', 0, 'Suppression des NPCs')
    elseif action == 'wipeprops' then
        if not checkPermission(src, 'bl.staff') then return end
        TriggerClientEvent('bl_admin:wipeEntities', -1, 'props')
        addLog('world', 'WIPE_PROPS', GetPlayerName(src), src, 'SERVEUR', 0, 'Suppression des objets (props)')
    elseif action == 'fixworld' then
        if not checkPermission(src, 'bl.staff') then return end
        TriggerClientEvent('bl_admin:wipeEntities', -1, 'all')
        addLog('world', 'FIX_WORLD', GetPlayerName(src), src, 'SERVEUR', 0, 'Nettoyage complet du monde')
    end
end)

RegisterNetEvent('bl_admin:setWeather')
AddEventHandler('bl_admin:setWeather', function(data)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.world') then return end

    local weather = "EXTRASUNNY"
    if type(data) == 'table' then weather = data.weather else weather = data end

    ExecuteCommand('weather ' .. weather)
    WorldState.weather = weather
    broadcastWorldState()
    addLog('world', 'WEATHER', GetPlayerName(src), src, 'SERVEUR', 0, 'Météo changée en : ' .. weather)
end)

RegisterNetEvent('bl_admin:setTime')
AddEventHandler('bl_admin:setTime', function(data)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.world') then return end

    local hour = 12
    local minute = 0
    if type(data) == 'table' then
        hour = tonumber(data.hour) or 12
        minute = tonumber(data.minute) or 0
    else
        hour = tonumber(data) or 12
    end

    ExecuteCommand('time ' .. hour .. ' ' .. minute)
    WorldState.hour = hour
    WorldState.minute = minute
    broadcastWorldState()
    addLog('world', 'TIME', GetPlayerName(src), src, 'SERVEUR', 0, 'Heure changée en : ' .. hour .. ':' .. minute)
end)

RegisterNetEvent('bl_admin:toggleBlackout')
AddEventHandler('bl_admin:toggleBlackout', function(data)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.world') then return end

    local active = false
    if type(data) == 'table' then active = data.active else active = data end

    ExecuteCommand('blackout')
    WorldState.blackout = active
    broadcastWorldState()
    
    -- Force external sync scripts (like vSync) to instantly broadcast the update to all clients
    ExecuteCommand(('time %d %d'):format(WorldState.hour, WorldState.minute))
    
    addLog('world', 'BLACKOUT', GetPlayerName(src), src, 'SERVEUR', 0, active and 'Blackout activé' or 'Blackout désactivé')
end)

RegisterNetEvent('bl_admin:serverAnnounce')
AddEventHandler('bl_admin:serverAnnounce', function(msg)
    local src = source
    if not AdminPlayers[src] or not AdminDuty[src] then return end
    if not checkPermission(src, 'bl.staff') then return end

    TriggerClientEvent('bl_admin:announce', -1, GetPlayerName(src), msg)
    addLog('world', 'ANNOUNCE', GetPlayerName(src), src, 'SERVEUR', 0, 'Annonce globale : ' .. msg)
end)


