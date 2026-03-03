# Tickets - Locked In Mobile

## Légende statuts
- `TODO` — à faire
- `IN PROGRESS` — en cours
- `IN REVIEW` — PR créée, en attente de review
- `DONE` — terminé et mergé

---

## Epic 1 : Setup & Configuration

### TK-001 — Initialiser le projet et les dépendances
**Status**: `DONE`
**Branch**: `feature/TK-001-project-setup`
**Date de fin**: 2026-03-03
**Description**: Ajouter toutes les dépendances au pubspec.yaml (riverpod, go_router, dio, flutter_svg, lucide_icons, flutter_map, latlong2, shared_preferences, intl). Configurer analysis_options.yaml. Mettre en place la structure de dossiers feature-first.
**Acceptance Criteria**:
- [ ] Toutes les dépendances installées
- [ ] Structure de dossiers créée (app/, core/, features/, l10n/)
- [ ] `flutter analyze` passe sans erreur
- [ ] App démarre sans crash

### TK-002 — Configurer le thème Material 3 (light + dark)
**Status**: `TODO`
**Branch**: `feature/TK-002-theme-setup`
**Description**: Créer le ThemeData light et dark avec la couleur primaire #E60024. Configurer la typographie, les shapes, le color scheme complet Material 3.
**Acceptance Criteria**:
- [ ] ThemeData light fonctionnel
- [ ] ThemeData dark fonctionnel
- [ ] Couleur primaire #E60024 appliquée
- [ ] Toggle theme possible via provider

### TK-003 — Configurer la localisation (FR, EN, DE, IT)
**Status**: `TODO`
**Branch**: `feature/TK-003-localization-setup`
**Description**: Mettre en place flutter_localizations avec les fichiers ARB pour les 4 langues. Créer les clés de base (app_name, navigation labels, common actions). Configurer le provider de langue.
**Acceptance Criteria**:
- [ ] 4 fichiers ARB créés (fr, en, de, it)
- [ ] `flutter gen-l10n` génère les fichiers
- [ ] Changement de langue fonctionne via provider
- [ ] Français par défaut

### TK-004 — Configurer le routing (go_router) et navigation bottom bar
**Status**: `TODO`
**Branch**: `feature/TK-004-routing-navigation`
**Description**: Mettre en place go_router avec les 4 routes principales (home, map, reservations, profile). Créer le shell avec BottomNavigationBar Material 3. Pages placeholder pour chaque route.
**Acceptance Criteria**:
- [ ] 4 routes déclarées et fonctionnelles
- [ ] BottomNavigationBar avec 4 items (icônes Lucide)
- [ ] Navigation entre pages fluide
- [ ] State de la page conservé lors du switch

### TK-005 — Configurer le client HTTP (Dio) et intercepteurs JWT
**Status**: `TODO`
**Branch**: `feature/TK-005-http-client-setup`
**Description**: Créer le client Dio avec base URL configurable, intercepteur JWT (ajout token dans headers, refresh token), gestion des erreurs API standardisée.
**Acceptance Criteria**:
- [ ] Client Dio singleton via Riverpod
- [ ] Intercepteur JWT fonctionnel
- [ ] Gestion erreurs API (ApiException model)
- [ ] Tests unitaires pour les intercepteurs

---

## Epic 2 : Domain Models & Mock Data

### TK-006 — Créer les models domain
**Status**: `TODO`
**Branch**: `feature/TK-006-domain-models`
**Description**: Créer tous les models immutables basés sur le MCD : Address, Company, Specification, LockerBay, Locker, Customer, Reservation. Avec copyWith, equality, toString.
**Acceptance Criteria**:
- [ ] Tous les models créés dans les bons dossiers feature
- [ ] Models immutables avec final fields
- [ ] copyWith sur chaque model
- [ ] Tests unitaires pour chaque model

### TK-007 — Créer les DTOs et mock datasources
**Status**: `TODO`
**Branch**: `feature/TK-007-dtos-mock-data`
**Description**: Créer les DTOs avec fromJson/toJson pour chaque model. Créer des mock datasources avec des données réalistes basées sur le MCD (casiers à Paris, Lyon, Marseille, etc.). Les mock datasources implémentent les mêmes interfaces que les futures API datasources.
**Acceptance Criteria**:
- [ ] DTOs avec sérialisation JSON pour chaque model
- [ ] Mock datasources avec données réalistes (min 10 locker bays, 50 lockers)
- [ ] Interfaces repository définies dans domain/
- [ ] Implémentations mock dans data/
- [ ] Tests unitaires pour les DTOs (serialization round-trip)

---

## Epic 3 : Feature Auth

### TK-008 — Écran de login
**Status**: `TODO`
**Branch**: `feature/TK-008-login-screen`
**Description**: Créer l'écran de login avec email + mot de passe. Validation des champs. Gestion de l'état loading/error via Riverpod. Mock de l'authentification (accept any valid email/password combo). Stocker le token JWT mock dans SharedPreferences.
**Acceptance Criteria**:
- [ ] UI login responsive et agréable
- [ ] Validation email et password
- [ ] Loading state pendant la connexion
- [ ] Error state avec message
- [ ] Redirection vers home après login
- [ ] Token mock persisté
- [ ] Strings localisées (4 langues)
- [ ] Tests widget pour le flow login

### TK-009 — Écran d'inscription
**Status**: `TODO`
**Branch**: `feature/TK-009-register-screen`
**Description**: Créer l'écran d'inscription avec les champs : email, firstname, lastname, phone, password, confirm password. Validation de tous les champs. Mock de l'inscription.
**Acceptance Criteria**:
- [ ] UI inscription avec tous les champs customer
- [ ] Validation de chaque champ
- [ ] Confirmation mot de passe
- [ ] Mock inscription fonctionnel
- [ ] Redirection vers login après inscription
- [ ] Strings localisées
- [ ] Tests widget

### TK-010 — Gestion de session et auto-login
**Status**: `TODO`
**Branch**: `feature/TK-010-session-management`
**Description**: Vérifier au démarrage si un token JWT est présent et valide. Auto-redirect vers home si connecté, sinon vers login. Ajouter le logout. Guard sur les routes protégées via go_router redirect.
**Acceptance Criteria**:
- [ ] Auto-login si token valide
- [ ] Redirect vers login si pas de token
- [ ] Logout efface le token et redirige
- [ ] Route guard fonctionnel
- [ ] Tests unitaires pour la logique de session

---

## Epic 4 : Feature Home

### TK-011 — Home page : liste des casiers
**Status**: `TODO`
**Branch**: `feature/TK-011-home-locker-list`
**Description**: Afficher la liste des locker bays avec leurs infos (nom, adresse, nombre de casiers dispos, prix range). Cards cliquables vers le détail. Pull to refresh. Loading et empty states.
**Acceptance Criteria**:
- [ ] Liste de LockerBay cards
- [ ] Infos affichées : nom, ville, nombre de casiers, range de prix
- [ ] Pull to refresh
- [ ] Loading skeleton
- [ ] Empty state
- [ ] Navigation vers détail au tap
- [ ] Strings localisées
- [ ] Tests widget

### TK-012 — Recherche de casiers
**Status**: `TODO`
**Branch**: `feature/TK-012-search`
**Description**: Ajouter une barre de recherche sur la home page. Recherche par nom de locker bay, ville, adresse. Debounce de 300ms. Résultats filtrés en temps réel.
**Acceptance Criteria**:
- [ ] SearchBar Material 3
- [ ] Recherche par nom, ville, adresse
- [ ] Debounce 300ms
- [ ] Résultats mis à jour en temps réel
- [ ] État "aucun résultat"
- [ ] Tests unitaires pour la logique de recherche

### TK-013 — Filtres de casiers
**Status**: `TODO`
**Branch**: `feature/TK-013-filters`
**Description**: Ajouter un système de filtres : par prix (range slider), par taille (S/M/L basé sur specification), par matériau, par rechargeable (oui/non), par disponibilité. Bottom sheet ou panel de filtres.
**Acceptance Criteria**:
- [ ] UI filtres dans un BottomSheet
- [ ] Filtre prix (RangeSlider)
- [ ] Filtre taille (chips S/M/L)
- [ ] Filtre matériau (chips)
- [ ] Filtre rechargeable (switch)
- [ ] Filtres combinables
- [ ] Bouton reset filtres
- [ ] Compteur de résultats
- [ ] Strings localisées
- [ ] Tests unitaires pour la logique de filtrage

### TK-014 — Détail d'un locker bay
**Status**: `TODO`
**Branch**: `feature/TK-014-locker-bay-detail`
**Description**: Page de détail d'un locker bay : nom, adresse complète, entreprise, liste des casiers disponibles avec leurs specs et prix. Bouton pour réserver un casier spécifique.
**Acceptance Criteria**:
- [ ] Affichage infos complètes du locker bay
- [ ] Liste des casiers avec specs (taille, matériau, rechargeable)
- [ ] Prix affiché pour chaque casier
- [ ] Indicateur de disponibilité
- [ ] Bouton réserver
- [ ] Strings localisées
- [ ] Tests widget

---

## Epic 5 : Feature Map

### TK-015 — Page map avec casiers géolocalisés
**Status**: `TODO`
**Branch**: `feature/TK-015-map-page`
**Description**: Afficher une carte OpenStreetMap (flutter_map) avec des markers pour chaque locker bay. Centrer sur la position de l'utilisateur (ou Paris par défaut). Zoom et scroll fluides.
**Acceptance Criteria**:
- [ ] Carte OSM fonctionnelle
- [ ] Markers pour chaque locker bay
- [ ] Position utilisateur (avec permission) ou défaut Paris
- [ ] Zoom/scroll fluides
- [ ] Strings localisées

### TK-016 — Markers interactifs avec popup infos
**Status**: `TODO`
**Branch**: `feature/TK-016-map-markers-popup`
**Description**: Au tap sur un marker, afficher un popup/bottom sheet avec les infos du locker bay (nom, adresse, nombre de casiers, prix). Bouton pour naviguer vers le détail.
**Acceptance Criteria**:
- [ ] Tap sur marker ouvre un popup
- [ ] Infos affichées : nom, adresse, casiers dispos, prix
- [ ] Bouton "Voir détail" navigue vers TK-014
- [ ] Animation smooth du popup
- [ ] Strings localisées

### TK-017 — Géolocalisation et "casiers autour de moi"
**Status**: `TODO`
**Branch**: `feature/TK-017-geolocation`
**Description**: Demander la permission de géolocalisation. Bouton "autour de moi" centre la carte et filtre les casiers par proximité. Calcul de distance affichée sur les cards.
**Acceptance Criteria**:
- [ ] Permission géolocalisation (geolocator)
- [ ] Bouton recentrer sur ma position
- [ ] Distance affichée sur chaque marker/card
- [ ] Tri par proximité possible
- [ ] Gestion du refus de permission (fallback Paris)

---

## Epic 6 : Feature Reservations

### TK-018 — Flow de réservation d'un casier
**Status**: `TODO`
**Branch**: `feature/TK-018-reservation-flow`
**Description**: Depuis le détail d'un casier, permettre de créer une réservation. Sélection de la date. Récapitulatif avant confirmation. Mock de la création de réservation. Génération d'un public_form mock (code/QR).
**Acceptance Criteria**:
- [ ] Sélection date via DatePicker Material
- [ ] Récapitulatif : casier, lieu, date, prix, durée
- [ ] Bouton confirmer
- [ ] Mock création réservation
- [ ] Génération public_form (string aléatoire)
- [ ] Feedback succès avec animation
- [ ] Strings localisées
- [ ] Tests pour la logique de réservation

### TK-019 — Page mes réservations
**Status**: `TODO`
**Branch**: `feature/TK-019-my-reservations`
**Description**: Afficher les réservations de l'utilisateur connecté. Séparer en 2 sections : en cours et historique. Chaque card montre le lieu, la date, le casier, le statut. Possibilité d'annuler une réservation en cours.
**Acceptance Criteria**:
- [ ] Tabs ou sections "En cours" / "Historique"
- [ ] Card réservation : lieu, date, casier numéro, statut
- [ ] Annulation d'une réservation en cours (avec confirmation)
- [ ] Empty states pour chaque section
- [ ] Pull to refresh
- [ ] Strings localisées
- [ ] Tests widget

### TK-020 — Détail d'une réservation
**Status**: `TODO`
**Branch**: `feature/TK-020-reservation-detail`
**Description**: Page détail d'une réservation avec toutes les infos : casier, locker bay, adresse, date, prix, durée, public_form (code/QR), statut. Bouton annuler si en cours.
**Acceptance Criteria**:
- [ ] Toutes les infos de la réservation affichées
- [ ] Public form affiché (simuler un QR code ou code texte)
- [ ] Bouton annuler (avec dialog de confirmation)
- [ ] Indicateur de statut visuel
- [ ] Strings localisées

---

## Epic 7 : Feature Profile

### TK-021 — Page profil utilisateur
**Status**: `TODO`
**Branch**: `feature/TK-021-profile-page`
**Description**: Afficher les informations de l'utilisateur connecté (nom, email, téléphone). Avatar placeholder. Sections : infos personnelles, préférences, à propos.
**Acceptance Criteria**:
- [ ] Affichage infos user (firstname, lastname, email, phone)
- [ ] Avatar placeholder avec initiales
- [ ] Sections clairement séparées
- [ ] UI agréable et moderne
- [ ] Strings localisées

### TK-022 — Modification du profil
**Status**: `TODO`
**Branch**: `feature/TK-022-edit-profile`
**Description**: Permettre la modification des infos : firstname, lastname, phone, email. Formulaire avec validation. Mock de la mise à jour.
**Acceptance Criteria**:
- [ ] Formulaire édition avec pré-remplissage
- [ ] Validation des champs
- [ ] Mock update
- [ ] Feedback succès
- [ ] Strings localisées
- [ ] Tests widget

### TK-023 — Réglages et préférences
**Status**: `TODO`
**Branch**: `feature/TK-023-settings`
**Description**: Section réglages : choix de la langue (FR/EN/DE/IT), toggle dark mode, notifications (mock), bouton déconnexion. Persistance via SharedPreferences.
**Acceptance Criteria**:
- [ ] Sélecteur de langue (4 langues)
- [ ] Toggle dark mode
- [ ] Toggle notifications (mock)
- [ ] Bouton déconnexion
- [ ] Persistance des préférences
- [ ] Strings localisées
- [ ] Tests unitaires pour la persistance

---

## Epic 8 : Paiement (Mock — Stripe prévu)

### TK-024 — Intégration paiement mock (futur Stripe)
**Status**: `TODO`
**Branch**: `feature/TK-024-payment-mock`
**Description**: Ajouter un écran de paiement mock dans le flow de réservation. Simuler un formulaire carte (UI only). Préparer l'interface pour l'intégration Stripe future. Le "paiement" est toujours validé en mock.
**Acceptance Criteria**:
- [ ] Écran de paiement avec UI formulaire carte
- [ ] Bouton payer
- [ ] Mock toujours succès
- [ ] Interface PaymentService prête pour Stripe
- [ ] Strings localisées

---

## Epic 9 : Polish & UX

### TK-025 — Animations et transitions
**Status**: `TODO`
**Branch**: `feature/TK-025-animations`
**Description**: Ajouter des animations de transition entre pages, animations sur les cards (hero), loading skeletons, micro-interactions (boutons, favoris).
**Acceptance Criteria**:
- [ ] Page transitions fluides
- [ ] Hero animations sur les cards
- [ ] Loading skeletons
- [ ] Micro-interactions sur les boutons

### TK-026 — Gestion des erreurs et états vides
**Status**: `TODO`
**Branch**: `feature/TK-026-error-states`
**Description**: Créer des widgets réutilisables pour : erreur réseau, erreur serveur, état vide, retry. Les intégrer dans toutes les features.
**Acceptance Criteria**:
- [ ] Widget ErrorView réutilisable
- [ ] Widget EmptyState réutilisable
- [ ] Bouton retry
- [ ] Intégré dans toutes les features
- [ ] Strings localisées

---

## Résumé

| Epic | Tickets | Description |
|------|---------|-------------|
| 1 - Setup | TK-001 → TK-005 | Configuration projet, thème, i18n, routing, HTTP |
| 2 - Models | TK-006 → TK-007 | Domain models et mock data |
| 3 - Auth | TK-008 → TK-010 | Login, register, session |
| 4 - Home | TK-011 → TK-014 | Liste, recherche, filtres, détail |
| 5 - Map | TK-015 → TK-017 | Carte, markers, géoloc |
| 6 - Reservations | TK-018 → TK-020 | Flow résa, mes résa, détail |
| 7 - Profile | TK-021 → TK-023 | Profil, édition, réglages |
| 8 - Payment | TK-024 | Paiement mock (Stripe futur) |
| 9 - Polish | TK-025 → TK-026 | Animations, error states |
