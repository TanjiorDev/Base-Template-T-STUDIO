# ESX Multicharacter - RageUI V2

Cette version remplace l'interface ox_lib / NUI de sélection des personnages par RageUI V2.

## Modifications
- Sélection des personnages en RageUI V2
- Sous-menu d'informations et de connexion
- Confirmation de suppression en RageUI V2 si `Config.CanDelete = true`
- Création d'un nouveau personnage conservée via `esx_identity`
- Prévisualisation du personnage conservée
- Caméra et logique de spawn ESX conservées
- Suppression des dépendances UI `ox_lib` et de l'ancien dossier HTML
- Validation serveur de `charid` corrigée

## Dépendances
- es_extended
- oxmysql
- spawnmanager
- esx_identity
- skinchanger
- esx_skin

Conservez l'ordre de démarrage de ces dépendances avant `esx_multicharacter`.

## Configuration RageUI V2

La personnalisation du menu se trouve dans `rageui_config.lua`.

Tu peux y modifier sans toucher au code principal :

- `Config.RageUI.Menu.Title` : titre du menu.
- `Config.RageUI.Menu.Position.X / Y` : position du menu.
- `Config.RageUI.Menu.Colors.SelectedButton` : couleur du bouton sélectionné.
- `Config.RageUI.Menu.Colors.BannerGradient` : couleur du dégradé de bannière.
- `Config.RageUI.Menu.Colors.RectangleBanner` : bannière rectangulaire optionnelle.
- `Config.RageUI.Menu.Closable` : autorise ou non la fermeture du menu.
- `Config.RageUI.Menu.MaxVisibleItems` : nombre d'éléments visibles.
- `Config.RageUI.Controls` : touches de navigation RageUI.
- `Config.RageUI.Texts` : textes, descriptions et libellés du menu.

Les touches sont des IDs de contrôles GTA/FiveM. Les valeurs par défaut correspondent aux flèches, Entrée et Retour.
