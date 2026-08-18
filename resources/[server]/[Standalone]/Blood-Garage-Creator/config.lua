Config = {}

-- Langue du script
Config.Locale = 'fr'

-- Liste des identifiants (license:xxx, steam:xxx, discord:xxx, ip:xxx, live:xxx, xbl:xxx) ayant un accès admin garanti
Config.AdminIdentifiers = {
    -- Ajoutez vos identifiants ici (Exemple: "license:1abc2def...")
    -- "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
}

-- Groupes d'administration autorisés à accéder au menu de configuration
Config.AdminGroups = {
    ['superadmin'] = true,
    ['admin'] = true,
    ['mod'] = true,
    ['_dev'] = true,
    ['owner'] = true,
}

-- Prix de la récupération à la fourrière
Config.ImpoundFee = 10000

-- Prix du transfert depuis un autre garage (Valet de livraison)
Config.TransferFee = 500

-- Rayon pour vérifier si la zone de spawn est encombrée
Config.SpawnRadius = 6.0

-- Options d'affichage 3D / Markers dans le jeu
Config.Marker = {
    Type = 36, -- Symbole rotatif de clé/voiture
    Color = { r = 59, g = 130, b = 246, a = 150 }, -- Bleu moderne Indigo
    Size = { x = 0.8, y = 0.8, z = 0.8 },
    BobUpAndDown = true,
    FaceCamera = true,
    DrawDistance = 15.0
}

-- Configuration des différents garages et fourrière (100% Civils)
Config.Garages = {
    ["Airport"] = {
        label = "Garage Aéroport LS",
        type = "air",
        coords = vector3(-1631.36, -3158.12, 13.98),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 75.00,
        spawn = {
            vector4(-1592.64, -3080.28, 14.20, 280.46),
            vector4(-1562.32, -3102.40, 13.94, 298.36),
            vector4(-1541.80, -3122.64, 13.94, 224.28),
        },
        delete = vector3(-1665.32, -3144.02, 14.36),
        deleteSize = 18.0,
        blip = { active = true, sprite = 307, color = 8, scale = 0.8, label = "Garage Aéroport LS" },
        job = nil
    },
    ["AlamoSea"] = {
        label = "Garage Alamo Sea Boat",
        type = "boat",
        coords = vector3(1324.60, 4226.60, 33.90),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 349.80,
        spawn = {
            vector4(1312.42, 4220.68, 32.34, 183.22),
            vector4(1336.20, 4212.02, 32.66, 166.42),
            vector4(1318.94, 4244.02, 33.22, 345.86),
        },
        delete = vector3(1352.36, 4222.02, 32.02),
        deleteSize = 18.0,
        blip = { active = true, sprite = 427, color = 4, scale = 0.8, label = "Garage Alamo Sea Boat" },
        job = nil
    },
    ["Fourriere"] = {
        label = "Fourrière Municipale",
        type = "impound",
        coords = vector3(408.60, -1625.46, 28.26),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 230.00,
        spawn = vector4(405.64, -1643.40, 27.62, 229.54),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Municipale" },
        job = nil
    },
    ["FourriereMarina"] = {
        label = "Fourrière Marina Bateaux",
        type = "impound_boat",
        coords = vector3(-798.50, -1355.20, 5.16),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 110.00,
        spawn = vector4(-804.50, -1340.20, 1.20, 110.00),
        delete = nil,
        blip = { active = true, sprite = 427, color = 5, scale = 0.8, label = "Fourrière Marina Bateaux" },
        job = nil
    },
    ["FourrierePaleto"] = {
        label = "Fourrière Paleto Bay",
        type = "impound",
        coords = vector3(-234.82, 6198.64, 30.90),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 140.00,
        spawn = vector4(-230.08, 6190.24, 30.48, 140.24),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Paleto Bay" },
        job = nil
    },
    ["FourriereSandy"] = {
        label = "Fourrière Sandy Shores",
        type = "impound",
        coords = vector3(1651.38, 3804.84, 37.62),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 308.00,
        spawn = vector4(1627.84, 3788.44, 33.78, 308.52),
        delete = nil,
        blip = { active = true, sprite = 68, color = 5, scale = 0.8, label = "Fourrière Sandy Shores" },
        job = nil
    },
    ["Legion"] = {
        label = "Garage Central",
        type = "car",
        coords = vector3(213.58, -805.66, 30.84),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 336.86,
        spawn = vector4(224.28, -799.34, 30.60, 250.00),
        delete = vector3(223.82, -764.86, 30.96),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage Central" },
        job = nil
    },
    ["Marina"] = {
        label = "Garage Marina Puerto",
        type = "boat",
        coords = vector3(-812.40, -1345.60, 5.10),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 110.00,
        spawn = vector4(-804.50, -1340.20, 1.20, 110.00),
        delete = vector3(-818.20, -1350.50, 1.20),
        deleteSize = 7.0,
        blip = { active = true, sprite = 427, color = 3, scale = 0.8, label = "Garage Marina Puerto" },
        job = nil
    },
    ["Paleto"] = {
        label = "Garage Paleto Bay",
        type = "car",
        coords = vector3(-119.50, 6401.36, 31.40),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 45.00,
        spawn = vector4(-125.10, 6408.20, 31.60, 45.00),
        delete = vector3(-115.80, 6397.50, 31.40),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage Paleto Bay" },
        job = nil
    },
    ["Pillbox"] = {
        label = "Garage Pillbox Hill",
        type = "car",
        coords = vector3(-342.30, -901.20, 31.00),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 180.00,
        spawn = vector4(-332.50, -895.40, 31.00, 180.00),
        delete = vector3(-348.60, -906.50, 30.50),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage Pillbox Hill" },
        job = nil
    },
    ["Richman"] = {
        label = "Garage Richman Glen",
        type = "car",
        coords = vector3(-1673.44, 63.38, 63.66),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 316.68,
        spawn = {
            vector4(-1666.56, 77.74, 63.56, 197.56),
            vector4(-1677.90, 70.70, 63.98, 271.20),
            vector4(-1683.46, 75.38, 64.32, 302.78),
        },
        delete = vector3(-1681.92, 63.75, 64.08),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage Richman Glen" },
        job = nil
    },
    ["Sandy"] = {
        label = "Garage Sandy Shores",
        type = "car",
        coords = vector3(1877.90, 3757.25, 32.80),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 300.00,
        spawn = vector4(1869.40, 3762.60, 33.10, 300.00),
        delete = vector3(1883.60, 3753.10, 32.80),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Garage Sandy Shores" },
        job = nil
    },
    ["SandyAirfield"] = {
        label = "Garage Aérodrome Sandy",
        type = "air",
        coords = vector3(1744.10, 3274.60, 41.10),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 180.00,
        spawn = vector4(1734.20, 3278.40, 41.10, 180.00),
        delete = vector3(1752.50, 3270.20, 41.10),
        deleteSize = 7.0,
        blip = { active = true, sprite = 307, color = 3, scale = 0.8, label = "Garage Aérodrome Sandy" },
        job = nil
    },
    ["impound_custom_1779565724648"] = {
        label = "Zancudo Rivers",
        type = "car",
        coords = vector3(-2032.72, -467.20, 11.36),
        pedModel = "s_m_m_dockwork_01",
        pedHeading = 141.50,
        spawn = {
            vector4(-2041.98, -471.46, 11.60, 341.50),
            vector4(-2036.96, -461.56, 11.40, 125.20),
            vector4(-2039.82, -458.80, 11.40, 145.26),
        },
        delete = vector3(-2049.90, -456.98, 11.36),
        deleteSize = 7.0,
        blip = { active = true, sprite = 357, color = 3, scale = 0.8, label = "Zancudo Rivers" },
        job = nil
    },
    ["impound_custom_1779708142426"] = {
        label = "Fourière Aeronefs LS",
        type = "impound_air",
        coords = vector3(-958.36, -2978.92, 13.94),
        pedModel = "s_m_m_dockwork_01",
        pedHeading = 144.44,
        spawn = vector4(-978.96, -2995.94, 13.94, 60.80),
        delete = vector3(0.00, 0.00, 0.00),
        deleteSize = 7.0,
        blip = { active = true, sprite = 68, color = 8, scale = 0.8, label = "Fourière Aeronefs LS" },
        job = nil
    },
    ["impound_custom_1779719902614"] = {
        label = "Heliport LS",
        type = "helicopter",
        coords = vector3(-1124.94, -2875.50, 13.94),
        pedModel = "s_m_y_valet_01",
        pedHeading = 236.62,
        spawn = {
            vector4(-1111.42, -2882.80, 13.94, 146.28),
            vector4(-1146.18, -2864.28, 13.94, 156.64),
        },
        delete = vector3(-1137.96, -2891.30, 13.94),
        deleteSize = 12.0,
        blip = { active = true, sprite = 43, color = 8, scale = 0.8, label = "Heliport LS" },
        job = nil
    },
    ["impound_custom_1779720167813"] = {
        label = "Fourière Helicopeter LS",
        type = "impound_helicopter",
        coords = vector3(-1298.16, -2319.36, 14.10),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 62.82,
        spawn = vector4(-1311.06, -2291.40, 13.94, 102.96),
        delete = vector3(0.00, 0.00, 0.00),
        deleteSize = 7.0,
        blip = { active = true, sprite = 68, color = 8, scale = 0.8, label = "Fourière Helicopeter LS" },
        job = nil
    },
    ["impound_custom_1779721384885"] = {
        label = "Fourière Almo Sea",
        type = "impound_boat",
        coords = vector3(1319.20, 4227.80, 33.90),
        pedModel = "s_m_y_xmech_01",
        pedHeading = 337.64,
        spawn = vector4(1309.04, 4216.08, 31.70, 97.38),
        delete = vector3(0.00, 0.00, 0.00),
        deleteSize = 7.0,
        blip = { active = true, sprite = 68, color = 4, scale = 0.8, label = "Fourière Almo Sea" },
        job = nil
    },
}



-- Dictionnaire de labels personnalisés pour l'interface UI
Config.VehicleLabels = {
    -- Supercars & Sportives
    ["adder"] = "Truffade Adder",
    ["t20"] = "Progen T20",
    ["zentorno"] = "Pegassi Zentorno",
    ["turismor"] = "Grotti Turismo R",
    ["cheetah"] = "Grotti Cheetah",
    ["vacca"] = "Pegassi Vacca",
    ["bullet"] = "Vapid Bullet",
    ["infernus"] = "Pegassi Infernus",
    ["sultan"] = "Karin Sultan",
    ["banshee"] = "Bravado Banshee",
    ["elegy"] = "Annis Elegy RH8",
    ["jester"] = "Dinka Jester",
    ["massacro"] = "Dewbauchee Massacro",
    ["comet2"] = "Pfister Comet",
    ["carbonizzare"] = "Grotti Carbonizzare",
    ["ninef"] = "Obey 9F",
    ["sentinel"] = "Ubermacht Sentinel",
    
    -- Berlines & Classiques
    ["panto"] = "Benefactor Panto",
    ["kuruma"] = "Karin Kuruma",
    ["exemplar"] = "Dewbauchee Exemplar",
    ["felon"] = "Lampadati Felon",
    ["jackal"] = "Ocelot Jackal",
    ["oracle"] = "Ubermacht Oracle",
    ["tailgater"] = "Obey Tailgater",
    ["schafter2"] = "Benefactor Schafter",
    ["buffalo"] = "Bravado Buffalo",
    ["fugitive"] = "Cheval Fugitive",
    ["premier"] = "Declasse Premier",
    ["stanier"] = "Vapid Stanier",
    ["washington"] = "Albany Washington",
    
    -- SUVs & Tout-terrain
    ["baller"] = "Gallivanter Baller",
    ["cavalcade"] = "Albany Cavalcade",
    ["rocoto"] = "Obey Rocoto",
    ["granger"] = "Declasse Granger",
    ["dubsta"] = "Benefactor Dubsta",
    ["patriot"] = "Mammoth Patriot",
    ["landstalker"] = "Dundreary Landstalker",
    ["mesa"] = "Canis Mesa",
    ["sandking"] = "Vapid Sandking",
    ["bison"] = "Bravado Bison",
    ["rebel"] = "Karin Rebel",
    
    -- Motos
    ["bati"] = "Pegassi Bati 801",
    ["akuma"] = "Dinka Akuma",
    ["double"] = "Dinka Double T",
    ["hakuchou"] = "Shitzu Hakuchou",
    ["ruffian"] = "Pegassi Ruffian",
    ["sanchez"] = "Maibatsu Sanchez",
    ["faggio2"] = "Pegassi Faggio",
    
    -- Services & Police
    ["police"] = "Vapid Interceptor LSPD",
    ["police2"] = "Vapid Cruiser LSPD",
    ["police3"] = "Vapid Interceptor Slick",
    ["police4"] = "Vapid Cruiser Banalisé",
    ["sheriff"] = "Declasse Sheriff Granger",
    ["sheriff2"] = "Vapid Sheriff Cruiser",
}

-- Traduction
Config.Translations = {
    ['fr'] = {
        ['open_garage'] = "Appuyez sur ~INPUT_CONTEXT~ pour parler au ~b~Garagiste~s~.",
        ['open_impound'] = "Appuyez sur ~INPUT_CONTEXT~ pour parler à l'~b~Agent de Fourrière~s~.",
        ['store_vehicle'] = "Appuyez sur ~INPUT_CONTEXT~ pour ranger votre ~b~véhicule~s~.",
        ['not_owner'] = "Ce véhicule ne vous appartient pas.",
        ['no_vehicle'] = "Aucun véhicule à proximité.",
        ['spawn_blocked'] = "La zone de sortie est encombrée par un autre véhicule.",
        ['vehicle_spawned'] = "Votre véhicule a été sorti !",
        ['vehicle_stored'] = "Votre véhicule a été rangé avec succès.",
        ['invalid_vehicle_type'] = "Vous ne pouvez pas ranger ce type de véhicule dans ce garage.",
        ['not_enough_money'] = "Vous n'avez pas assez d'argent (%s$ requis).",
        ['impound_retrieved'] = "Vous avez payé %s$ pour récupérer votre véhicule.",
        ['no_owned_vehicles'] = "Vous ne possédez aucun véhicule dans ce garage.",
        ['garage_restricted'] = "Ce garage est réservé aux membres de la faction : %s.",
        ['stored_status'] = "Rangé",
        ['out_status'] = "Sorti",
        ['impounded_status'] = "Fourrière",
    }
}

-- Helper fonction de traduction
function _T(str, ...)
    local lang = Config.Locale or 'fr'
    local translation = Config.Translations[lang] and Config.Translations[lang][str] or str
    return string.format(translation, ...)
end

-- Configuration du nettoyage automatique des véhicules (Auto-Impound)
Config.AutoImpound = {
    Enabled = true,          -- Activer (true) ou désactiver (false) le nettoyage automatique
    CheckInterval = 120000,  -- Fréquence de vérification des véhicules abandonnés (en millisecondes. Exemple: 120000 = 2 minutes)
    AbandonTime = 600        -- Temps d'inactivité avant d'envoyer le véhicule à la fourrière (en secondes. Exemple: 600 = 10 minutes)
}

-- Activer le débogage pour afficher les logs de diagnostic détaillés (Désactivé par défaut)
Config.Debug = false

-- Helper global de débogage pour désencombrer les consoles F8 et serveur
function debugPrint(msg)
    if Config.Debug then
        print(msg)
    end
end

