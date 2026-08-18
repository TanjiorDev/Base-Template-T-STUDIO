-- ============================================================
--  BLOODADMIN — CONFIG.LUA
--  Partagé entre client et serveur
-- ============================================================

Config = {}

-- Touche d'ouverture du menu
Config.OpenCommand = 'admin'
Config.DefaultKey = 'F10' -- Touche par défaut (F10, F9, INSERT, etc.). Les joueurs peuvent également la personnaliser individuellement dans leurs Paramètres GTA V -> Attribution des touches -> FiveM.

-- URL du webhook Discord pour les logs (laisser '' pour désactiver)
Config.WebhookURL = ''

-- Nom du serveur affiché dans le menu
Config.ServerName = 'T STUDIO'

-- ── Système de permissions par grade ────────────────────────
Config.Permissions = {
    ['boss'] = {
        level = 100, _color = '#dc2626', _icon = '👑',
        ["bl.ban"] = true, ["bl.kick"] = true, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = true,
        ["bl.resources"] = true, ["bl.logs"] = true,
        ["bl.noclip"] = true, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = true,
        ["bl.delveh"] = true, ["bl.spawnveh"] = true, ["bl.giveveh"] = true, ["bl.tpzones"] = true, ["bl.jail"] = true, ["bl.ghost"] = true, ["bl.customcatalog"] = true,
        ["bl.world"] = true, ["bl.offlinemod"] = true, ["bl.viewip"] = true
    },
    ['superviseur'] = {
        level = 90, _color = '#f59e0b', _icon = '⭐',
        ["bl.ban"] = true, ["bl.kick"] = true, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = true,
        ["bl.resources"] = true, ["bl.logs"] = true,
        ["bl.noclip"] = true, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = true,
        ["bl.delveh"] = true, ["bl.spawnveh"] = true, ["bl.giveveh"] = true, ["bl.tpzones"] = true, ["bl.jail"] = true, ["bl.ghost"] = true, ["bl.customcatalog"] = true,
        ["bl.world"] = true, ["bl.offlinemod"] = true, ["bl.viewip"] = true
    },
    ['superadmin'] = {
        level = 80, _color = '#8b5cf6', _icon = '🛡️',
        ["bl.ban"] = true, ["bl.kick"] = true, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = true,
        ["bl.resources"] = true, ["bl.logs"] = true,
        ["bl.noclip"] = true, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = true,
        ["bl.delveh"] = true, ["bl.spawnveh"] = true, ["bl.giveveh"] = true, ["bl.tpzones"] = true, ["bl.jail"] = true, ["bl.ghost"] = true, ["bl.customcatalog"] = true,
        ["bl.world"] = true, ["bl.offlinemod"] = true, ["bl.viewip"] = true
    },
    ['admin'] = {
        level = 70, _color = '#3b82f6', _icon = '🔵',
        ["bl.ban"] = true, ["bl.kick"] = true, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = true,
        ["bl.resources"] = true, ["bl.logs"] = true,
        ["bl.noclip"] = true, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = true,
        ["bl.delveh"] = true, ["bl.spawnveh"] = true, ["bl.giveveh"] = true, ["bl.jail"] = true, ["bl.ghost"] = true, ["bl.customcatalog"] = true,
        ["bl.world"] = true, ["bl.offlinemod"] = true, ["bl.viewip"] = false
    },
    ['moderateur'] = {
        level = 50, _color = '#10b981', _icon = '🔨',
        ["bl.ban"] = false, ["bl.kick"] = true, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = true,
        ["bl.resources"] = false, ["bl.logs"] = false,
        ["bl.noclip"] = true, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = true,
        ["bl.delveh"] = true, ["bl.spawnveh"] = false, ["bl.tpzones"] = true, ["bl.jail"] = true, ["bl.ghost"] = false, ["bl.customcatalog"] = false,
        ["bl.world"] = false, ["bl.offlinemod"] = false, ["bl.viewip"] = false
    },
    ['animateur'] = {
        level = 40, _color = '#ec4899', _icon = '🎭',
        ["bl.ban"] = false, ["bl.kick"] = false, ["bl.warn"] = false, ["bl.spectate"] = false, ["bl.freeze"] = false,
        ["bl.staff"] = false, ["bl.resources"] = false, ["bl.logs"] = false, ["bl.anticheat"] = false,
        ["bl.money"] = false, ["bl.item"] = true, ["bl.job"] = false,
        ["bl.noclip"] = false, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = false,
        ["bl.delveh"] = true, ["bl.spawnveh"] = true, ["bl.jail"] = false, ["bl.ghost"] = false, ["bl.customcatalog"] = false,
        ["bl.world"] = false, ["bl.offlinemod"] = false, ["bl.viewip"] = false
    },
    ['helper'] = {
        level = 30, _color = '#64748b', _icon = '🎯',
        ["bl.ban"] = false, ["bl.kick"] = false, ["bl.warn"] = true, ["bl.spectate"] = true, ["bl.freeze"] = false,
        ["bl.staff"] = false, ["bl.resources"] = false, ["bl.logs"] = false,
        ["bl.money"] = false, ["bl.item"] = false, ["bl.job"] = false,
        ["bl.noclip"] = false, ["bl.teleport"] = true, ["bl.revive"] = true, ["bl.heal"] = true, ["bl.inventory"] = false,
        ["bl.delveh"] = false, ["bl.spawnveh"] = false, ["bl.jail"] = false, ["bl.ghost"] = false, ["bl.customcatalog"] = false,
        ["bl.world"] = false, ["bl.offlinemod"] = false, ["bl.viewip"] = false
    },
}

-- Grades reconnus comme admin
Config.AdminGrades = { 'boss', 'superviseur', 'superadmin', 'admin', 'moderateur', 'helper', 'animateur' }

-- Raisons de ban prédéfinies
Config.BanReasons = {
    'Cheat / Hack détecté',
    'Triche économique',
    'Toxicité grave',
    'Ban évasion',
    'Harcèlement',
    'Meta-gaming',
    'Non-valeur de la vie (NVL)',
    'Powergaming',
    'Staff diss',
    'Autre (préciser)',
}

-- Durées de ban prédéfinies
Config.BanDurations = {
    { label = '1 heure',   seconds = 3600      },
    { label = '6 heures',  seconds = 21600     },
    { label = '12 heures', seconds = 43200     },
    { label = '24 heures', seconds = 86400     },
    { label = '3 jours',   seconds = 259200    },
    { label = '7 jours',   seconds = 604800    },
    { label = '30 jours',  seconds = 2592000   },
    { label = 'Permanent', seconds = 0         },
}
-- Zones de téléportation prédéfinies
Config.TPZones = {
    { label = 'LSPD / Mission Row', x = 427.14, y = -980.83, z = 30.71 },
    { label = 'LSMall / Carré', x = -1004.14, y = -2695.83, z = 13.97 },
    { label = 'Hôpital Pillbox', x = 299.14, y = -584.83, z = 43.26 },
    { label = 'Légion Square', x = 168.14, y = -1016.83, z = 29.35 },
    { label = 'Sandy Shores', x = 1877.14, y = 3705.83, z = 32.76 },
    { label = 'Paleto Bay', x = -436.14, y = 5988.83, z = 31.71 },
}
