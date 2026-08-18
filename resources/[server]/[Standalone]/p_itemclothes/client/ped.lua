Ped = {}

function Ped.update(self)
    if not self.ped then
        return
    end

    local model = GetEntityModel(cache.ped)
    if model == `mp_m_freemode_01` or model == `mp_f_freemode_01` then
        local headBlend = Clothes:getHeadBlendData(cache.ped)
        SetPedHeadBlendData(
            self.ped,
            headBlend.shapeFirst,
            headBlend.shapeSecond,
            headBlend.shapeThird,
            headBlend.skinFirst,
            headBlend.skinSecond,
            headBlend.skinThird,
            headBlend.shapeMix,
            headBlend.skinMix,
            headBlend.thirdMix,
            false
        )
    end
    local faceFeatures = Clothes:getFaceFeatures()
    for featureIndex = 0, 19 do
        SetPedFaceFeature(self.ped, featureIndex, faceFeatures[featureIndex])
    end
    for componentId = 0, 11 do
        SetPedComponentVariation(
            self.ped,
            componentId,
            GetPedDrawableVariation(cache.ped, componentId),
            GetPedTextureVariation(cache.ped, componentId),
            GetPedPaletteVariation(cache.ped, componentId)
        )
    end
    for propId = 0, 7 do
        local propIndex = GetPedPropIndex(cache.ped, propId)
        if propIndex ~= -1 then
            ClearPedProp(self.ped, propId)
            SetPedPropIndex(
                self.ped,
                propId,
                propIndex,
                GetPedPropTextureIndex(cache.ped, propId),
                true
            )
        else
            ClearPedProp(self.ped, propId)
        end
    end
end

exports("updatePed", function()
    Ped:update()
end)

local pauseMenuName = 'FE_MENU_VERSION_EMPTY_NO_BACKGROUND'
local pauseMenuHash = joaat(pauseMenuName)

local function clearScreenBlur()
    if IsScreenblurFadeRunning() then
        TriggerScreenblurFadeOut(0)
    end
    ClearTimecycleModifier()
end

function Ped.toggle(self, enabled)
    if not Config.PlayerPed then
        return
    end

    if enabled then
        if self.ped or self.loading then
            return
        end

        self.loading = true

        CreateThread(function()
            Wait(200)
            clearScreenBlur()

            SetFrontendActive(true)

            if GetCurrentFrontendMenuVersion() ~= pauseMenuHash then
                ActivateFrontendMenu(pauseMenuHash, false, -1)
                Wait(150)
            end

            local playerModel = lib.requestModel(GetEntityModel(cache.ped))
            local playerCoords = GetEntityCoords(cache.ped)
            local previewPed = CreatePed(
                26,
                playerModel,
                playerCoords.x,
                playerCoords.y,
                playerCoords.z - 10.0,
                GetEntityHeading(cache.ped),
                false,
                true
            )

            self.ped = previewPed
            ClonePedToTarget(cache.ped, previewPed)
            SetEntityCollision(previewPed, false, false)
            SetEntityAsMissionEntity(previewPed, true, true)
            SetBlockingOfNonTemporaryEvents(previewPed, true)
            SetEntityInvincible(previewPed, true)
            ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
            FreezeEntityPosition(previewPed, true)
            SetPedCombatAbility(previewPed, 0)
            N_0x4668d80430d6c299(previewPed)
            GivePedToPauseMenu(previewPed, Config.PauseMenuPedSlot or 1)
            SetPauseMenuPedLighting(true)
            SetPauseMenuPedSleepState(1)
            SetMouseCursorVisible(false)
            Ped:update()
            self.loading = false

            while self.ped == previewPed do
                SetMouseCursorVisible(false)
                Wait(0)
            end
        end)
    elseif self.ped or self.loading then
        self.loading = false
        local previewPed = self.ped
        self.ped = nil

        if previewPed and DoesEntityExist(previewPed) then
            SetPauseMenuPedLighting(false)
            SetPauseMenuPedSleepState(false)
            GivePedToPauseMenu(previewPed, 0)
            DeleteEntity(previewPed)
        end

        SetFrontendActive(false)

        if GetCurrentFrontendMenuVersion() == pauseMenuHash then
            ActivateFrontendMenu(pauseMenuHash, true, -1)
        end

        ReplaceHudColourWithRgba(117, 0, 0, 0, 200)
    end
end

exports("togglePed", function(enabled)
    Ped:toggle(enabled)
end)

RegisterCommand('pedfix', function()
    Ped:toggle(false)
    Wait(100)
    if LocalPlayer.state.invOpen then
        Ped:toggle(true)
    end
end, false)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == cache.resource or resourceName == 'ox_inventory' then
        Wait(0)
        Ped:toggle(false)
    end
end)

local function onInventoryOpenState(isOpen)
    if not Config.PlayerPed then
        return
    end
    Ped:toggle(isOpen)
end

CreateThread(function()
    while not cache.serverId or cache.serverId == 0 do
        Wait(100)
    end

    AddStateBagChangeHandler('invOpen', ('player:%s'):format(cache.serverId), function(_, _, isOpen)
        onInventoryOpenState(isOpen)
    end)
end)

AddEventHandler('p_itemclothes:togglePed', function(enabled)
    onInventoryOpenState(enabled)
end)
