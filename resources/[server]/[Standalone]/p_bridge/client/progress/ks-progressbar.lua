if (Config.ProgressBar == 'auto' and not checkResource('ks-progressbar')) or (Config.ProgressBar ~= 'auto' and Config.ProgressBar ~= 'ks-progressbar') then
    return
end

while not Bridge do
    Citizen.Wait(0)
end

if Config.Debug then
    lib.print.info('[Progress] Loaded: ks-progressbar')
end

Bridge.Progress = {}

Bridge.Progress.Start = function(data)
    if data.canCancel == nil then
        data.canCancel = true
    end

    if data.useWhileDead == nil then
        data.useWhileDead = false
    end

    return lib.progressBar({
        duration = data.duration or 5000,
        label = data.label or 'Processing...',
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        anim = data.anim or nil,
        prop = data.prop or nil,
        disable = data.disable or {move = true, car = true, combat = true}
    })
end

Bridge.Progress.StartCircle = function(data)
    if data.canCancel == nil then
        data.canCancel = true
    end

    if data.useWhileDead == nil then
        data.useWhileDead = false
    end

    return lib.progressCircle({
        duration = data.duration or 5000,
        position = data.position or 'center',
        label = data.label or 'Processing...',
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        anim = data.anim or nil,
        prop = data.prop or nil,
        disable = data.disable or {move = true, car = true, combat = true}
    })
end

Bridge.Progress.isActive = function()
    return lib.progressActive()
end

Bridge.Progress.Cancel = function()
    lib.cancelProgress()
end