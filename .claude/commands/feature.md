---
description: Implement a new feature following project conventions
user_invocable: true
---

# /feature

Implémente une nouvelle feature en suivant les conventions du projet.

## Steps
1. Identify the ticket in `tickets.md`
2. Create branch from dev: `git checkout dev && git pull && git checkout -b feature/TK-XXX-description`
3. Create the feature folder structure:
   ```
   lib/features/<name>/
   ├── data/datasources/
   ├── data/repositories/
   ├── data/dtos/
   ├── domain/models/
   ├── domain/repositories/
   └── presentation/screens/
   └── presentation/widgets/
   └── presentation/providers/
   ```
4. Implement domain models (immutable, based on MCD)
5. Implement repository interfaces in domain
6. Implement DTOs with JSON serialization in data
7. Implement mock datasource in data
8. Implement repository in data
9. Implement providers in presentation
10. Implement screens and widgets in presentation
11. Add localization strings in l10n/ ARB files
12. Write tests for business logic and key interactions
13. Run `flutter analyze` and `dart format .`
14. Run `flutter test`
15. Update ticket status in `tickets.md`

## Rules
- Follow feature-first clean architecture strictly
- All UI strings must be localized (FR, EN, DE, IT)
- Use Theme.of(context) for colors and styles
- Material Design 3 only, no Cupertino
- Mock data based on MCD schema in assets/mcd.json
