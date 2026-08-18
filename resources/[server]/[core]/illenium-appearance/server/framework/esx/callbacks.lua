if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("esx_skin:getPlayerSkin", function(source, cb)
    local Player = ESX.GetPlayerFromId(source)
    if not Player then
        cb(nil, { skin_male = {}, skin_female = {} })
        return
    end
    local appearance = Framework.GetAppearance(Player.identifier)
    cb(appearance, {
        skin_male = Player.job and Player.job.skin_male or {},
        skin_female = Player.job and Player.job.skin_female or {}
    })
end)

lib.callback.register("illenium-appearance:server:esx:getGradesForJob", function(_, jobName)
    return Database.JobGrades.GetByJobName(jobName)
end)
