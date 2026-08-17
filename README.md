# 🚀 T-STUDIO — BASE TEMPLATE FIVEM

Bienvenue sur la **Base Template T-Studio**, une base FiveM conçue pour faciliter la création et le développement d'un serveur RolePlay sous **ESX Legacy**.

Cette template fournit une structure prête à être configurée et personnalisée selon les besoins de votre projet.

---

## 📋 Informations

* **Nom :** Base Template T-Studio
* **Plateforme :** FiveM
* **Framework :** ESX Legacy
* **Langage principal :** Lua
* **Base de données :** MySQL / MariaDB
* **Développement :** T-Studio
* **Statut :** Base Template

---

# ✨ Fonctionnalités

La Base Template T-Studio a pour objectif de proposer :

* ⚡ Une base prête à configurer
* 🧩 Une organisation claire des ressources
* 🎮 Une base adaptée aux serveurs RolePlay
* 🛠️ Une configuration facilement modifiable
* 💾 Une intégration avec une base de données MySQL/MariaDB
* 🔧 Une structure permettant d'ajouter facilement vos propres ressources
* 🇫🇷 Une base pensée principalement pour les projets francophones

---

# 📦 Prérequis

Avant l'installation, vous devez disposer de :

* Un serveur **FiveM / FXServer**
* Une clé de licence **Cfx.re**
* Une base de données **MySQL ou MariaDB**
* **ESX Legacy**
* **oxmysql**
* Les dépendances présentes dans la Base Template

Selon les ressources installées dans votre version de la template, d'autres dépendances peuvent également être nécessaires, par exemple :

* `ox_lib`
* `ox_inventory`
* `ox_target`

> ⚠️ Vérifiez toujours les `fxmanifest.lua` et la documentation des ressources avant de modifier ou supprimer une dépendance.

---

# 📥 Installation

## 1. Télécharger la Base Template

Téléchargez la dernière version de la **Base Template T-Studio**.

Décompressez ensuite l'archive.

Vous devriez obtenir une structure contenant notamment les fichiers de configuration du serveur et le dossier des ressources.

Exemple :

```text
Base-Template-T-Studio/
│
├── resources/
│   ├── [core]/
│   ├── [standalone]/
│   ├── [esx]/
│   └── ...
│
├── server.cfg
└── README.md
```

La structure exacte peut varier selon la version de la template.

---

# 🗄️ Installation de la base de données

Créez une nouvelle base de données MySQL/MariaDB pour votre serveur.

Exemple :

```text
tstudio
```

Importez ensuite les fichiers `.sql` fournis avec la Base Template et avec les ressources qui en nécessitent.

Configurez votre connexion MySQL dans votre `server.cfg`.

Exemple :

```cfg
set mysql_connection_string "mysql://UTILISATEUR:MOT_DE_PASSE@127.0.0.1/NOM_DATABASE?charset=utf8mb4"
```

Remplacez :

```text
UTILISATEUR
MOT_DE_PASSE
NOM_DATABASE
```

par les informations de votre propre base de données.

> 🔐 Ne publiez jamais votre véritable mot de passe MySQL dans un dépôt GitHub public.

---

# 🔑 Configuration FiveM

Ouvrez :

```text
server.cfg
```

Configurez ensuite les informations principales de votre serveur.

Exemple :

```cfg
sv_hostname "Mon Serveur RP"

sets sv_projectName "Mon Serveur"
sets sv_projectDesc "Serveur FiveM basé sur la Base Template T-Studio"

sets locale "fr-FR"

sv_maxclients 48
```

Ajoutez également votre clé de licence Cfx.re :

```cfg
sv_licenseKey "VOTRE_CLE_CFX"
```

> ⚠️ Votre véritable clé Cfx.re doit rester privée. Ne la publiez jamais directement sur GitHub.

---

# ⚙️ Ordre de démarrage

L'ordre des ressources est important.

Les dépendances doivent être démarrées avant les ressources qui les utilisent.

Une configuration utilisant l'écosystème ox peut par exemple contenir :

```cfg
# ================================
# FiveM
# ================================

ensure chat
ensure spawnmanager
ensure sessionmanager
ensure hardcap
ensure rconlog

# ================================
# DATABASE
# ================================

ensure oxmysql

# ================================
# LIBRAIRIES / FRAMEWORK
# ================================

ensure ox_lib
ensure es_extended

# ================================
# TARGET / INVENTORY
# ================================

ensure ox_target
ensure ox_inventory

# ================================
# RESSOURCES T-STUDIO
# ================================

ensure [t_studio]
```

> ⚠️ Cet exemple doit être adapté aux ressources réellement présentes dans votre version de la Base Template.

---

# ▶️ Démarrage du serveur

## Avec txAdmin

Si votre serveur utilise **txAdmin** :

1. Démarrez FXServer.
2. Ouvrez votre interface txAdmin.
3. Sélectionnez votre configuration.
4. Vérifiez le `server.cfg`.
5. Lancez le serveur.
6. Consultez la console afin de détecter les éventuelles erreurs.

---

## Démarrage manuel — Windows

Depuis le dossier approprié :

```bat
FXServer.exe +exec server.cfg
```

Le chemin peut varier selon votre installation.

---

## Démarrage manuel — Linux

Selon l'installation de FXServer :

```bash
./run.sh +exec server.cfg
```

---

# 🛠️ Commandes utiles

Dans la console FiveM :

### Actualiser la liste des ressources

```text
refresh
```

### Démarrer une ressource

```text
ensure nom_resource
```

### Arrêter une ressource

```text
stop nom_resource
```

### Redémarrer une ressource

```text
restart nom_resource
```

Exemple :

```text
restart es_extended
```

> ⚠️ Évitez de redémarrer certaines ressources critiques sur un serveur rempli de joueurs sans connaître les conséquences.

---

# 📁 Ajouter une nouvelle ressource

Placez votre ressource dans :

```text
resources/
```

Vous pouvez également organiser vos ressources par catégories :

```text
resources/
├── [core]/
├── [jobs]/
├── [vehicles]/
├── [maps]/
└── [t_studio]/
```

Ajoutez ensuite la ressource dans votre `server.cfg` :

```cfg
ensure ma_resource
```

Ou démarrez une catégorie entière :

```cfg
ensure [t_studio]
```

Après l'ajout d'une ressource pendant que FXServer fonctionne :

```text
refresh
ensure ma_resource
```

---

# 🔧 Configuration

Chaque ressource peut posséder sa propre configuration.

Recherchez notamment les fichiers :

```text
config.lua
shared/config.lua
config/
locales/
fxmanifest.lua
```

Avant de modifier une ressource, vérifiez ses dépendances dans :

```text
fxmanifest.lua
```

---

# 🔒 Sécurité

Avant de mettre votre serveur en production ou de publier votre template sur GitHub, vérifiez qu'aucune information sensible n'est présente.

Ne publiez jamais :

* ❌ Mot de passe MySQL
* ❌ Clé de licence Cfx.re
* ❌ Token Discord
* ❌ Token de bot
* ❌ Webhook Discord privé
* ❌ Clé API
* ❌ Identifiants d'administration
* ❌ Informations privées de votre VPS

Utilisez des valeurs d'exemple :

```cfg
sv_licenseKey "CHANGE_ME"
```

et :

```cfg
set mysql_connection_string "mysql://USER:PASSWORD@127.0.0.1/DATABASE"
```

---

# 🐛 Problèmes fréquents

## Une ressource ne démarre pas

Vérifiez :

```text
fxmanifest.lua
```

Puis contrôlez :

* les dépendances ;
* l'ordre du `server.cfg` ;
* le nom du dossier ;
* les erreurs Lua ;
* les fichiers manquants.

---

## ESX ne démarre pas

Vérifiez que la base de données est accessible et que `oxmysql` est démarré avant `es_extended`.

Exemple :

```cfg
ensure oxmysql
ensure ox_lib
ensure es_extended
```

---

## Erreur MySQL

Vérifiez votre :

```cfg
mysql_connection_string
```

ainsi que :

* l'adresse du serveur MySQL ;
* le port ;
* l'utilisateur ;
* le mot de passe ;
* le nom de la base de données ;
* les permissions de l'utilisateur MySQL.

---

## Une ressource n'est pas détectée

Dans la console :

```text
refresh
```

Puis :

```text
ensure nom_resource
```

---

# 🔄 Mise à jour

Avant toute mise à jour de la Base Template :

1. Arrêtez votre serveur.
2. Sauvegardez votre base de données.
3. Sauvegardez votre dossier `resources`.
4. Sauvegardez vos configurations.
5. Consultez les changements de la nouvelle version.
6. Effectuez la mise à jour.
7. Vérifiez les fichiers SQL.
8. Redémarrez le serveur.
9. Contrôlez entièrement la console.

> 💾 Faites toujours une sauvegarde avant une mise à jour importante.

---

# 🌐 GitHub

Pour contribuer ou modifier la template :

```bash
git clone VOTRE_URL_GITHUB
```

Puis :

```bash
cd Base-Template-T-Studio
```

Après vos modifications :

```bash
git add .
git commit -m "Update Base Template T-Studio"
git push
```

---

# ⚠️ Important

Cette Base Template constitue un point de départ.

Selon votre serveur, vous devrez adapter :

* les métiers ;
* l'économie ;
* les permissions ;
* les véhicules ;
* les mappings ;
* les interfaces ;
* les items ;
* les configurations ESX ;
* les ressources additionnelles.

Une configuration adaptée à votre projet reste nécessaire.

---

# 📜 Crédits

## 💙 T-Studio

**Base Template créée et configurée par T-Studio.**

Merci aux développeurs et contributeurs des différents projets open source utilisés par la template.

Les ressources tierces restent la propriété de leurs auteurs respectifs et sont soumises à leurs propres licences.

### Principaux projets

* **Cfx.re / FiveM**
* **ESX Legacy**
* **Community Ox / ressources ox**, lorsqu'elles sont présentes dans la distribution

---

# 📄 Licence

Les ressources tierces incluses ou utilisées avec cette Base Template conservent leurs licences respectives.

Avant toute redistribution, modification ou utilisation commerciale, consultez les licences des différents projets concernés.

Les éléments développés spécifiquement par **T-Studio** peuvent être soumis à des conditions supplémentaires précisées avec leur distribution.

---

# ❤️ T-STUDIO

Merci d'utiliser la **Base Template T-Studio**.

Notre objectif est de proposer une base claire et accessible permettant de commencer plus facilement un projet FiveM.

**T-Studio — Créez votre serveur, développez votre univers.**
