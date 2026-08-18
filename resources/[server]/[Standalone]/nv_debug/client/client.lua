--/*=================================================================*\
--/* By: 			|	Nevera Development    						|
--/* FiveM: 		|	https://forum.cfx.re/u/neveradevelopment	|
--/* Discord: 		|	https://discord.gg/tw28AqrgWU    			|
--/*=================================================================*/
--/* If you have any problems you can contact us via discord. <3    */

local selectedEntity
local selectedEntityForMarker
local raycastMarker
local marker
local isInEditor
local zoneInEdit
local godmode = false
local oxZones = {}

local options = {
	{     
		label = "Entity Menu", icon="fas fa-bug", iconColor = "orange", distance = 10,
		canInteract = function(a,b, coords) 
			local type = GetEntityType(a)
			if a and type > 0 then
				if not marker or selectedEntityForMarker ~= a then
					local entC = GetEntityCoords(a)
					if type == 1 then
						marker = lib.marker.new({ type = 1, coords = vec3(entC.x,entC.y,entC.z-1), color = { r = 255, g = 0, b = 0, a = 255 }, width = 0.3, height = 5 })
					end
					if type == 2 then 
						marker = lib.marker.new({ type = 1, coords = vec3(entC.x,entC.y,entC.z), color = { r = 0, g = 255, b = 0, a = 255 }, width = 0.3, height = 5 })
					end
					if type == 3 then
						marker = lib.marker.new({ type = 1, coords = vec3(entC.x,entC.y,entC.z), color = { r = 255, g = 255, b = 0, a = 255 }, width = 0.3, height = 5 })
					end
					selectedEntityForMarker = a
				end
				return true
			end
		end,

		onSelect = function(data)
			selectedEntity = data.entity
			local entityExist = GetEntityType(selectedEntity) > 0
			if not selectedEntity then showNotification("Error","Entity not found") return end
			local isVehicle = GetEntityType(selectedEntity) == 2
			local isPed = GetEntityType(selectedEntity) == 1
			local items = {
				pedItem = {
					title = 'Ped menu',
					iconColor = "orange",
					disabled = not isPed,
					menu = 'pedMenu',
					icon = 'person'
				},
				vehicleItem = {
					title = 'Vehicle menu',
					iconColor = "orange",
					disabled = not isVehicle,
					menu = 'vehicleMenu',
					icon = 'car'
				},
			}

			if not isPed then items.pedItem = {disabled=true,title="Ped menu (Unavailable)"} end
			if not isVehicle then items.vehicleItem = {disabled=true,title="Vehicle menu (Unavailable)"} end

			lib.registerContext({
				id = 'debugMenu',
				title = "Debug Menu",
				onExit = function()
					selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Freeze position',
					icon="lock",
					iconColor = "#64abcc",
					
					disabled = not entityExist,
					onSelect=function() 
						local check = IsEntityPositionFrozen(selectedEntity)
						FreezeEntityPosition(selectedEntity, not check)
						showNotification("Success","Entity frozen: "..tostring(not check))
						lib.showContext('debugMenu')
					end
				},
				{ 
					title = 'Set Visibility',
					icon="eye",
					iconColor = "#64abcc",
					
					disabled = not entityExist,
					onSelect=function() 
						local input = lib.inputDialog('Change Alhpa', {
							{type = 'number', label = 'Alpha:', placeholder=100, required = true, min=0, max=255},
						})
						if not input then return end
						SetEntityAlpha(selectedEntity,input[1])
						showNotification("Success","Entity alhpa: "..tostring(not input[1]))
					end
				},
				{ 
					title = 'Get entity info',
					iconColor = "orange",
					icon="circle-info",
					disabled = not entityExist,
					
					menu="entityInfoMenu",
				},
				items.vehicleItem,
				items.pedItem,
				{ 
					title = 'Create Target (Entity)',
					icon="expand",
					iconColor = "#1dd12c",
					
					onSelect=function() 

						local entityCoords = GetEntityCoords(selectedEntity)
						local input = lib.inputDialog('Create Object Target', {
							{type = 'input', label = 'Name:',    required = true,default="Debug target"},
							{type = 'number', label = 'Distance:',    required = true, min=1, max=10, default=3},
							{type = 'input', label = 'Icon:',    required = true, default="hand"},
							{type = 'color', label = 'Icon color:',    required = true, default="#f824ff"},
							{type = 'textarea', label = 'onSelect:',    required = true, autosize=true,max=100,default=[[print("onSelect")]]}})
						if not input then return end
						local msg = string.format([[
-- [TARGET] %s
exports.ox_target:addModel({"%s"},{{
	label="%s",
	icon="fas fa-%s",
	distance=%f,
	iconColor="%s",
	onSelect = function(data)
		%s
	end
}})]],input[1], GetEntityArchetypeName(selectedEntity), input[1],input[3],input[2],input[4],input[5])
						exports.ox_target:addModel({GetEntityArchetypeName(selectedEntity)},{{
							label=input[1],
							icon="fas fa-"..input[3],
							distance=input[2],
							iconColor=input[4],
							onSelect = function(data)
								lib.alertDialog({ header = "[DEBUG] - "..input[1], content = 'This is target debug alert.', centered = true, cancel = true })
							end
						}})
						lib.setClipboard(msg)
						showNotification("Copied","OX Target (Entity)")
					end
				},
				{ 
					title = 'Delete entity',
					icon="trash",
					iconColor="red",
					disabled = not entityExist,
					
					onSelect=function() 
						showNotification("Success","Entity removed: "..tostring(GetEntityArchetypeName(selectedEntity)))
						SetEntityAsMissionEntity(selectedEntity, true, true)
						DeleteObject(selectedEntity) 
						DeleteEntity(selectedEntity)
					end
				},
				}
			})


			lib.registerContext({
				id = 'entityInfoMenu',
				title = "Entity Informations",
				menu = "debugMenu",
				onExit = function()
				selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Copy entity name',
					icon="font",
					iconColor = "#64abcc",
					
					onSelect=function() 
						lib.setClipboard(tostring(GetEntityArchetypeName(selectedEntity)))
						showNotification("Copied","Entity name: "..tostring(GetEntityArchetypeName(selectedEntity)))
						lib.showContext('debugMenu')
					end
				},
				{ 
					title = 'Copy Position',
					iconColor = "#64abcc",
					icon="arrows-up-down-left-right",
					
					onSelect=function() lib.setClipboard(tostring(GetEntityCoords(selectedEntity))) lib.showContext("entityInfoMenu") showNotification("Copied","Entity position.") end
				},
				{ 
					title = 'Copy Rotation',
					iconColor = "#64abcc",
					icon="rotate",
					
					onSelect=function() lib.setClipboard(tostring(GetEntityRotation(selectedEntity))) lib.showContext("entityInfoMenu") showNotification("Copied","Entity rotation.") end
				},
				{ 
					title = 'Copy Heading',
					iconColor = "#64abcc",
					icon="rotate-left",
					
					onSelect=function() lib.setClipboard(tostring(GetEntityHeading(selectedEntity))) lib.showContext("entityInfoMenu") showNotification("Copied","Entity heading.") end
				},
				}
			})

			lib.registerContext({
				id = 'vehicleMenu',
				title = "Vehicle Menu",
				menu = "debugMenu",
				onExit = function()
				selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Change color',
					icon="palette",
					iconColor = "#64abcc",
					
					menu = "vehicleMenuColor",
				},
				{ 
					title = 'Fuel level',
					icon="gas-pump",
					iconColor = "#64abcc",
					
					onSelect = function()
						local input = lib.inputDialog('Fuel level', {
							{type = 'number', label = 'Fuel level (0-100):',    placeholder=100, required = true, min = 1, max = 100},
						})
						if not input then return end
						local level = tonumber(input[1])+0.0
						SetVehicleFuelLevel(selectedEntity,level)
						showNotification("Success","Fuel set: "..tostring(level).."%")
					end
				},
				{ 
					title = 'Fix',
					icon="gear",
					iconColor = "#64abcc",
					
					onSelect=function() 
						SetVehicleFixed(selectedEntity)
						SetVehicleDirtLevel(selectedEntity, 0.0)
						SetVehicleEngineHealth(selectedEntity, 1000.0)
						SetVehiclePetrolTankHealth(selectedEntity, 1000.0)
						lib.showContext("vehicleMenu")
						showNotification("Fix","Vehicle fixed.")
					end
				},
				}
			})

			lib.registerContext({
				id = 'vehicleMenuColor',
				title = "Change Vehicle Color",
				menu = "vehicleMenu",
				onExit = function()
				selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Black color',
					icon="droplet",
					iconColor = "black",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 0, 0) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Red color',
					icon="droplet",
					iconColor = "red",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 27, 27) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Orange color',
					icon="droplet",
					iconColor = "orange",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 38, 38) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Blue color',
					iconColor = "blue",
					icon="droplet",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 70, 70) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Green color',
					iconColor = "green",
					icon="droplet",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 55, 55) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Purple color',
					iconColor = "purple",
					icon="droplet",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 148, 148) lib.showContext("vehicleMenuColor") end
				},
				{ 
					title = 'Pink color',
					iconColor = "pink",
					icon="droplet",
					
					onSelect=function()    SetVehicleColours(selectedEntity, 135, 135) lib.showContext("vehicleMenuColor") end
				}
				}
			})

			lib.registerContext({
				id = 'pedMenu',
				title = "Ped Menu",
				menu = "debugMenu",
				onExit = function()
				selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Give weapon',
					icon="gun",
					iconColor = "#64abcc",
					
					onSelect = function()
						GiveWeaponToPed(selectedEntity, GetHashKey("weapon_assaultrifle"), 255, false, true)
						GiveWeaponToPed(selectedEntity, GetHashKey("weapon_pistol"), 255, false, true)
						SetCurrentPedWeapon(selectedEntity, GetHashKey("weapon_assaultrifle"), true)
						showNotification("Success","AK47 + Pistol added.")
						lib.showContext("pedMenu")
					end,
				},
				{ 
					title = 'Ragdoll Ped',
					icon="person",
					iconColor = "#64abcc",
					
					onSelect = function()
						SetPedToRagdoll(selectedEntity,20000)
						showNotification("Success","Ped ragdoll for 20 seconds")
						lib.showContext("pedMenu")
					end,
				},
				{ 
					title = 'Heal Ped',
					icon="heart",
					iconColor = "#64abcc",
					
					onSelect = function()
						SetEntityHealth(selectedEntity,100)
						showNotification("Success","Entity health: 100%")
						lib.showContext("pedMenu")
					end,
				},
				{ 
					title = 'Clear All Tasks',
					icon="stop",
					iconColor = "#64abcc",
					
					onSelect = function()
						ClearPedTasks(selectedEntity)
						showNotification("Success","All task stopped.")
						lib.showContext("pedMenu")
					end
				},
				{ 
					title = 'Play animation',
					icon="film",
					iconColor = "#64abcc",
					
					onSelect = function()
						local input = lib.inputDialog('Animations', {
							{type = 'input', label = 'Dictionary name:', placeholder="anim@mp_player_intuppersalute", required = false, min = 1, max = 124},
							{type = 'input', label = 'Animation name:', placeholder="idle_a", required = false, min = 1, max = 124},
						})
						if not input then return end
						local dictionary = input[1]
						local name = input[2]
						if not dictionary or dictionary == "" or dictionary == " " then dictionary = "anim@mp_player_intuppersalute" end 
						if not name or name == "" or name == " " then name = "idle_a" end 
						if not checkAnimation(dictionary,name) then showNotification("Error","That animation doesn't exist.") return end
						ClearPedTasksImmediately(selectedEntity)
						TaskPlayAnim(selectedEntity, dictionary, name, 8.0, -8.0, -1, 0, 0, false, false, false)
						lib.showContext("pedMenu")
					end
				},
				{ 
					title = 'Play scenario',
					icon="play",
					iconColor = "#64abcc",
					
					onSelect = function()
						local input = lib.inputDialog('Animations', {
							{type = 'input', label = 'Scenario name:', placeholder = 'WORLD_HUMAN_PARTYING', required = false, min = 1, max = 124},
						})
						if not input then return end
						local scenario = input[1]
						if not scenario or scenario == "" or scenario == " " then scenario = "WORLD_HUMAN_PARTYING" end 
						ClearPedTasksImmediately(selectedEntity)
						TaskStartScenarioInPlace(selectedEntity, scenario, 0)
						showNotification("Success","Scenario: "..tostring(scenario))
						lib.showContext("pedMenu")
					end
				},
				{ 
					title = 'Kill Ped',
					icon="skull",
					iconColor = "red",
					
					onSelect = function()
						showNotification("Success","Ped killed.")
						SetEntityHealth(selectedEntity,0)
						lib.showContext("pedMenu")
					end,
				}
				}
			})
			lib.showContext('debugMenu')
		end
	},
	{
		label = "Player menu", icon="fas fa-person", iconColor = "orange", distance = 10,
		canInteract = function(a, b, coords)
			if #(GetEntityCoords(PlayerPedId()) - coords) > 10 then return false end
			return true
		end,
		onSelect = function()
			lib.registerContext({
				id = 'playerMenu',
				title = 'Player Menu',
				options = {
				{
					title = 'Heal yourself',
					icon='heart',
					iconColor='#64abcc',
					onSelect = function()
						SetEntityHealth(PlayerPedId(),1000)
					end
				},
				{
					title = 'Kill yourself',
					icon='skull',
					iconColor='#cc1010',
					onSelect = function()
						SetEntityHealth(PlayerPedId(),0)
					end
				},
				{
					title = 'Godmode',
					icon='shield',
					iconColor='#ff9600',
					onSelect = function()
						godmode = not godmode
						local player = PlayerPedId()
						SetEntityInvincible(player, godmode)
						showNotification("Success","Godmode: "..tostring(godmode))
					end
				},
				{
					title = 'Teleport',
					icon='map',
					iconColor='#64abcc',
					onSelect = function()
						local input = lib.inputDialog('Spawn Ped', {
						{type = 'input', label = 'Location:',placeholder="1.0, 1.0, 1.0", required = false, min = 1, max = 256},
						})
						if not input then return end
						local x, y, z = input[1]:match("([^,]+),([^,]+),([^,]+)")
						local vec3 = vector3(tonumber(x), tonumber(y), tonumber(z))
						SetEntityCoords(PlayerPedId(),vec3)
					end
				},
				{
					title = 'Fast travel',
					icon='wand-sparkles',
					iconColor='#64abcc',
					menu = "fastTravel",
				}
				}
			})

			lib.registerContext({
				id = 'fastTravel',
				title = 'Fast Travel',
				menu = "playerMenu",
				options = {
				{icon="location-dot", iconColor="#64abcc", title = 'Casino',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(882.1226, 18.7571, 78.8753)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Maze Bank',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(227.8781, 212.7728, 105.5244)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Jewelry Store',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-634.4023, -239.6211, 38.0410)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Fleeca Bank',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-1216.0426, -323.6255, 37.6797)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Maze Tower',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-74.7000, -818.7197, 326.1752)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Airport',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-988.6636, -2842.8296, 13.9629)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Beach',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-1896.4518, -773.9951, 3.4136)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Yacht',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-2043.6910, -1031.8745, 11.9807)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'LSPD',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(413.1143, -981.8766, 29.4274)) end},
				{icon="location-dot", iconColor="#64abcc", title = 'Sub Urban',onSelect = function() SetEntityCoords(PlayerPedId(),vec3(-1203.6921, -779.5760, 17.3316)) end},
				}
			})
			
			lib.showContext('playerMenu')
		end
	},
	{     
		label = "Raycast menu", icon="fas fa-arrows-to-dot", iconColor = "orange", distance = 10,
		canInteract = function(a, b, coords)
			if #(GetEntityCoords(PlayerPedId()) - coords) > 10 then return false end
			local entC = GetEntityCoords(a)
			if a and GetEntityType(a) > 0 then
			else
				marker = nil
				selectedEntityForMarker = nil
			end
			raycastMarker = lib.marker.new({ type = 28, coords = vec3(coords.x,coords.y,coords.z), color = { r = 255, g = 150, b = 0, a = 255 }, width = 0.2, height = 0.2 })
			return true
		end,

		onSelect = function(data)
			local raycastCoords = data.coords
			lib.registerContext({
				id = 'raycastMenu',
				title = "Raycast Menu",
				onExit = function()
				selectedEntity = nil
				end,
				options = {
				{ 
					title = 'Copy Position',
					iconColor = "gray",
					icon="down-left-and-up-right-to-center",
					
					onSelect=function()
						local c = raycastCoords
						lib.setClipboard(string.format([[%f,%f,%f]],c.x,c.y,c.z))
						showNotification("Copied","Raycast position copied.") end
				},
				{ 
					title = 'Spawn ped',
					icon="person",
					iconColor = "orange",
					
					onSelect=function() 

						local input = lib.inputDialog('Spawn Ped', {
							{type = 'input', label = 'Ped hash:',    placeholder="a_m_y_beachvesp_02", required = false, min = 1, max = 24},
						})
						if not input then return end
						local hash = input[1]
						if not hash or hash == "" or hash == " " then hash = "a_m_y_beachvesp_02" end
						local time = GetGameTimer()
						RequestModel(hash)
						while not HasModelLoaded(hash) do
							if GetGameTimer() - time > 1000 then
								return showNotification("Error","PED not found")
							end
							print("louda...")
							Wait(0)
						end
						local v = CreatePed(0,GetHashKey(hash),raycastCoords.x,raycastCoords.y,raycastCoords.z,GetEntityHeading(PlayerPedId())+180,true,true)
						showNotification("Success","Ped Created.")

					end
				},
				{ 
					title = 'Spawn vehicle',
					icon="car",
					iconColor = "orange",
					
					onSelect=function() 
						local input = lib.inputDialog('Spawn Vehicle', {
							{type = 'input', label = 'Vehicle hash:', placeholder="t20",    required = false, min = 1, max = 16},
						})
						if not input then return end
						local hash = input[1]
						if not hash or hash == "" or hash == " " then hash = "t20" end
						RequestModel(hash)

						local time = GetGameTimer()
						while not HasModelLoaded(hash) do
							if GetGameTimer() - time > 1000 then
								return showNotification("Error","CAR not found")
							end
							Wait(0)
						end
						local v = CreateVehicle(GetHashKey(hash),raycastCoords.x,raycastCoords.y,raycastCoords.z,GetEntityHeading(PlayerPedId())+90,true,true)
						showNotification("Success","Vehicle created.")
					end
				},
				{ 
					title = 'Create object',
					icon="box",
					iconColor = "orange",
					
					onSelect=function() 
						local input = lib.inputDialog('Create object', {
							{type = 'input', label = 'Object hash:',    placeholder="prop_sign_sec_04", required = false, min = 1, max = 16},
						})
						if not input then return end
						local hash = input[1]
						if not hash or hash == "" or hash == " " then hash = "prop_sign_sec_04" end
						RequestModel(hash)

						local time = GetGameTimer()
						while not HasModelLoaded(hash) do
							if GetGameTimer() - time > 1000 then
								return showNotification("Error","OBJECT not found")
							end
							Wait(0)
						end
						local v = CreateObject(GetHashKey(hash),raycastCoords.x,raycastCoords.y,raycastCoords.z,false,false)
						showNotification("Success","Object created.")
					end
				},
				{ 
					title = 'Create BoxZone',
					icon="square",
					iconColor = "#1dd12c",
					
					onSelect=function() 
						SetEntityHeading(PlayerPedId(),0)
						local width = 1.0
						local height = 1.0
						local rotation = 0.0
						zoneInEdit = {shape="box",width=width,height=height,coords=vec3(raycastCoords.x,raycastCoords.y,raycastCoords.z+(width/2)), size=vec3(width,width,height),rotation=rotation}
						isInEditor = true
						zoneEditor()
					end
				},
				{ 
					title = 'Create SphereZone',
					icon="circle",
					iconColor = "#1dd12c",
					
					onSelect=function() 
						SetEntityHeading(PlayerPedId(),0)
						width = 1.0
						zoneInEdit = {shape="sphere",width=width,height=width,coords=vec3(raycastCoords.x,raycastCoords.y,raycastCoords.z+(width/2)), size=vec3(width,width,width),rotation=0.0}
						isInEditor = true
						zoneEditor()
					end
				},
				{ 
					title = 'Create Target (Box)',
					icon="expand",
					iconColor = "#1dd12c",
					
					onSelect=function() 
						local input = lib.inputDialog('Create Entity Target', {
							{type = 'input', label = 'Name:',    required = true,default="Debug target"},
							{type = 'number', label = 'Distance:',    required = true, min=1, max=10, default=3},
							{type = 'input', label = 'Icon:',    required = true, default="hand"},
							{type = 'color', label = 'Icon color:',    required = true, default="#f824ff"},
							{type = 'textarea', label = 'onSelect:',    required = true, autosize=true,max=100,default=[[print("onSelect")]]}
						})
						if not input then return end
						local msg = string.format([[
-- [TARGET] %s
exports.ox_target:addBoxZone({
	coords=vec3(%f,%f,%f),
	size=vec3(1.0,1.0,1.0),
	debug=true,
	options={{
		label="%s",
		icon="fas fa-%s",
		distance=%f,
		iconColor="%s",
		onSelect = function(data)
			%s
		end
	}}
})]], input[1], raycastCoords.x,raycastCoords.y,raycastCoords.z,input[1],input[3],input[2],input[4],input[5])

						exports.ox_target:addBoxZone({
							coords=vec3(raycastCoords.x,raycastCoords.y,raycastCoords.z),
							size=vec3(1.0,1.0,1.0),
							debug=true,
							options={{
								label=input[1],
								icon="fas fa-"..input[3],
								distance=input[2],
								iconColor=input[4],
								onSelect = function(data)
									lib.alertDialog({ header = "[DEBUG] - "..input[1], content = 'This is target debug alert.', centered = true, cancel = true })
								end
							}}
						})
						lib.setClipboard(msg)
						showNotification("Copied","OX Target (Box) copied")
					end
				},
				}
			})
			lib.showContext('raycastMenu')
		end
	}
}

function setupScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)
	--
	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(5)
	Button(GetControlInstructionalButton(2, 154, true))
	ButtonMessage("Hold (Up/Down)")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(4)
	Button(GetControlInstructionalButton(2, 61, true))
	ButtonMessage("Hold (Rotate)")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(3)
	Button(GetControlInstructionalButton(2, 217, true))
	ButtonMessage("Hold (Resize)")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(2)
	Button(GetControlInstructionalButton(2, 174, true)) -- The button to display
	Button(GetControlInstructionalButton(2, 175, true)) -- The button to display
	Button(GetControlInstructionalButton(2, 188, true)) -- The button to display
	Button(GetControlInstructionalButton(2, 187, true)) -- The button to display
	ButtonMessage("Control")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	Button(GetControlInstructionalButton(2, 191, true))
	ButtonMessage("Copy (Save)")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(0)
	Button(GetControlInstructionalButton(2, 200, true))
	ButtonMessage("Exit")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()
	--
	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

function zoneEditor()
	Citizen.CreateThread(function()
		form = setupScaleform("instructional_buttons")
		while true do
			Citizen.Wait(1)
			if not isInEditor then
				if IsDisabledControlReleased(0, 200) then
					zoneInEdit = nil
					showNotification("Copied","OX Zone copied")
					break
				else DisableControlAction(0, 200, true) end
			end
			DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
			DisableControlAction(0, 200, true)

			local speed = 0.02
			if IsDisabledControlPressed(0, 200) then
				zoneInEdit = nil
				isInEditor = nil
			end
			if IsControlJustPressed(0, 191) then
				local zCoord = zoneInEdit.coords.z - (zoneInEdit.height / 2)
				if zoneInEdit.shape == "sphere" then zCoord = zoneInEdit.coords.z-0.5 end

				local msg = string.format([[
-- [ZONE] %s
lib.zones.%s({
	coords = vec3(%f, %f, %f),
	size = vec3(%f, %f, %f),
	radius = %f,
	rotation = %f,
	debug = true,
	onEnter = function()
		print("Enter %s zone")
	end,
	onExit = function()
		print("Exit %s zone")
	end
})]], zoneInEdit.shape, zoneInEdit.shape, zoneInEdit.coords.x, zoneInEdit.coords.y, zCoord, zoneInEdit.width, zoneInEdit.width, zoneInEdit.height, zoneInEdit.height, zoneInEdit.rotation, zoneInEdit.shape, zoneInEdit.shape)
				lib.setClipboard(msg)
				isInEditor = false
			end

			if IsControlPressed(0, 175) then
				if IsControlPressed(0,61) then zoneInEdit.rotation += 1.0
				elseif IsDisabledControlPressed(0,217) then
					zoneInEdit.width += speed
					if zoneInEdit.shape == "sphere" then zoneInEdit.height += speed print("i visinu mjenja v1") end    
				else zoneInEdit.coords += vec3(speed,0.0,0.0) end
			end

			if IsControlPressed(0, 174) then
				if IsControlPressed(0,61) then zoneInEdit.rotation -= 1.0
				elseif IsDisabledControlPressed(0,217) then 
					zoneInEdit.width -= speed
					if zoneInEdit.shape == "sphere" then zoneInEdit.height -= speed print("i visinu mjenja v2") end    
				else zoneInEdit.coords -= vec3(speed,0.0,0.0) end
			end

			if IsControlPressed(0, 172) then
				if IsControlPressed(0,61) then
				elseif IsControlPressed(0,154) then zoneInEdit.coords += vec3(0.0,0.0,speed)
				elseif IsDisabledControlPressed(0,217) then
					if zoneInEdit.shape == "box" then 
						zoneInEdit.height += speed
						zoneInEdit.coords += vec3(0.0,0.0,speed)
					end
				else zoneInEdit.coords += vec3(0.0,speed,0.0) end
			end

			if IsControlPressed(0, 173) then
				if IsControlPressed(0,61) then
				elseif IsControlPressed(0,154) then zoneInEdit.coords -= vec3(0.0,0.0,speed)
				elseif IsDisabledControlPressed(0,217) then
					if zoneInEdit.shape == "box" then 
						zoneInEdit.height -= speed
						zoneInEdit.coords -= vec3(0.0,0.0,speed)
					end
				else zoneInEdit.coords -= vec3(0.0,speed,0.0) end
			end

			if IsControlPressed(0,200) then isInEditor = false end

			if zoneInEdit then
				if zoneInEdit.shape == "sphere" then
					DrawMarker(28, vec3(zoneInEdit.coords.x, zoneInEdit.coords.y, zoneInEdit.coords.z -0.5), 0.0, 0.0, 0.0, 0.0, 0.0, zoneInEdit.rotation, zoneInEdit.height,zoneInEdit.height,zoneInEdit.height,209, 25, 25, 200, false, false, 2, 0.0, nil, nil, false)
				end
				if zoneInEdit.shape == "box" then
					DrawMarker(43, vec3(zoneInEdit.coords.x, zoneInEdit.coords.y, zoneInEdit.coords.z - (zoneInEdit.height-0.5)), 0.0, 0.0, 0.0, 0.0, 0.0, zoneInEdit.rotation, zoneInEdit.width,zoneInEdit.width,zoneInEdit.height,209, 25, 25, 200, false, false, 2, 0.0, nil, nil, false)
				end
			end
		end
	end)
end

function showNotification(title,msg)
	if title == "Success" then lib.notify({title = title,description=msg, type = 'success',icon="bell"}) end
	if title == "Error" then lib.notify({title = title,description=msg, type = 'error',icon="ban"}) end
	if title == "Copied" then lib.notify({title = title,description=msg, type = 'success',icon="copy"}) end
	print(title.." - "..msg)
end

function checkAnimation(animDict, animName)
	local time = GetGameTimer()
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		if GetGameTimer() - time > 1000 then
			return false
		end
		Wait(0)
	end
	local a = HasAnimDictLoaded(animDict)
	return a
end

function ButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function Button(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

Citizen.CreateThread(function()
	local wait = 100
	while true do
		wait = 100
		if raycastMarker then
			raycastMarker:draw()
			if not IsControlPressed(0,19) then
				raycastMarker = nil
			end
			wait = 1
		end
		if marker then 
			marker:draw()
			wait = 1
			if not IsControlPressed(0,19) then
				marker = nil
			end
		end
		Citizen.Wait(wait)
	end
end)

exports.ox_target:addGlobalOption(options)