# HC F5 RageUI — Rouge & Blanc

Menu personnel F5 basé sur le RageUI k2r fourni, préparé pour ESX Legacy.

## Fonctions

- Inventaire : ouvre la commande `inventory` de ox_inventory ;
- Portefeuille : liquide, banque, argent sale et don d'argent sécurisé ;
- Vêtements : rechargement illenium-appearance, masque, chapeau, lunettes, gilet, sac ;
- Animations : salut, applaudissement, bras croisés, mains en l'air, arrêt ;
- Véhicule : moteur conducteur, portes, capot/coffre, vitres ;
- GPS : points rapides configurables ;
- Divers : ID serveur, mini-carte, arrêt des tâches ;
- touche F5 avec `RegisterKeyMapping` ;
- exports `OpenF5Menu` et `CloseF5Menu`.

## Dépendances

Obligatoire :

- `es_extended`

Recommandées pour toutes les fonctions :

- `ox_inventory`
- `illenium-appearance`

## Installation

Place le dossier `hc_f5_rageui` dans `resources`, puis :

```cfg
ensure es_extended
ensure ox_inventory
ensure illenium-appearance
ensure hc_f5_rageui
```

Le menu s'ouvre avec **F5** ou :

```text
/f5menu
```

## Configuration

Tout ce qui doit être personnalisé est dans `config.lua` : touche, commande, GPS, animations, distance et montant maximum des transferts.

## Sécurité du portefeuille

Le client envoie seulement l'ID cible et le montant demandé. Le serveur revérifie :

- existence des deux joueurs ;
- cible différente de l'émetteur ;
- montant entier et positif ;
- plafond configuré ;
- distance réelle côté serveur ;
- solde ESX réel ;
- délai minimal entre deux demandes.

Le serveur retire et ajoute ensuite l'argent lui-même.

## Vêtements

Les boutons rapides retirent/restaurent temporairement les composants du ped et ne les sauvegardent pas en base. Le bouton **Recharger ma tenue** utilise `/reloadskin` d'illenium-appearance.

## Inventaire

Le bouton utilise par défaut :

```lua
ExecuteCommand('inventory')
```

Cette valeur est modifiable via `Config.InventoryCommand`.

## Export

Depuis une autre ressource cliente :

```lua
exports['hc_f5_rageui']:OpenF5Menu()
exports['hc_f5_rageui']:CloseF5Menu()
```

## Remarque

Le code a été contrôlé statiquement et l'archive est vérifiée, mais un véritable test en client FiveM reste nécessaire pour valider les interactions avec les versions exactes de tes ressources.

## Correctif Separator

Le composant `RageUI.Separator` a été corrigé pour cette version du menu :

- prise en compte de `CurrentMenu.SubtitleHeight` ;
- centrage horizontal calculé sur la largeur réelle du menu ;
- hauteur harmonisée avec les boutons (45 px) ;
- utilisation de `fontIdSeparator` avec fallback sur `fontId`.

Cela corrige notamment l'alignement de `Métier`, `Liquide`, `Banque` et des autres séparateurs du F5.


## Affichage du menu Véhicule

Le bouton **Véhicule** du menu F5 est affiché uniquement lorsque le joueur est dans un véhicule. Il disparaît automatiquement lorsqu'il est à pied.


## Intégration vêtements ox_menuf5

Le sous-menu **Vêtements** du F5 RageUI intègre désormais les fonctions de retrait de `ox_menuf5` : torse, pantalon, chaussures, masque, chapeau, sac, lunettes, gilet, boucles d'oreilles et chaîne.

Le système utilise `ox_lib` pour les animations/barres de progression et `ox_inventory` pour conserver les vêtements retirés avec leurs métadonnées. Les items vêtements correspondants doivent donc exister dans votre configuration `ox_inventory`.

Dépendances requises : `es_extended`, `ox_lib`, `ox_inventory`. `illenium-appearance` reste utilisé uniquement par le bouton **Recharger ma tenue**.
