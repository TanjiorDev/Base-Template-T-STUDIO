-- Project: ato_societyboss
-- ProjetDesc: Resource which allows you to have a management menu for your company at one point or with a direct key.
-- File: shared.lua
-- Author: discord.gg/fivedev
-- Date: 18/12/2023 04:01:55

local Shared <const> = {

    debug = false, -- activates debug messages on the server and client sides
    menuSystem = 'target', -- 'target' = boss menu has precise target | 'touch' = boss menu via a key (anywhere on the map)
    keyOpenBossMenu = 'F7',
    resourceName = GetCurrentResourceName(),
    whiteningPercentage = 0.80, -- Percentage received from the initial price after laundering, 0.80 corresponds to 80%
    maxSalary = 5000,
    unemployedJob = 'unemployed',
    unemployedGrade = 0,

    -- Configure tes webhooks Discord ici. Ils sont laissés vides volontairement.
    logs = {
        recruit = '',
        announce = '',
        washMoney = '',
        reworkGrade = '',
        moneyInteraction = ''
    },

    society = {
        {name = 'police', label = 'LSPD', coords = vec3(461.350283050537,-985.5612597656, 31.19454574585), bossGrade = 4, washMoney = false},
        {name = 'cardealer', label = 'Concessionaire', coords = vec3(-23.630056381226, -1101.4237060547, 26.19454574585), bossGrade = 4, washMoney = true},
        {name = 'ambulance', label = 'Ambulance', coords = vec3(311.80, -568.94, 43.24), bossGrade = 4, washMoney = true},
		{name = 'taxi', label = 'Taxi', coords = vec3(896.07, -164.49, 74.16), bossGrade = 4, washMoney = true},
		{name = 'winemaker', label = 'Vigneron', coords = vec3(-1876.86, 2059.13, 145.45), bossGrade = 3, washMoney = true}
    }

}

_ENV.Shared = Shared

function sendNotify(title, description, icon, iconColor, type)

    if title == nil then
        title = ESX.PlayerData.job.label
    end

    if description == nil then
        description = 'Merci de bien définir la déscription dans la notification'
    end

    if icon == nil then
        icon = 'envelope'
    end

    if iconColor == nil then
        iconColor = '#FFFBFB'
    end

    if type == nil then
        type = 'inform'
    end

    lib.notify({
        title = title,
        description = description,
        position = 'top',
        icon = icon,
        iconColor = iconColor,
        duration = 4000,
        type = type
    })

end

function sendServerNotify(player, title, message, type)
    TriggerClientEvent('ox_lib:notify', player, {
        title = title,
        description = message,
        position = 'top',
        duration = 5000,
        type =  type,
    })
end
