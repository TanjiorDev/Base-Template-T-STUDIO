-- Ce fichier sert à ajouter tes emotes customs proprement.
local CustomDP = {}

-- Les catégories de base
CustomDP.Expressions = {}
CustomDP.Walks = {}
CustomDP.Shared = {}
CustomDP.Dances = {}
CustomDP.AnimalEmotes = {}
CustomDP.Emotes = {}
CustomDP.PropEmotes = {}

-- TES CATÉGORIES PERSONNALISÉES (Gangs, etc.)
CustomDP.whitecustom = {}
CustomDP.whitecustom2do = {}
CustomDP.whitecustom4 = {}
CustomDP.whitecustom5 = {}

-- =========================================================
-- 👇 AJOUTE TOUTES TES NOUVELLES EMOTES EN DESSOUS DE CETTE LIGNE 👇
-- Exemple :
-- CustomDP.whitecustom["madance"] = {"dico", "anim", "Ma Danse Custom", AnimationOptions = {}}
-- =========================================================





-- =========================================================
-- LE MOTEUR DE FUSION (Ne pas toucher)
-- Il va prendre tout ce que tu as mis au-dessus et l'injecter dans la liste globale
-- =========================================================
for arrayName, array in pairs(CustomDP) do
    -- Si la catégorie n'existe pas dans le DP de base, on la crée !
    if not DP[arrayName] then 
        DP[arrayName] = {} 
    end
    
    -- On injecte tes emotes
    for emoteName, emoteData in pairs(array) do
        DP[arrayName][emoteName] = emoteData
    end
    
    -- On libère la mémoire
    CustomDP[arrayName] = nil
end
CustomDP = nil