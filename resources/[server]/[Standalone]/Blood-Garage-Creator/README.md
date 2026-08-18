<div align="center">
  <img src="https://img.shields.io/badge/FiveM-Script-orange?style=for-the-badge&logo=fivem&logoColor=white" />
  <img src="https://img.shields.io/badge/Framework-ESX-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Author-BloodLeak-purple?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-All%20Rights%20Reserved-red?style=for-the-badge" />
  
  <h1>🚗 BloodGarage (bl_garage)</h1>
  <p><i>Le système de gestion de garage et de fourrière ultime, moderne et 100% SQL-déterminé pour votre serveur FiveM</i></p>
</div>

---

## 📖 À propos

**BloodGarage** n'est pas un simple garage script FiveM. Conçu avec une approche esthétique moderne et épurée (Glassmorphism), il offre à vos joueurs et administrateurs une interface fluide et haut de gamme, avec des performances optimisées (0.00ms au repos) et une persistance robuste. Grâce à sa persistance 100% SQL et son panneau d'administration interactif en jeu, c'est la solution ultime pour le parc automobile de votre serveur.

---

## 🌟 Fonctionnalités Clés

- 🎨 **Interface Premium (UI) :** Design volcanique élégant en verre dépoli avec animations fluides, barres de télémétrie réactives (moteur, carrosserie, essence), filtres de catégories interactifs et support d'images de véhicules via CDN.
- 📍 **Points de Spawn Multiples & Anti-Collision :** Déclarez et gérez plusieurs coordonnées de sortie (spawn) par garage directement depuis le panneau admin en jeu pour éviter que les véhicules n'apparaissent les uns sur les autres.
- 🔒 **Persistance 100% SQL (bl_garages) :** Oubliez les sauvegardes de fichiers instables. Vos points créés sont stockés dans une table SQL dédiée, les protégeant contre toute suppression accidentelle, synchronisation txAdmin ou écrasement FTP.
- 🤖 **PNJs Persistants & Fearless :** Garagistes et agents de fourrière entièrement configurés avec une immunité absolue contre la panique, les balles et les collisions, ancrés au sol comme entités de mission.
- 🅿️ **Rangement Confortable :** Zone de marker rouge visible de 7 mètres de diamètre pour ranger les véhicules facilement, même à pied ou en grand convoi.
- ⚡ **Sécurité Anti-Duplication :** Blocage automatique du spawn si le véhicule est déjà dehors, remplacé par un système de **Balise GPS** active en jeu pour le localiser.
- 🧹 **Nettoyage Automatique (Auto-Impound) :** Routine serveur autonome envoyant les véhicules abandonnés à la fourrière après 10 minutes d'inactivité.
- 💸 **Frais Paramétrables :** Taxes de récupération de fourrière et frais de livraison d'un garage à un autre (valet de livraison) configurables à la volée.
- 💬 **Débogage Silencieux :** Interrupteur `Config.Debug = false` pour des consoles de jeu et serveur entièrement propres par défaut.

---

## ⚙️ Prérequis

Pour fonctionner de manière optimale, le script nécessite :
- [**es_extended**](https://github.com/esx-framework/esx-legacy) (Legacy ou versions antérieures)
- [**oxmysql**](https://github.com/overextended/oxmysql) (ou mysql-async)

---

## 🚀 Installation & Utilisation

1. **Base de données :** Importez le fichier [database.sql](file:///c:/Users/natha/Desktop/BloodLeak%20v2/bl_garage/database.sql) dans votre base de données SQL pour initialiser la table de persistance.
2. **Configuration :** Ajustez les prix, grades de staff, et identifiants autorisés dans le [config.lua](file:///c:/Users/natha/Desktop/BloodLeak%20v2/bl_garage/config.lua).
3. **Démarrage :** Ajoutez la ligne suivante dans votre fichier `server.cfg` :
   ```cfg
   ensure bl_garage
   ```

---

## ⌨️ Commandes & Raccourcis

- **`/garageadmin` ou `/admingarage` :** Ouvre le panneau d'administration générale en jeu pour créer, éditer ou supprimer des garages et fourrières sur place en temps réel.
- **`/exportgarages` :** Exporte instantanément tous les garages de la base de données (fusionnés avec ceux par défaut) dans un fichier `config_exported.lua` prêt à être copié-collé dans votre `config.lua` pour partager vos configurations.
- **Rangement ([E]) :** Rapprochement d'une zone rouge pour stocker instantanément son véhicule.

---

## 🛠️ Nouveautés de la Version 1.8.2

- **⛵ Fourrière Bateaux par défaut (`FourriereMarina`) :** Un point de fourrière navale natif pré-configuré à la Marina de Los Santos avec spawn de bateaux directement dans l'eau.
- **🔄 Outil d'exportation vers Config :** Simplifie la distribution et le partage de votre parc automobile en convertissant vos points dynamiques de la base de données en code statique propre.
- **🔔 Vérificateur de version sémantique :** Système d'alerte minimaliste, compact et élégant qui vérifie les versions sur votre dépôt GitHub (`Linspecteur/Blood-Garage-Creator`) et ne prévient la console qu'en cas de réelle mise à jour disponible.

---

<div align="center">
  <p><i>Développé avec passion par <b>BloodLeak</b>. Des designs haut de gamme et des performances optimisées pour votre communauté FiveM.</i></p>
</div>

https://youtu.be/Q5F2gePhcI8
