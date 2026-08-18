Bonjour / Bonsoir,

Nous vous recommandons vivement de **lire attentivement ce fichier** afin de prendre connaissance des différentes modifications apportées à ce framework et de pouvoir effectuer des ajustements selon vos besoins.

Version du framework : **1.13.4**

Plusieurs modifications ont été réalisées, notamment une refactorisation complète du système de jobs, avec l’ajout d’un système Job2.
Ce système a été conçu pour permettre la gestion et la liaison de gangs ou autres rôles secondaires en parallèle du job principal.
**À noter** : le système Job2 nécessite des connaissances de base en **SQL/MariaDB**, la base de données utilisée par votre serveur.

Par défaut, la base de données contient uniquement le job **vagos**, un gang issu du lore GTA.
Ce job peut être **modifié, supprimé ou complété selon vos besoins**, et vous pouvez également ajouter vos **propres jobs2.**

Nom de la table de Jobs2 Grade (Contient tous les grades associés aux différents jobs2) : *job2_grades*
Nom de la table Jobs2 (Contient l’ensemble des jobs secondaires) : *jobs2*

Pour pouvoir installez un nouveau Jobs2 il faut faire : 
```sql
INSERT INTO `jobs2` (`name`, `label`, `type`, `whitelisted`)
VALUES ('ballas', 'Ballas', 'gang', 0) -- Exemple ajustez.
```

Aprés avoir installez votre nouveau Jobs2 vous pouvez insérez les différents grades selons vos envies pour cela il faut faire :
```sql
INSERT INTO `job2_grades` (`job2_name`, `grade`, `name`, `label`, `salary`)
VALUES
('ballas', 0, 'recruit', 'Recrue', 0), -- Exemple ajustez.
('ballas', 1, 'soldier', 'Soldat', 0), -- Exemple ajustez.
('ballas', 2, 'boss', 'Boss', 0); -- Exemple ajustez.
```

**Attention !** : Les deux tables qui ont était présenté juste avant contienne un Job *Unemployed* et un Grade *Unemployed* il est fortement conseillez de **ne pas supprimer ce Jobs** il est essentiel de le garder afin que *es_extended* intialise le Job2 c'est exactement comme le Job de base, **veuillez ne pas supprimer ce job.**

Bon développement à vous!
**Nexora Developments - tarek.dev**