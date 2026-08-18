Config = {}

Config.Locale = 'fr'

-- Commande test pour ouvrir le menu
Config.TestCommand = 'location'

-- Framework : choisissez 'esx' ou 'qbcore'
Config.Framework = 'esx'

-- Paiement : 'bank' ou 'money'
Config.PayAccount = 'money'

-- Point de location

-- Durées disponibles pour la location
-- Le prix du véhicule est calculé avec le multiplicateur.
-- Exemple : prix 250$ avec multiplier 2 = 500$.
Config.RentalDurations = {
    { label = '30 minutes', minutes = 30, multiplier = 1 },
    { label = '1 heure', minutes = 60, multiplier = 2 },
    { label = '2 heures', minutes = 120, multiplier = 4 }
}
-- Point de location
Config.RentalPoint = vec3(-211.114487,-1001.537964,29.662613)

-- Spawn véhicule
Config.SpawnVehicle = vec4(-212.92, -999.82, 28.88, 337.92)

-- Blip
Config.Blip = {
    enabled = true,
    sprite = 225,
    color = 3,
    scale = 0.75,
    label = 'Location de véhicules'
}

Config.Vehicles = {
    {
        label = 'Blista',
        model = 'blista',
        price = 250,
        seats = 2,
        category = 'Économique',
        image = 'https://docs.fivem.net/vehicles/blista.webp'
    },
    {
        label = 'Asterope SUV',
        model = 'asterope',
        price = 500,
        seats = 4,
        category = 'Confort',
        image = 'https://docs.fivem.net/vehicles/asterope.webp'
    },
    {
        label = 'Karin Sultan',
        model = 'sultan',
        price = 750,
        seats = 4,
        category = 'Sportive',
        image = 'https://docs.fivem.net/vehicles/sultan.webp'
    },
    {
        label = 'Bati 801',
        model = 'bati',
        price = 150,
        seats = 2,
        category = 'Moto',
        image = 'https://docs.fivem.net/vehicles/bati.webp'
    }
}


--############################
--########### ped #########
--############################
Config.NPCs = {
    {
        model = "a_m_m_afriamer_01",
        coords = vec4(-211.34, -1001.43, 29.30, 246.78),
        freeze = true,
        invincible = true,
        text = "👋 Ouvrir l\' loc"
    },

}
