local ESX = exports['es_extended']:getSharedObject()
local transferCooldown = {}

local function isValidAmount(amount)
    return type(amount) == 'number'
        and amount == math.floor(amount)
        and amount > 0
        and amount <= Config.MaxGiveAmount
end

RegisterNetEvent('hc_f5:giveCash', function(targetId, amount)
    local sourceId = source
    targetId = tonumber(targetId)
    amount = tonumber(amount)

    if not targetId or targetId == sourceId or not isValidAmount(amount) then return end

    local now = os.time()
    if transferCooldown[sourceId] and transferCooldown[sourceId] >= now then return end
    transferCooldown[sourceId] = now + 1

    local xPlayer = ESX.GetPlayerFromId(sourceId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget then return end

    local sourcePed = GetPlayerPed(sourceId)
    local targetPed = GetPlayerPed(targetId)
    if sourcePed <= 0 or targetPed <= 0 then return end

    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(sourceCoords - targetCoords) > (Config.MaxGiveDistance + 0.5) then return end

    local cash = xPlayer.getAccount('money')
    local balance = cash and tonumber(cash.money) or 0
    if balance < amount then
        xPlayer.showNotification('Vous n\'avez pas assez d\'argent liquide.')
        return
    end

    xPlayer.removeAccountMoney('money', amount, 'F5 cash transfer')
    xTarget.addAccountMoney('money', amount, 'F5 cash transfer')

    xPlayer.showNotification(('Vous avez donné $%s.'):format(amount))
    xTarget.showNotification(('Vous avez reçu $%s.'):format(amount))

    TriggerClientEvent('hc_f5:refreshPlayerData', sourceId)
    TriggerClientEvent('hc_f5:refreshPlayerData', targetId)
end)

AddEventHandler('playerDropped', function()
    transferCooldown[source] = nil
end)
