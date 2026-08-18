local mp_m_freemode_01 = `mp_m_freemode_01`
local mp_f_freemode_01 = `mp_f_freemode_01`

local SpawnCoords = Config.Spawn[math.random(#Config.Spawn)]

if ESX.GetConfig().Multichar then
    local canRelog, cam, spawned = true, nil, nil
    local Characters = {}
    local characterSlots = 1
    local selectedCharacter = nil
    local menuOpen = false

    local rageConfig = Config.RageUI or {}
    local menuConfig = rageConfig.Menu or {}
    local texts = rageConfig.Texts or {}
    local position = menuConfig.Position or { X = 0, Y = 0 }

    local mainMenu = RageUI.CreateMenu(menuConfig.Title or 'MULTICHARACTER', texts.MainSubtitle or 'Sélectionnez votre personnage', position.X or 0, position.Y or 0)
    local optionsMenu = RageUI.CreateSubMenu(mainMenu, menuConfig.Title or 'MULTICHARACTER', texts.OptionsSubtitle or 'Options du personnage')
    local deleteMenu = RageUI.CreateSubMenu(optionsMenu, menuConfig.Title or 'MULTICHARACTER', texts.DeleteSubtitle or 'Confirmation de suppression')

    local closable = menuConfig.Closable == true
    mainMenu.Closable = closable
    optionsMenu.Closable = closable
    deleteMenu.Closable = closable

    local maxVisibleItems = tonumber(menuConfig.MaxVisibleItems) or 13
    mainMenu.Pagination.Maximum = maxVisibleItems
    optionsMenu.Pagination.Maximum = maxVisibleItems
    deleteMenu.Pagination.Maximum = maxVisibleItems

    local rectangleBanner = menuConfig.Colors and menuConfig.Colors.RectangleBanner
    if rectangleBanner and rectangleBanner.Active then
        mainMenu:SetRectangleBanner(rectangleBanner.R, rectangleBanner.G, rectangleBanner.B, rectangleBanner.A)
        optionsMenu:SetRectangleBanner(rectangleBanner.R, rectangleBanner.G, rectangleBanner.B, rectangleBanner.A)
        deleteMenu:SetRectangleBanner(rectangleBanner.R, rectangleBanner.G, rectangleBanner.B, rectangleBanner.A)
    end

    local function closeMenus()
        menuOpen = false
        RageUI.Visible(mainMenu, false)
        RageUI.Visible(optionsMenu, false)
        RageUI.Visible(deleteMenu, false)
    end

    local function getFreeSlot()
        for i = 1, characterSlots do
            if not Characters[i] then
                return i
            end
        end
    end

    local function requestAnimDict(dict)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end

    local function setupCharacter(index)
        if not index or not Characters[index] then return end
        if spawned == index then return end

        local character = Characters[index]
        if not character.model and character.skin then
            if character.skin.model then
                character.model = character.skin.model
            elseif character.skin.sex == 1 then
                character.model = mp_f_freemode_01
            else
                character.model = mp_m_freemode_01
            end
        end

        if not spawned then
            exports.spawnmanager:spawnPlayer({
                x = SpawnCoords.x,
                y = SpawnCoords.y,
                z = SpawnCoords.z,
                heading = SpawnCoords.w,
                model = character.model or mp_m_freemode_01,
                skipFade = true
            }, function()
                canRelog = false
                local skin = character.skin or Config.Default
                if not character.model then
                    skin.sex = character.sex == TranslateCap('female') and 1 or 0
                end
                TriggerEvent('skinchanger:loadSkin', skin)
                DoScreenFadeIn(600)
            end)
            repeat Wait(200) until not IsScreenFadedOut()
        elseif character.skin then
            if Characters[spawned] and Characters[spawned].model and character.model then
                RequestModel(character.model)
                while not HasModelLoaded(character.model) do
                    Wait(0)
                end
                SetPlayerModel(PlayerId(), character.model)
                SetModelAsNoLongerNeeded(character.model)
            end
            TriggerEvent('skinchanger:loadSkin', character.skin)
        end

        spawned = index
        local playerPed = PlayerPedId()
        FreezeEntityPosition(playerPed, true)
        SetPedAoBlobRendering(playerPed, true)
        SetEntityAlpha(playerPed, 255, false)
    end

    local function openCharacterMenu()
        if menuOpen then return end
        menuOpen = true
        RageUI.Visible(mainMenu, true)

        CreateThread(function()
            while menuOpen do
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Separator(('~r~%s~s~'):format(texts.SelectCharacter or TranslateCap('select_char')))

                    local count = 0
                    for slot = 1, characterSlots do
                        local character = Characters[slot]
                        if character then
                            count = count + 1
                            local label = ('%s %s'):format(character.firstname or '', character.lastname or '')
                            local disabled = character.disabled == true

                            RageUI.Button(
                                label,
                                disabled and (texts.DisabledCharacterDescription or TranslateCap('char_disabled_description')) or (texts.CharacterDescription or 'Métier : %s | Banque : $%s | Liquide : $%s'):format(
                                    character.job or texts.NoJob or 'Aucun',
                                    character.bank or 0,
                                    character.money or 0
                                ),
                                { RightLabel = disabled and ('~r~' .. (texts.Disabled or 'Désactivé')) or (texts.CharacterRightLabel or '→→') },
                                true,
                                {
                                    onActive = function()
                                        setupCharacter(slot)
                                    end,
                                    onSelected = function()
                                        selectedCharacter = slot
                                        setupCharacter(slot)
                                        RageUI.Visible(optionsMenu, true)
                                    end
                                },
                                optionsMenu
                            )
                        end
                    end

                    if count < characterSlots then
                        RageUI.Button(
                            texts.CreateCharacter or TranslateCap('create_char'),
                            texts.CreateCharacterDescription or 'Créer un nouveau personnage dans un emplacement libre.',
                            { RightLabel = texts.CreateCharacterRightLabel or '+' },
                            true,
                            {
                                onSelected = function()
                                    local slot = getFreeSlot()
                                    if not slot then return end
                                    closeMenus()
                                    TriggerServerEvent('esx_multicharacter:CharacterChosen', slot, true)
                                    TriggerEvent('esx_identity:showRegisterIdentity')
                                    local playerPed = PlayerPedId()
                                    SetPedAoBlobRendering(playerPed, false)
                                    SetEntityAlpha(playerPed, 0, false)
                                end
                            }
                        )
                    end
                end)

                RageUI.IsVisible(optionsMenu, function()
                    local character = selectedCharacter and Characters[selectedCharacter]
                    if not character then
                        RageUI.Separator('~r~' .. (texts.CharacterNotFound or 'Personnage introuvable'))
                        return
                    end

                    RageUI.Separator(('~r~%s %s~s~'):format(character.firstname or '', character.lastname or ''))
                    RageUI.Separator((texts.JobAndGrade or 'Métier : ~r~%s~s~ | Grade : ~r~%s~s~'):format(character.job or texts.NoJob or 'Aucun', character.job_grade or '0'))
                    RageUI.Separator((texts.BirthDate or 'Date de naissance : ~r~%s~s~'):format(character.dateofbirth or texts.UnknownFemale or 'Inconnue'))
                    RageUI.Separator((texts.Money or 'Banque : ~b~$%s~s~ | Liquide : ~g~$%s~s~'):format(character.bank or 0, character.money or 0))
                    RageUI.Separator((texts.Sex or 'Sexe : ~r~%s~s~'):format(character.sex or texts.Unknown or 'Inconnu'))

                    if not character.disabled then
                        RageUI.Button(texts.PlayCharacter or TranslateCap('char_play'), texts.PlayCharacterDescription or TranslateCap('char_play_description'), { RightLabel = texts.PlayRightLabel or '→' }, true, {
                            onSelected = function()
                                closeMenus()
                                TriggerServerEvent('esx_multicharacter:CharacterChosen', selectedCharacter, false)
                            end
                        })
                    else
                        RageUI.Button(texts.DisabledCharacter or TranslateCap('char_disabled'), texts.DisabledCharacterDescription or TranslateCap('char_disabled_description'), { RightLabel = texts.DisabledRightLabel or '~r~X' }, false, {})
                    end

                    if Config.CanDelete then
                        RageUI.Button(texts.DeleteCharacter or TranslateCap('char_delete'), texts.DeleteCharacterDescription or TranslateCap('char_delete_description'), { RightLabel = texts.DeleteRightLabel or '~r~X' }, true, {}, deleteMenu)
                    end
                end)

                RageUI.IsVisible(deleteMenu, function()
                    local character = selectedCharacter and Characters[selectedCharacter]
                    if not character then return end

                    RageUI.Separator(texts.DeleteWarning or '~r~ATTENTION~s~')
                    RageUI.Separator((texts.DeleteQuestion or 'Supprimer %s %s ?'):format(character.firstname or '', character.lastname or ''))
                    RageUI.Separator(texts.DeleteIrreversible or 'Cette action est irréversible.')

                    RageUI.Button(texts.DeleteConfirm or 'Oui, supprimer', texts.DeleteConfirmDescription or TranslateCap('char_delete_yes_description'), { RightLabel = texts.DeleteConfirmRightLabel or '~r~X' }, true, {
                        onSelected = function()
                            RageUI.Visible(deleteMenu, false)
                            RageUI.Visible(optionsMenu, false)
                            TriggerServerEvent('esx_multicharacter:DeleteCharacter', selectedCharacter)
                            spawned = false
                            selectedCharacter = nil
                        end
                    })

                    RageUI.Button(texts.Return or TranslateCap('return'), texts.ReturnDescription or TranslateCap('char_delete_no_description'), { RightLabel = texts.ReturnRightLabel or '←' }, true, {}, optionsMenu)
                end)

                Wait(0)
            end
        end)
    end

    local function startLoop()
        hidePlayers = true
        MumbleSetVolumeOverride(PlayerId(), 0.0)

        CreateThread(function()
            local configuredControls = rageConfig.Controls or {}
            local keys = {
                configuredControls.Up or 172,
                configuredControls.Down or 173,
                configuredControls.Left or 174,
                configuredControls.Right or 175,
                configuredControls.Select or 201,
                configuredControls.Back or 177
            }

            for _, controlId in ipairs(configuredControls.ExtraEnabled or {}) do
                keys[#keys + 1] = controlId
            end

            while hidePlayers do
                DisableAllControlActions(0)
                for i = 1, #keys do
                    EnableControlAction(0, keys[i], true)
                end
                SetEntityVisible(PlayerPedId(), false, false)
                SetLocalPlayerVisibleLocally(true)
                SetPlayerInvincible(PlayerId(), true)
                ThefeedHideThisFrame()
                HideHudComponentThisFrame(11)
                HideHudComponentThisFrame(12)
                HideHudComponentThisFrame(21)
                HideHudAndRadarThisFrame()

                local vehicles = GetGamePool('CVehicle')
                for i = 1, #vehicles do
                    SetEntityLocallyInvisible(vehicles[i])
                end
                Wait(0)
            end

            local playerId, playerPed = PlayerId(), PlayerPedId()
            MumbleSetVolumeOverride(playerId, -1.0)
            SetEntityVisible(playerPed, true, false)
            SetPlayerInvincible(playerId, false)
            FreezeEntityPosition(playerPed, false)
            Wait(10000)
            canRelog = true
        end)

        CreateThread(function()
            local playerPool = {}
            while hidePlayers do
                local players = GetActivePlayers()
                for i = 1, #players do
                    local player = players[i]
                    if player ~= PlayerId() and not playerPool[player] then
                        playerPool[player] = true
                        NetworkConcealPlayer(player, true, true)
                    end
                end
                Wait(500)
            end
            for player in pairs(playerPool) do
                NetworkConcealPlayer(player, false, false)
            end
        end)
    end

    CreateThread(function()
        while not ESX.PlayerLoaded do
            Wait(100)
            if NetworkIsPlayerActive(PlayerId()) then
                exports.spawnmanager:setAutoSpawn(false)
                DoScreenFadeOut(0)
                TriggerEvent('esx_multicharacter:SetupCharacters')
                break
            end
        end
    end)

    RegisterNetEvent('esx_multicharacter:SetupCharacters', function()
        ESX.PlayerLoaded = false
        ESX.PlayerData = {}
        spawned = false
        selectedCharacter = nil
        closeMenus()

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true, false, false, false)
        SetEntityHeading(playerPed, SpawnCoords.w)

        local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.7, 0.4)
        DoScreenFadeOut(0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        SetCamCoord(cam, offset.x, offset.y, offset.z)
        PointCamAtCoord(cam, SpawnCoords.x, SpawnCoords.y, SpawnCoords.z + 1.3)

        startLoop()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        TriggerEvent('esx:loadingScreenOff')
        Wait(200)
        TriggerServerEvent('esx_multicharacter:SetupCharacters')
    end)

    RegisterNetEvent('esx_multicharacter:SetupUI', function(data, slots)
        DoScreenFadeOut(0)
        Characters = data or {}
        characterSlots = slots or 1
        selectedCharacter = nil
        local firstCharacter = next(Characters)
        exports.spawnmanager:forceRespawn()

        if not firstCharacter then
            exports.spawnmanager:spawnPlayer({
                x = SpawnCoords.x,
                y = SpawnCoords.y,
                z = SpawnCoords.z,
                heading = SpawnCoords.w,
                model = mp_m_freemode_01,
                skipFade = true
            }, function()
                canRelog = false
                DoScreenFadeIn(400)
                Wait(400)
                local playerPed = PlayerPedId()
                SetPedAoBlobRendering(playerPed, false)
                SetEntityAlpha(playerPed, 0, false)
                TriggerServerEvent('esx_multicharacter:CharacterChosen', 1, true)
                TriggerEvent('esx_identity:showRegisterIdentity')
            end)
        else
            setupCharacter(firstCharacter)
            requestAnimDict('friends@frj@ig_1')
            TaskPlayAnim(PlayerPedId(), 'friends@frj@ig_1', 'wave_b', 2.0, 1.0, 2500, 16, 0.0, false, false, false)
            openCharacterMenu()
        end
    end)

    RegisterNetEvent('esx:playerLoaded', function(playerData, isNew, skin)
        closeMenus()
        local spawn = playerData.coords or Config.Spawn

        if isNew or not skin or #skin == 1 then
            local finished = false
            skin = Config.Default[playerData.sex]
            skin.sex = playerData.sex == 'm' and 0 or 1
            local model = skin.sex == 0 and mp_m_freemode_01 or mp_f_freemode_01
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)

            TriggerEvent('skinchanger:loadSkin', skin, function()
                local playerPed = PlayerPedId()
                SetPedAoBlobRendering(playerPed, true)
                ResetEntityAlpha(playerPed)
                TriggerEvent('esx_skin:openSaveableMenu', function()
                    finished = true
                end, function()
                    finished = true
                end)
            end)
            repeat Wait(200) until finished
        end

        SetCamActive(cam, false)
        RenderScriptCams(false, false, 0, true, true)
        cam = nil

        local playerPed = PlayerPedId()
        FreezeEntityPosition(playerPed, true)
        SetEntityCoordsNoOffset(playerPed, spawn.x, spawn.y, spawn.z, false, false, false, true)
        SetEntityHeading(playerPed, spawn.heading)
        if not isNew then
            TriggerEvent('skinchanger:loadSkin', skin or (Characters[spawned] and Characters[spawned].skin))
        end

        Wait(400)
        DoScreenFadeIn(400)
        TriggerServerEvent('esx:onPlayerSpawn')
        TriggerEvent('esx:onPlayerSpawn')
        TriggerEvent('playerSpawned')
        TriggerEvent('esx:restoreLoadout')
        Characters, hidePlayers = {}, false
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        closeMenus()
        DoScreenFadeOut(500)
        Wait(1000)
        spawned = false
        TriggerEvent('esx_multicharacter:SetupCharacters')
        TriggerEvent('esx_skin:resetFirstSpawn')
    end)

    if Config.Relog then
        RegisterCommand('relog', function()
            if canRelog then
                canRelog = false
                TriggerServerEvent('esx_multicharacter:relog')
                ESX.SetTimeout(10000, function()
                    canRelog = true
                end)
            end
        end)
    end
end
