# Locked In Mobile - Flutter Locker Reservation App

## Project Overview
Application mobile Flutter de réservation de casiers (lockers). Backend Symfony avec API REST distante, authentification JWT.

## Tech Stack
- **Framework**: Flutter (Material Design 3, pas Cupertino)
- **State Management**: Riverpod (flutter_riverpod + riverpod_annotation)
- **Icons**: Lucide (lucide_icons)
- **SVG**: flutter_svg
- **Maps**: flutter_map + latlong2 (OpenStreetMap, gratuit)
- **HTTP**: dio
- **Routing**: go_router
- **i18n**: flutter_localizations + intl (FR, EN, DE, IT)
- **Storage local**: shared_preferences
- **Primary Color**: #E60024
- **Dark mode**: supporté

## Architecture - Feature First Clean Architecture
```
lib/
├── app/                          # App-level config (theme, router, providers)
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/                         # Shared utilities
│   ├── constants/
│   ├── extensions/
│   ├── network/                  # Dio client, interceptors, JWT
│   ├── models/                   # Base models (api_response, pagination)
│   └── widgets/                  # Shared widgets
├── features/
│   ├── auth/                     # Login, register, JWT management
│   │   ├── data/                 # repositories, datasources, DTOs
│   │   ├── domain/               # models, repository interfaces
│   │   └── presentation/         # screens, widgets, providers
│   ├── home/                     # Home page, search, filters
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── map/                      # Map view with pins
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── reservations/             # Booking history & active
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/                  # User info, settings, language
│       ├── data/
│       ├── domain/
│       └── presentation/
├── l10n/                         # Localization files (ARB)
│   ├── app_fr.arb
│   ├── app_en.arb
│   ├── app_de.arb
│   └── app_it.arb
└── main.dart
```

## Database Schema (MCD)
Référence : `assets/mcd.json`
- **customer**: id, email, firstname, lastname, password, phone
- **locker**: id, specification_id, locker_bay_id, number, price
- **locker_bay**: id, company_id, address_id, name, hire_duration
- **specification**: id, height, width, depth, material, name, is_rechargeable
- **company**: id, name, address_id, siren
- **address**: id, number, city, country, address, complement
- **reservation**: id, public_form, date, customer_id, locker_id

## Git Flow - STRICT
- Branche principale : `main`
- Branche de développement : `dev`
- Convention de nommage : `feature/TK-XXX-short-description`, `fix/TK-XXX-short-description`, `refactor/TK-XXX-short-description`
- **1 ticket = 1 branche = 1 PR sur dev**
- Tickets gérés via GitHub Issues (`gh issue list/view`)
- Commits conventionnels : `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`

## Mock Data
Tant que le backend n'est pas prêt, utiliser des données mock JSON basées sur le MCD. Les datasources mock implémentent les mêmes interfaces que les datasources API pour un swap facile.

## Testing
- Chaque feature a ses tests (unit + widget)
- On teste la logique métier et les interactions importantes, pas le contenu textuel des widgets
- Fichiers de test miroir de la structure lib/ dans test/

## Commands
- `flutter run` : lancer l'app
- `flutter test` : lancer les tests
- `flutter analyze` : analyser le code
- `dart format .` : formater le code
- `flutter gen-l10n` : générer les fichiers de localisation
