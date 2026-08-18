Config.DisableHealthRegeneration = true -- Désactive la régénération automatique de la vie
Config.DisableVehicleRewards = true -- Empêche de récupérer des armes/récompenses depuis certains véhicules
Config.DisableNPCDrops = true -- Empêche les PNJ de faire tomber leurs armes à leur mort
Config.DisableDispatchServices = true -- Désactive les services d'urgence GTA automatiques
Config.DisableScenarios = true -- Désactive certains scénarios PNJ GTA
Config.DisableAimAssist = true -- Désactive l'aide à la visée, notamment à la manette
Config.DisableVehicleSeatShuff = true -- Empêche le changement automatique de siège dans les véhicules
Config.DisableDisplayAmmo = true -- Masque l'affichage GTA des munitions
Config.EnablePVP = true -- Autorise les combats entre joueurs
Config.EnableWantedLevel = false -- Désactive les étoiles de recherche GTA

Config.RemoveHudComponents = {
    [1] = false, --WANTED_STARS,
    [2] = false, --WEAPON_ICON
    [3] = false, --CASH
    [4] = false, --MP_CASH
    [5] = false, --MP_MESSAGE
    [6] = true, --VEHICLE_NAME
    [7] = true, -- AREA_NAME
    [8] = true, -- VEHICLE_CLASS
    [9] = true, --STREET_NAME
    [10] = false, --HELP_TEXT
    [11] = false, --FLOATING_HELP_TEXT_1
    [12] = false, --FLOATING_HELP_TEXT_2
    [13] = false, --CASH_CHANGE
    [14] = false, --RETICLE
    [15] = false, --SUBTITLE_TEXT
    [16] = false, --RADIO_STATIONS
    [17] = false, --SAVING_GAME,
    [18] = false, --GAME_STREAM
    [19] = false, --WEAPON_WHEEL
    [20] = false, --WEAPON_WHEEL_STATS
    [21] = false, --HUD_COMPONENTS
    [22] = false, --HUD_WEAPONS
}

Config.Multipliers = {
    pedDensity = 0.7,
    scenarioPedDensityInterior = 0.6,
    scenarioPedDensityExterior = 0.6,
    ambientVehicleRange = 0.7,
    parkedVehicleDensity = 0.7,
    randomVehicleDensity = 0.6,
    vehicleDensity = 0.7
}

-- Pattern string format
--1 will lead to a random number from 0-9.
--A will lead to a random letter from A-Z.
-- . will lead to a random letter or number, with a 50% probability of being either.
--^1 will lead to a literal 1 being emitted.
--^A will lead to a literal A being emitted.
--Any other character will lead to said character being emitted.
-- A string shorter than 8 characters will be padded on the right.
Config.CustomAIPlates = "........" -- Custom plates for AI vehicles

--[[
    PlaceHolders:
    {server_name} - Server Display Name
    {server_endpoint} - Server IP:Server Port
    {server_players} - Current Player Count
    {server_maxplayers} - Max Player Count

    {player_name} - Player Name
    {player_rp_name} - Player RP Name
    {player_id} - Player ID
    {player_street} - Player Street Name
]]

Config.DiscordActivity = {
    appId = 1539007847294312538, -- Discord Application ID,
    assetName = "logo", --image name for the "large" icon.
    assetText = "T STUDIO", -- Text to display on the asset
    buttons = {
        { label = "Discord - T STUDIO", url = " https://discord.gg/9dSsCsQKwv" },
    },
    presence = "{player_name} [{player_id}] | {server_players}/{server_maxplayers}",
    refresh = 1 * 60 * 1000, -- 1 minute
}