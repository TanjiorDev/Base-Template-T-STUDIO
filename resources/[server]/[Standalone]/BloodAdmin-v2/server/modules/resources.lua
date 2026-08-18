-- ============================================================
--  BLOODADMIN — SERVER/MODULES/RESOURCES.LUA
-- ============================================================

function buildResourceList()
    local resources = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        if name and name ~= '_cfx_internal' then
            table.insert(resources, {
                name = name,
                status = GetResourceState(name),
                version = GetResourceMetadata(name, 'version', 0) or '1.0.0',
                author = GetResourceMetadata(name, 'author', 0) or 'Inconnu'
            })
        end
    end
    table.sort(resources, function(a, b) return a.name < b.name end)
    return resources
end

RegisterNetEvent('bl_admin:requestResources')
AddEventHandler('bl_admin:requestResources', function()
    local src = tonumber(source)
    if not AdminPlayers[src] then 
        print(('[bl_admin] Error: %s (#%d) tried to request resources but is not in AdminPlayers'):format(GetPlayerName(src), src))
        return 
    end
    if checkPermission(src, 'bl.resources') or checkPermission(src, 'bl.staff') then
        local resources = buildResourceList()
        print(('[bl_admin] Envoi de %d ressources à %s'):format(#resources, GetPlayerName(src)))
        TriggerClientEvent('bl_admin:updateResources', src, resources)
    else
        print(('[bl_admin] Permission refusée pour les ressources pour %s'):format(GetPlayerName(src)))
    end
end)

RegisterNetEvent('bl_admin:resourceAction')
AddEventHandler('bl_admin:resourceAction', function(name, action)
    local src = tonumber(source)
    if not AdminPlayers[src] then return end
    if not (checkPermission(src, 'bl.resources') or checkPermission(src, 'bl.staff')) then return end

    if action == 'start' then
        StartResource(name)
    elseif action == 'stop' then
        StopResource(name)
    elseif action == 'restart' then
        StopResource(name)
        Wait(200)
        StartResource(name)
    end
    
    addLog('resources', 'RESOURCE_ACTION', GetPlayerName(src), src, name, 0, 'Action : ' .. action:upper())
    Wait(500)
    TriggerClientEvent('bl_admin:updateResources', src, buildResourceList())
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Succès: ' .. action:upper() .. ' sur ' .. name)
end)
