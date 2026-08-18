local PlayerData = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

if Config.EnableStaffCommand then
RegisterCommand(Config.StaffCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local length = string.len(Config.StaffCommand)
    local message = rawCommand:sub(length + 1)
    local currentTime = os.time() -- Obtient l'heure actuelle en secondes depuis l'epoch
    local twoHoursLater = currentTime + (2 * 60 * 60) -- Ajoute 2 heures en secondes
    local newTime = os.date(Config.DateFormat, twoHoursLater) -- Convertit le nouvel horaire en format souhaité
    playerName = xPlayer.getName()

    if isAdmin(xPlayer) then
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message staff"><i class="fas fa-shield-alt"></i> <b><span style="color: #1ebc62">[STAFF] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, message, newTime } -- Utilise le nouvel horaire calculé
        })
    end
end)
end

if Config.EnableStaffOnlyCommand then
	RegisterCommand(Config.StaffOnlyCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.StaffOnlyCommand)
		local message = rawCommand:sub(length + 1)
		local currentTime = os.time() -- Obtient l'heure actuelle en secondes depuis l'epoch
		local twoHoursLater = currentTime + (2 * 60 * 60) -- Ajoute 2 heures en secondes
		local newTime = os.date(Config.DateFormat, twoHoursLater) -- Convertit le nouvel horaire en format souhaité
		playerName = xPlayer.getName()

		if isAdmin(xPlayer) then
			showOnlyForAdmins(function(admins)
				TriggerClientEvent('chat:addMessage', admins, {
					template = '<div class="chat-message staffonly"><i class="fas fa-eye-slash"></i> <b><span style="color: #1ebc62">[STAFF ONLY] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
					args = { playerName, message, newTime }
				})
			end)
		end
	end)
end

function isAdmin(xPlayer)
	for k,v in ipairs(Config.StaffGroups) do
		if xPlayer.getGroup() == v then 
			return true 
		end
	end
	return false
end

function showOnlyForAdmins(admins)
	for k,v in ipairs(ESX.GetPlayers()) do
		if isAdmin(ESX.GetPlayerFromId(v)) then
			admins(v)
		end
	end
end