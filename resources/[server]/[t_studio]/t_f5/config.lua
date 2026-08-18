Config = {}

Config.Command = 'f5menu'
Config.Key = 'F5'
Config.Title = 'T STUDIO'
Config.Subtitle = 'T STUDIO'



Config.MaxGiveDistance = 3.0
Config.MaxGiveAmount = 100000

Config.GPS = {
    { label = 'Commissariat', coords = vector2(425.1, -979.5) },
    { label = 'Hôpital', coords = vector2(298.8, -584.6) },
    { label = 'Concessionnaire', coords = vector2(-44.4, -1097.2) },
    { label = 'Aéroport', coords = vector2(-1037.7, -2737.8) }
}

Config.Animations = {
    { label = 'Saluer', dict = 'gestures@m@standing@casual', anim = 'gesture_hello', flag = 48 },
    { label = 'Applaudir', dict = 'amb@world_human_cheering@male_a', anim = 'base', flag = 49 },
    { label = 'Croiser les bras', dict = 'amb@world_human_hang_out_street@male_c@base', anim = 'base', flag = 49 },
    { label = 'Mains en l\'air', dict = 'random@mugging3', anim = 'handsup_standing_base', flag = 49 }
}


-- Configuration du système de vêtements importé depuis ox_menuf5
Config.Label_RemoveClothes = 'Retrait de vos vêtements...'
Config.Label_PutBackClothes = 'Remise de vos vêtements...'

Config.Male = {
    Torso = 15, Pants = 14, Shoes = 34, Bag = 0, Gloves = 15,
    Hat = -1, Glasses = -1, Mask = 0, Shirt = 15, Ears = -1,
    Vest = 0, Chain = 0
}

Config.Female = {
    Torso = 15, Pants = 14, Shoes = 5, Bag = 0, Gloves = 15,
    Hat = -1, Glasses = -1, Mask = 0, Shirt = 15, Ears = -1,
    Vest = 0, Chain = 0
}
