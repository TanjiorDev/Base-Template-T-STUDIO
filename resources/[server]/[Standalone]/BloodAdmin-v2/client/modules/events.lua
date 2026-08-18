-- ============================================================
--  BLOODADMIN — CLIENT/MODULES/EVENTS.LUA
-- ============================================================

RegisterNetEvent('bl_admin:openWithData')
AddEventHandler('bl_admin:openWithData', function(players, staff, bans, resources, config, grade, id, duty, reports, customVehicles)
    print('^2[bl_admin] Received openWithData from server. Grade: ' .. tostring(grade) .. '^0')
    if config then Config = config end
    if grade then playerGrade = grade end
    toggleMenu(false, {
        players = players,
        staff = staff,
        bans = bans,
        resources = resources,
        id = id,
        duty = duty,
        name = GetPlayerName(PlayerId()),
        reports = reports,
        customVehicles = customVehicles
    })
end)

RegisterNetEvent('bl_admin:updateReports')
AddEventHandler('bl_admin:updateReports', function(reports, total)
    SendNUIMessage({ action = 'updateReports', reports = reports, total = total })
end)

RegisterNetEvent('bl_admin:updatePlayers')
AddEventHandler('bl_admin:updatePlayers', function(players)
    SendNUIMessage({ action = 'updatePlayers', players = players })
end)

RegisterNetEvent('bl_admin:updateOfflinePlayers')
AddEventHandler('bl_admin:updateOfflinePlayers', function(offlineList)
    SendNUIMessage({ action = 'updateOfflinePlayers', offlineList = offlineList })
end)

RegisterNetEvent('bl_admin:updateServerMetrics')
AddEventHandler('bl_admin:updateServerMetrics', function(data)
    SendNUIMessage({ action = 'updateServerMetrics', data = data })
end)

RegisterNetEvent('bl_admin:updateResources')
AddEventHandler('bl_admin:updateResources', function(resources)
    SendNUIMessage({ action = 'updateResources', resources = resources })
end)

RegisterNetEvent('bl_admin:updateBans')
AddEventHandler('bl_admin:updateBans', function(bans)
    SendNUIMessage({ action = 'updateBans', bans = bans })
end)

RegisterNetEvent('bl_admin:updateAllStaff')
AddEventHandler('bl_admin:updateAllStaff', function(staff)
    staffList = {}
    for _, s in ipairs(staff) do
        local serverId = tonumber(s.id or s.source)
        if serverId and serverId > 0 then
            staffList[serverId] = { inService = s.inService == true, grade = s.grade }
        end
    end
    SendNUIMessage({ action = 'updateAllStaff', staff = staff })
end)

RegisterNetEvent('bl_admin:updateConfig')
AddEventHandler('bl_admin:updateConfig', function(config, grade)
    if config then Config = config end
    if grade then playerGrade = grade end
    SendNUIMessage({
        action = 'updateConfig',
        config = Config,
        grade = playerGrade
    })
end)

RegisterNetEvent('bl_admin:setGrade')
AddEventHandler('bl_admin:setGrade', function(grade, perms)
    playerGrade = grade
    playerPerms = perms
    SendNUIMessage({ action = 'setGrade', grade = grade, perms = perms })
end)

local isFrozen = false
RegisterNetEvent('bl_admin:freeze')
AddEventHandler('bl_admin:freeze', function()
    isFrozen = not isFrozen
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, isFrozen)
    if isFrozen then
        TriggerEvent('chat:addMessage', {
            args = { 'Admin', 'Vous avez été freeze par un administrateur.' },
            tags = { { label = "SYSTEME", color = "rgba(0, 230, 118, 0.1)", border = "rgba(0, 230, 118, 0.3)", textColor = "#00E676" } }
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { 'Admin', 'Vous avez été unfreeze par un administrateur.' },
            tags = { { label = "SYSTEME", color = "rgba(0, 230, 118, 0.1)", border = "rgba(0, 230, 118, 0.3)", textColor = "#00E676" } }
        })
    end
end)

RegisterNetEvent('bl_admin:notify')
AddEventHandler('bl_admin:notify', function(nType, message)
    SendNUIMessage({ action = 'toast', type = nType, message = message })
end)

RegisterNetEvent('bl_admin:doTeleport')
AddEventHandler('bl_admin:doTeleport', function(x, y, z)
    local ped = PlayerPedId()
    RequestCollisionAtCoord(x, y, z)
    Wait(500)
    SetEntityCoords(ped, x, y, z, false, false, false, true)
end)

RegisterNetEvent('bl_admin:sendCoords')
AddEventHandler('bl_admin:sendCoords', function(adminSrc)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('bl_admin:receiveCoords', adminSrc, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('bl_admin:announce')
AddEventHandler('bl_admin:announce', function(adminName, msg)
    SendNUIMessage({
        action = 'showAnnounce',
        admin = adminName,
        message = msg
    })
    
    -- Optionnel: Message chat aussi
    TriggerEvent('chat:addMessage', {
        color = { 220, 38, 38 },
        multiline = true,
        args = { "[ANNONCE STAFF]", msg }
    })
end)

RegisterNetEvent('bl_admin:wipeEntities')
AddEventHandler('bl_admin:wipeEntities', function(entityType)
    local count = 0
    if entityType == 'peds' or entityType == 'all' then
        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) then
                DeleteEntity(ped)
                count = count + 1
            end
        end
    end
    
    if entityType == 'props' or entityType == 'all' then
        for obj in EnumerateObjects() do
            DeleteEntity(obj)
            count = count + 1
        end
    end
    
    if entityType == 'vehs' or entityType == 'all' then
        for veh in EnumerateVehicles() do
            if GetVehicleNumberOfPassengers(veh) == 0 and IsVehicleSeatFree(veh, -1) then
                DeleteEntity(veh)
                count = count + 1
            end
        end
    end
    
    TriggerEvent('bl_admin:toast', "Nettoyage terminé: " .. count .. " entités supprimées.", "success")
end)

-- Helpers pour les énumérations (souvent manquants)
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

RegisterNetEvent('bl_admin:fixWorld')
AddEventHandler('bl_admin:fixWorld', function()
    local handle, ped = FindFirstPed()
    local success
    repeat
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end)

RegisterNetEvent('bl_admin:wipeProps')
AddEventHandler('bl_admin:wipeProps', function()
    local handle, obj = FindFirstObject()
    local success
    repeat
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
        success, obj = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end)

RegisterNetEvent('bl_admin:clearVehicles')
AddEventHandler('bl_admin:clearVehicles', function()
    local handle, veh = FindFirstVehicle()
    local success
    repeat
        if DoesEntityExist(veh) then
            local pPed = GetPedInVehicleSeat(veh, -1)
            if not IsPedAPlayer(pPed) then
                DeleteEntity(veh)
            end
        end
        success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
end)

RegisterNetEvent('bl_admin:receiveLogs')
AddEventHandler('bl_admin:receiveLogs', function(logs)
    SendNUIMessage({ action = 'updateLogs', logs = logs })
end)

RegisterNetEvent('bl_admin:updateReportsLeaderboard')
AddEventHandler('bl_admin:updateReportsLeaderboard', function(data)
    SendNUIMessage({ action = 'updateReportsLeaderboard', data = data })
end)
RegisterNetEvent('bl_admin:updateStaffChat')
AddEventHandler('bl_admin:updateStaffChat', function(messages)
    SendNUIMessage({ action = 'updateStaffChat', messages = messages })
end)

RegisterNetEvent('bl_admin:updateWarns')
AddEventHandler('bl_admin:updateWarns', function(warns)
    SendNUIMessage({ action = 'updateWarns', warns = warns })
end)

RegisterNetEvent('bl_admin:updateJails')
AddEventHandler('bl_admin:updateJails', function(jails)
    SendNUIMessage({ action = 'updateJails', jails = jails })
end)

RegisterNetEvent('bl_admin:updateGhosts')
AddEventHandler('bl_admin:updateGhosts', function(ghosts)
    SendNUIMessage({ action = 'updateGhosts', ghosts = ghosts })
end)

-- ── GHOST BAN & JAIL LOGIC ──────────────────────────────────
local isGhosted = false
RegisterNetEvent('bl_admin:ghostMode')
AddEventHandler('bl_admin:ghostMode', function(active)
    isGhosted = active
    local ped = PlayerPedId()
    SetEntityVisible(ped, not active, false)
    SetEntityCollision(ped, not active, not active)
    if active then
        TriggerEvent('chat:addMessage', {
            args = { 'Ghost Ban', 'Vous avez été GHOST BAN. Vous êtes seul dans cette dimension.' },
            tags = { { label = "SANCTION", color = "rgba(213, 0, 249, 0.1)", border = "rgba(213, 0, 249, 0.3)", textColor = "#D500F9" } }
        })
    end
end)

RegisterNetEvent('bl_admin:jail')
AddEventHandler('bl_admin:jail', function(coords, expires)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
    TriggerEvent('chat:addMessage', {
        args = { 'Prison', 'Vous avez été envoyé en prison.' },
        tags = { { label = "SANCTION", color = "rgba(213, 0, 249, 0.1)", border = "rgba(213, 0, 249, 0.3)", textColor = "#D500F9" } }
    })
    SendNUIMessage({ action = 'showJailOverlay', expires = expires })
end)

RegisterNetEvent('bl_admin:unjail')
AddEventHandler('bl_admin:unjail', function()
    SendNUIMessage({ action = 'hideJailOverlay' })
end)

RegisterNetEvent('bl_admin:updateCatalog')
AddEventHandler('bl_admin:updateCatalog', function(customVehicles)
    SendNUIMessage({ action = 'updateCatalog', vehicles = customVehicles })
end)

RegisterNetEvent('bl_admin:syncWorldState')
AddEventHandler('bl_admin:syncWorldState', function(worldState)
    SendNUIMessage({ action = 'syncWorldState', worldState = worldState })
end)

RegisterNetEvent('bl_admin:addLiveLog')
AddEventHandler('bl_admin:addLiveLog', function(liveLog)
    SendNUIMessage({ action = 'addLiveLog', liveLog = liveLog })
end)
