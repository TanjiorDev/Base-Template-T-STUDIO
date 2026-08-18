<div align="center">
  <img src="https://img.shields.io/badge/FiveM-Script-orange?style=for-the-badge&logo=fivem&logoColor=white" />
  <img src="https://img.shields.io/badge/Framework-ESX-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Author-BloodLeak-purple?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-All%20Rights%20Reserved-red?style=for-the-badge" />
  
  <h1>🛡️ BloodAdmin (bl_admin)</h1>
  <p><i>L'administration ultime et moderne en verre dépoli pour votre serveur FiveM</i></p>
</div>

---

## 📖 À propos

**BloodAdmin** n'est pas un simple menu administratif. Conçu avec une approche moderne et épurée (Glassmorphism) et des performances optimisées (0.00ms au repos), il offre à votre équipe d'administration une interface fluide et haut de gamme. Intégrant un système de permissions sécurisé en temps réel et des logs complets, c'est l'outil indispensable pour gérer votre communauté.

---

## 🌟 Fonctionnalités Clés

- 🎨 **Interface Premium (UI) :** Design Glassmorphic élégant en verre dépoli avec animations fluides, angles arrondis et thèmes colorés dynamiques selon le grade.
- 👻 **Noclip & Invisibilité Ghostly :** Transparence à 20% côté admin pour un confort visuel maximal, tout en restant **100% invisible réseau** pour les autres joueurs en jeu.
- 👁️ **Ghost Ban (Dimension Fantôme) :** Isolez instantanément les tricheurs ou fauteurs de troubles dans une dimension parallèle (routing bucket séparé) où ils jouent totalement seuls au monde sans s'en rendre compte !
- ⛓️ **Système de Prison (Jail) :** Envoyez les joueurs en cellule avec durée paramétrable. Gestion persistante en base SQL avec téléportation automatique et libération automatique même après reconnexion.
- 👥 **Modération Hors-ligne (Offline) :** Interface synchronisée avec la base de données SQL pour lister, avertir (warn), bannir ou modifier les jobs/grades des joueurs déconnectés.
- 🔒 **Sécurité Double Couche :** Toutes les actions sensibles (Ban, Kick, Teleport, Give, Revive, etc.) sont systématiquement vérifiées côté serveur pour bloquer tout exploit de tricheurs. IP sécurisée avec double vérification.
- 🚗 **Gestion des Véhicules :** Spawnez des véhicules personnalisés, supprimez les entités proches et gérez un catalogue de véhicules directement depuis l'interface.
- 🌍 **Contrôle du Monde & Climat :** Modifiez instantanément la météo, gelez le temps, activez le blackout général ou nettoyez la carte (véhicules abandonnés, peds, objets).
- 📊 **Tableau de Bord & Métriques :** Graphiques et métriques en temps réel sur la consommation mémoire FXServer/Node.js, l'uptime, les reports actifs et le ping moyen.
- 💬 **Reports & Chat Modération :** Système complet de tickets d'aide (reports) en jeu et salon de discussion interne chiffré en direct pour le staff.
- 📜 **Logs SQL & Webhooks Discord :** Archivage persistant de chaque action dans la table `bl_logs` et notifications instantanées chiffrées sur vos salons Discord configurés.
- ⚡ **Diagnostic & Debugger SQL :** Commande `/admin_debug` exclusive pour analyser la base de données et valider instantanément les droits d'un staff.

---

## ⚙️ Prérequis

Pour fonctionner de manière optimale, le script nécessite :
- [**es_extended**](https://github.com/esx-framework/esx-legacy) (Legacy ou versions antérieures)
- [**oxmysql**](https://github.com/overextended/oxmysql) (ou mysql-async)

---

## 🚀 Installation & Utilisation

1. **Base de données :** Importez le fichier [data/database.sql](file:///c:/Users/natha/Desktop/BloodLeak%20v2/bl_admin/data/database.sql) dans votre base SQL.
2. **Configuration :** Ajustez les grades et configurez vos webhooks de logs dans le [config.lua](file:///c:/Users/natha/Desktop/BloodLeak%20v2/bl_admin/config.lua).
3. **Démarrage :** Ajoutez la ligne suivante dans votre fichier `server.cfg` :
   ```cfg
   ensure bl_admin
   ```
4. **S'attribuer les droits Staff (Console) :** Tapez la commande suivante dans la console de votre serveur pour vous attribuer le grade suprême :
   ```cmd
   setstaff [ID_Serveur] boss
   ```
   *(Exemple : `setstaff 1 boss` si vous êtes connecté avec l'ID 1. Utilisez `setstaff [ID] user` pour destituer.)*

---

## ⌨️ Commandes & Raccourcis

- **`admin` (Touche : `F10`) :** Ouvre l'interface NUI BloodAdmin (si vous êtes enregistré comme staff).
- **`/report` :** Permet aux joueurs d'ouvrir l'interface de création de ticket d'aide en jeu.
- **`/admin_debug` :** Permet de diagnostiquer les erreurs de permissions SQL directement en jeu ou dans la console.

---

<div align="center">
  <p><i>Développé avec passion par <b>BloodLeak</b>. Des designs haut de gamme et des performances optimisées pour votre communauté FiveM.</i></p>
</div>




