local ESX = exports['es_extended']:getSharedObject()

local playerLoaded = false
local isConnecting = false
local cameraConnect = nil

local function cleanupConnectionUi()
    SetNuiFocus(false, false)

    if cameraConnect and DoesCamExist(cameraConnect) then
        SetCamActive(cameraConnect, false)
        DestroyCam(cameraConnect, false)
        cameraConnect = nil
    end

    RenderScriptCams(false, false, 0, true, true)
    TriggerScreenblurFadeOut(0)

    local ped = PlayerPedId()
    if ped and ped ~= 0 then
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, false)
    end

    DisplayRadar(true)
end

local function startConnect()
    if isConnecting then return end

    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return
    end

    isConnecting = true
    playerLoaded = false

    SendNUIMessage({ type = 'SET_SHOW_ATH', show = false })
    SendNUIMessage({ action = 'showConnexion' })

    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(0)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    DisplayRadar(false)

    cameraConnect = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
    SetCamCoord(cameraConnect, 911.05352783203, 40.92586517334, 120.77506256104)
    SetCamRot(cameraConnect, 0.0, 0.0, 250.9906311035156, 2)
    SetCamFov(cameraConnect, 90.97)
    ShakeCam(cameraConnect, 'HAND_SHAKE', 0.2)
    SetCamActive(cameraConnect, true)
    RenderScriptCams(true, false, 2000, true, true)
end

local function validateConnect()
    if not isConnecting then return end

    local ped = PlayerPedId()

    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(600)

    if cameraConnect and DoesCamExist(cameraConnect) then
        SetCamActive(cameraConnect, false)
        DestroyCam(cameraConnect, false)
        cameraConnect = nil
    end

    RenderScriptCams(false, false, 0, true, true)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
    TriggerScreenblurFadeOut(500)
    DisplayRadar(true)

    SendNUIMessage({ action = 'hideConnexion' })
    SendNUIMessage({ type = 'SET_SHOW_ATH', show = true })

    isConnecting = false
    playerLoaded = true

    DoScreenFadeIn(500)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    playerLoaded = false

    -- esx_skin confirme que les données d'apparence du joueur sont disponibles
    -- avant d'afficher l'écran d'entrée.
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin == nil then
            print('[enterspawn] Impossible de récupérer le skin du joueur, écran de connexion non affiché.')
            playerLoaded = true
            return
        end

        startConnect()
    end)
end)

RegisterNUICallback('CloseUI', function(_, cb)
    if not isConnecting then
        cb({ ok = false, error = 'not_connecting' })
        return
    end

    validateConnect()
    ESX.ShowNotification('Bon retour parmi nous sur W-Dev')
    cb({ ok = true })
end)

exports('playerLoaded', function()
    return playerLoaded
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    -- Lors d'un restart manuel de la ressource, ne rebloque pas un joueur
    -- déjà connecté. L'événement esx:playerLoaded gère les nouvelles connexions.
    playerLoaded = ESX.PlayerLoaded == true
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    cleanupConnectionUi()
end)
