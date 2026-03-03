je veux faire une application flutter de réservation de casier, voici les principales fonctionnalités que je veux :
- 4 pages : home, map, mes réservations, profile
- sur la home page : possibilité de voir les casier autour de nous, tous les casiers, rechercher, filtrer
- sur la page map : possibilité de voir les casiers sur une map, avec des pin cliquales qui affichent des infos une fois cliqués
- sur la page mes réservations on peut voir les infos des réservations précédentes et en cours
- la page profile sera destiné à afficher et modifier les informations de l'utilisateur, réglage, préférence, langue...

pour les dépendances, tu vas télécharger toutes celles dont on a besoin, j'utilise riverpod pour le state management, flutter svg pour les images, lucide pour les icones. utilise pas cuppertino mais material.

pour l'ui la couleur principal du site est #E60024, tu as le modèle mcd du backend ici pour avoir les informations des tables et construire des json mock au début.

tu vas créer ta propre config avec claude.md, subagents et rules pour mener à bien ce projet, garder une architecture clean feature first. 

je veux que tu fasses une découpe des taches en ticket et que a chaque étape de développement tu respectes ce gitflow : découper chaque tache en ticket, un ticket = une branche = une pr sur dev. tu feras les tickets dans un tickets.md au début puis on verra après pour les faire sur github directement, rajoute toi cette règle dans tes rules c'est très important

tu feras des skills commit, review, test, fix, refactor, feature.