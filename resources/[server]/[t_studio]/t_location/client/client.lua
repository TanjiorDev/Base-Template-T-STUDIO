local ESX = nil
local QBCore = nil
local menuOpen = false
local currentRentalVehicle = nil
local currentRentalTimerActive = false

CreateThread(function()
    while ESX == nil and QBCore == nil do
        Wait(100)

        if Config.Framework == 'esx' then
            ESX = exports['es_extended']:getSharedObject()
        elseif Config.Framework == 'qbcore' then
            QBCore = exports['qb-core']:GetCoreObject()
        else
            print('[tan_location] Veuillez définir Config.Framework sur esx ou qbcore')
            break
        end
    end
end)

local function OpenRentalMenu()
    if menuOpen then return end

    menuOpen = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'open',
        vehicles = Config.Vehicles,
        durations = Config.RentalDurations
    })
end

local function CloseRentalMenu()
    menuOpen = false
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'close'
    })
end

local function FormatTimer(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format('%02d:%02d', minutes, secs)
end

local function DeleteRentalVehicle()
    if currentRentalVehicle and DoesEntityExist(currentRentalVehicle) then
        SetEntityAsMissionEntity(currentRentalVehicle, true, true)
        DeleteVehicle(currentRentalVehicle)
    end

    currentRentalVehicle = nil
    currentRentalTimerActive = false

    SendNUIMessage({
        action = 'rentalTimer',
        show = false
    })
end

local function StartRentalTimer(durationMinutes)
    local durationSeconds = tonumber(durationMinutes or 30) * 60
    local endTime = GetGameTimer() + (durationSeconds * 1000)
    currentRentalTimerActive = true

    CreateThread(function()
        local notifiedFive = false
        local notifiedOne = false

        while currentRentalTimerActive and currentRentalVehicle and DoesEntityExist(currentRentalVehicle) do
            local remaining = math.max(0, math.floor((endTime - GetGameTimer()) / 1000))

            SendNUIMessage({
                action = 'rentalTimer',
                show = true,
                time = FormatTimer(remaining)
            })

            if remaining <= 300 and not notifiedFive and remaining > 60 then
                notifiedFive = true
                lib.notify({
                    title = 'Location',
                    description = 'Il reste 5 minutes avant la fin de la location.',
                    type = 'warning'
                })
            end

            if remaining <= 60 and not notifiedOne and remaining > 0 then
                notifiedOne = true
                lib.notify({
                    title = 'Location',
                    description = 'Il reste 1 minute avant la disparition du véhicule.',
                    type = 'warning'
                })
            end

            if remaining <= 0 then
                break
            end

            Wait(1000)
        end

        if currentRentalVehicle and DoesEntityExist(currentRentalVehicle) then
            DeleteRentalVehicle()

            lib.notify({
                title = 'Location',
                description = 'Votre temps de location est terminé. Le véhicule a été supprimé.',
                type = 'info'
            })
        else
            DeleteRentalVehicle()
        end
    end)
end

RegisterNUICallback('close', function(_, cb)
    CloseRentalMenu()
    cb('ok')
end)

RegisterNUICallback('rentVehicle', function(data, cb)
    if not data or not data.model then
        cb({ success = false })
        return
    end

    TriggerServerEvent('tan_location:rentVehicle', data.model, tonumber(data.duration) or 30)
    cb({ success = true })
end)

RegisterNetEvent('tan_location:spawnVehicle', function(vehicleData, rentalData)
    local model = joaat(vehicleData.model)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    DeleteRentalVehicle()

    local coords = Config.SpawnVehicle
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)

    SetVehicleNumberPlateText(veh, 'LOC' .. math.random(100, 999))
    SetVehicleEngineOn(veh, true, true, false)
    SetEntityAsMissionEntity(veh, true, true)

    currentRentalVehicle = veh

    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(model)

    local duration = rentalData and rentalData.duration or 30
    StartRentalTimer(duration)

    lib.notify({
        title = 'Location',
        description = ('Vous avez loué : %s pendant %s minutes.'):format(vehicleData.label, duration),
        type = 'success'
    })

    CloseRentalMenu()
end)

RegisterNetEvent('tan_location:notify', function(message, notifyType)
    lib.notify({
        title = 'Location',
        description = message,
        type = notifyType or 'info'
    })
end)

CreateThread(function()
    if Config.Blip.enabled then
        local blip = AddBlipForCoord(Config.RentalPoint.x, Config.RentalPoint.y, Config.RentalPoint.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = Config.RentalPoint,
        radius = 1.5,
        debug = false,
        drawSprite = true,

        options = {
            {
                name = 'tstudio_location_vehicle',
                icon = 'fa-solid fa-car',
                label = 'Louer un véhicule',
                distance = Config.OpenDistance or 2.0,

                onSelect = function()
                    OpenRentalMenu()
                end
            }
        }
    })
end)



RegisterCommand(Config.TestCommand, function()
    OpenRentalMenu()
end, false)
