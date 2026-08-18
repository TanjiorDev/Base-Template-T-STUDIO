local ESX = nil
local QBCore = nil

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    print('[tan_location] Veuillez définir Config.Framework sur esx ou qbcore')
end

local function GetVehicleByModel(model)
    for _, vehicle in pairs(Config.Vehicles) do
        if vehicle.model == model then
            return vehicle
        end
    end

    return nil
end

local function GetDurationByMinutes(minutes)
    minutes = tonumber(minutes) or 30

    for _, duration in pairs(Config.RentalDurations or {}) do
        if tonumber(duration.minutes) == minutes then
            return duration
        end
    end

    return Config.RentalDurations and Config.RentalDurations[1] or { label = '30 minutes', minutes = 30, multiplier = 1 }
end

local function GetPlayerMoney(src, account)
    if Config.Framework == 'esx' then
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if not xPlayer then return nil end

        if account == 'bank' then
            return xPlayer.getAccount('bank').money, xPlayer
        end

        return xPlayer.getMoney(), xPlayer
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if not Player then return nil end

        local qbAccount = account == 'bank' and 'bank' or 'cash'
        return Player.PlayerData.money[qbAccount] or 0, Player
    end

    return nil
end

local function RemovePlayerMoney(player, account, amount)
    if Config.Framework == 'esx' then
        if account == 'bank' then
            player.removeAccountMoney('bank', amount)
        else
            player.removeMoney(amount)
        end

        return true
    elseif Config.Framework == 'qbcore' then
        local qbAccount = account == 'bank' and 'bank' or 'cash'
        return player.Functions.RemoveMoney(qbAccount, amount, 'vehicle-rental')
    end

    return false
end

RegisterNetEvent('tan_location:rentVehicle', function(model, durationMinutes)
    local src = source

    local vehicle = GetVehicleByModel(model)
    if not vehicle then
        TriggerClientEvent('tan_location:notify', src, 'Véhicule invalide.', 'error')
        return
    end

    local duration = GetDurationByMinutes(durationMinutes)
    local finalPrice = math.floor((vehicle.price or 0) * (duration.multiplier or 1))
    local account = Config.PayAccount or 'bank'

    local money, player = GetPlayerMoney(src, account)
    if not player then
        TriggerClientEvent('tan_location:notify', src, 'Joueur introuvable.', 'error')
        return
    end

    if money < finalPrice then
        TriggerClientEvent('tan_location:notify', src, ('Vous n’avez pas assez d’argent. Prix : %s$'):format(finalPrice), 'error')
        return
    end

    if not RemovePlayerMoney(player, account, finalPrice) then
        TriggerClientEvent('tan_location:notify', src, 'Erreur lors du paiement.', 'error')
        return
    end

    TriggerClientEvent('tan_location:spawnVehicle', src, vehicle, {
        duration = duration.minutes,
        label = duration.label,
        price = finalPrice
    })
end)
