# t_hud_complete

Fusion propre de :
- `t_hud` : faim / soif
- `t_hud-heure` : heure / date / ID joueur
- `t_speedo` : compteur de vitesse / carburant

## Installation

1. Place le dossier `t_hud_complete` dans tes resources.
2. Désactive/supprime les trois anciennes ressources pour éviter les doublons.
3. Vérifie que `esx_status` démarre avant ce HUD.
4. Ajoute dans `server.cfg` :

```cfg
ensure esx_status
ensure t_hud_complete
```

## Nettoyage de sécurité effectué

La fusion n'intègre pas le fichier `assets/local_config.js` de `t_hud` : il contenait du code serveur obfusqué qui téléchargeait puis exécutait du JavaScript distant avec `eval()`.

Le `server/server.lua` de `t_speedo` n'est pas intégré non plus : le callback `gotoClient` n'était utilisé par aucun fichier fourni et contenait une boucle de spam console dans le code client renvoyé.

Le HUD fusionné n'a besoin d'aucun script serveur pour les fonctions visibles présentes dans ces trois ressources.
