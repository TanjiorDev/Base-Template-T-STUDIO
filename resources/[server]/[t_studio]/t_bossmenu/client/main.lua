lib.locale()

local function isConfiguredBoss()
    local job = ESX.PlayerData and ESX.PlayerData.job
    if not job then return false end
    for i = 1, #Shared.society do
        local society = Shared.society[i]
        if society.name == job.name and tonumber(job.grade) >= tonumber(society.bossGrade) then
            return true
        end
    end
    return false
end

RegisterNetEvent('ato:societyboss:svopenBossMenu', function()
    TriggerServerEvent('ato:societyboss:svopenBossMenu')
end)

CreateThread(function()
    if Shared.resourceName ~= 'ato_bossmenu' then
        print('[^3ato_bossmenu^7] [^1Error^7] ' .. locale('dont_change_name'))
        StopResource(Shared.resourceName)
        return
    end

    print('[^3ato_bossmenu^7] [^2Success^7] ' .. locale('rsrc_started'))

    if Shared.menuSystem == 'target' then
        if GetResourceState('ox_target') ~= 'started' then
            print('[^3ato_bossmenu^7] [^1Error^7] ox_target is required when Shared.menuSystem = target')
            return
        end

        for i = 1, #Shared.society do
            local society = Shared.society[i]
            exports.ox_target:addBoxZone({
                coords = society.coords,
                size = vec3(3, 3, 3),
                rotation = 45,
                drawSprite = true,
                options = {
                    {
                        event = 'ato:societyboss:svopenBossMenu',
                        icon = 'fa-solid fa-building',
                        label = locale('management') .. society.label,
                        distance = 3,
                        groups = { [society.name] = society.bossGrade }
                    }
                }
            })
        end
    end
end)

RegisterCommand('open_boss_menu', function()
    if Shared.menuSystem ~= 'touch' then return end
    if not isConfiguredBoss() then
        ESX.ShowNotification(BossRageUI.Texts.forbidden)
        return
    end
    TriggerServerEvent('ato:societyboss:svopenBossMenu')
end, false)

RegisterKeyMapping('open_boss_menu', 'Ouvrir le menu patron', 'keyboard', BossRageUI.Key or Shared.keyOpenBossMenu)
