# tan_location_vehicules

Interface UI de location de véhicules pour FiveM ESX Legacy.

## Installation
1. Dépose le dossier `tan_location_vehicules` dans tes resources.
2. Ajoute dans ton `server.cfg` :
   ensure tan_location_vehicules
3. Vérifie que `ox_lib` et `es_extended` démarrent avant cette ressource.

## Utilisation
- Va au point configuré dans `config.lua`
- Appuie sur E
- Ou utilise la commande test : /location

## Modification
- Les véhicules, prix, images et positions sont dans `config.lua`.


## Système de durée
La location propose maintenant 3 durées :
- 30 minutes
- 1 heure
- 2 heures

Le prix est calculé avec `Config.RentalDurations` dans `config.lua`.
Quand le compteur arrive à zéro, le véhicule loué est supprimé automatiquement.
