if not Framework.ESX() then return end

local client = client
local firstSpawn = false

AddEventHandler("esx_skin:resetFirstSpawn", function()
    firstSpawn = true
end)

AddEventHandler("esx_skin:playerRegistered", function()
    if(firstSpawn) then
        InitializeCharacter(Framework.GetGender(true))
    end
end)

RegisterNetEvent("skinchanger:loadSkin2", function(ped, skin)
    if not skin.model then skin.model = "mp_m_freemode_01" end
    client.setPedAppearance(ped, skin)
    Framework.CachePed()
end)

RegisterNetEvent("skinchanger:getSkin", function(cb)
    if DoesEntityExist(cache.ped) then
        local appearance = client.getPedAppearance(cache.ped)
        if appearance and appearance.model then
            if cb then cb(appearance) end
            Framework.CachePed()
            return
        end
    end
    lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
        if not appearance and DoesEntityExist(cache.ped) then
            appearance = client.getPedAppearance(cache.ped)
        end
        if cb then cb(appearance) end
        Framework.CachePed()
    end)
end)


local function LoadSkin(skin, cb)
    local status, err = pcall(function()
        if type(skin) == "table" and skin.model then
            client.setPlayerAppearance(skin)
        else
            SetInitialClothes(Config.InitialPlayerClothes[Framework.GetGender(true)])
        end
        if Framework.PlayerData and Framework.PlayerData.loadout then
            TriggerEvent("esx:restoreLoadout")
        end
        Framework.CachePed()
    end)
    if not status then
        print("^1[illenium-appearance] Error in LoadSkin:^7", err)
    end
    if cb ~= nil then
        cb()
    end
end

RegisterNetEvent("skinchanger:loadSkin", function(skin, cb)
    LoadSkin(skin, cb)
end)

local function loadClothes(_, clothes)
    local components = Framework.ConvertComponents(clothes, client.getPedComponents(cache.ped))
    local props = Framework.ConvertProps(clothes, client.getPedProps(cache.ped))

    client.setPedComponents(cache.ped, components)
    client.setPedProps(cache.ped, props)
end

RegisterNetEvent("skinchanger:loadClothes", function(_, clothes)
    loadClothes(_, clothes)
end)

RegisterNetEvent("esx_skin:openSaveableMenu", function(onSubmit, onCancel)
    InitializeCharacter(Framework.GetGender(true), onSubmit, onCancel)
end)

local function exportHandler(exportName, func)
  AddEventHandler(('__cfx_export_skinchanger_%s'):format(exportName), function(setCB)
      setCB(func)
  end)
end

exportHandler("GetSkin", function()
    if DoesEntityExist(cache.ped) then
        local appearance = client.getPedAppearance(cache.ped)
        if appearance and appearance.model then
            return appearance
        end
    end

    local appearance = lib.callback.await("illenium-appearance:server:getAppearance", false)
    if not appearance and DoesEntityExist(cache.ped) then
        appearance = client.getPedAppearance(cache.ped)
    end
    return appearance
end)

exportHandler("LoadSkin", function(skin)
    return LoadSkin(skin)
end)

exportHandler("LoadClothes", function(playerSkin, clothesSkin)
    return loadClothes(playerSkin, clothesSkin)
end)
