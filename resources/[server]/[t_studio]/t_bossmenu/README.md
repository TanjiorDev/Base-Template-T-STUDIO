# ato_bossmenu - RageUI V2

Conversion du boss menu ESX Legacy vers RageUI V2.

## Fonctions
- Menu principal patron en RageUI V2
- Recrutement du joueur le plus proche avec confirmation
- Annonces employés / publiques
- Gestion des grades et salaires
- Gestion des employés : promouvoir, rétrograder, virer
- Dépôt / retrait des fonds société
- Blanchiment si activé pour la société
- Ouverture via ox_target ou touche selon `Shared.menuSystem`
- Vérifications patron côté serveur pour les événements sensibles

## Configuration RageUI
Fichier : `shared/rageui_config.lua`

Tu peux y modifier :
- `Title` / `Subtitle`
- `Position.X` / `Position.Y`
- la couleur de bannière RGBA
- la touche d'ouverture en mode `touch`
- la distance de recrutement
- plusieurs textes du menu

## Sociétés
Fichier : `shared/shared.lua`

Exemple :
```lua
{name = 'police', label = 'LSPD', coords = vec3(461.35, -985.56, 31.19), bossGrade = 4, washMoney = false}
```

## Dépendances
- es_extended
- oxmysql
- ox_lib (locales + notifications)
- ox_target (mode target)
- esx_addonaccount

## Ordre conseillé
```cfg
ensure oxmysql
ensure ox_lib
ensure es_extended
ensure esx_addonaccount
ensure ox_target
ensure ato_bossmenu
```

## Webhooks
Les webhooks présents dans la ressource d'origine ont été retirés du code fourni. Ajoute tes nouveaux webhooks dans `Shared.logs` si tu veux activer les logs Discord.
