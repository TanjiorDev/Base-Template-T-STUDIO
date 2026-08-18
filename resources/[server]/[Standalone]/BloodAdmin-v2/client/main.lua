-- ============================================================
--  BLOODADMIN — CLIENT/MAIN.LUA
-- ============================================================
print('^2[bl_admin] Loading Client Core...^0')

-- Ce fichier sert de point d'entrée. La logique est répartie dans client/modules/

-- ── Commande et Touche ───────────────────────────────────────
RegisterCommand(Config.OpenCommand, function()
    TriggerServerEvent('bl_admin:requestOpenData')
end, false)

RegisterKeyMapping(Config.OpenCommand, 'Ouvrir le menu BloodAdmin', 'keyboard', Config.DefaultKey or 'F10')



-- Notification de chargement
print('^1[bl_admin] ^0Client Core Initialized and Modules Loaded')

-- Demander le grade au démarrage (pour les restarts de ressource)
Citizen.CreateThread(function()
    Wait(1000)
    TriggerServerEvent('bl_admin:requestGrade')
end)
