# Coding Standards

## Dart/Flutter
- Utiliser Material Design 3, JAMAIS Cupertino
- Primary color : `Color(0xFFE60024)`
- Toujours `const` constructors quand possible
- Nommage : camelCase pour variables/fonctions, PascalCase pour classes, snake_case pour fichiers
- Fichiers max ~300 lignes — découper si plus long
- Pas de magic numbers/strings — utiliser des constantes

## Imports
- Ordre : dart > flutter > packages > relatifs
- Imports relatifs au sein d'une feature
- Imports par package pour le cross-feature

## Localisation
- JAMAIS de strings en dur dans l'UI
- Utiliser `AppLocalizations.of(context)!.keyName`
- Langues supportées : FR (défaut), EN, DE, IT

## Theme
- Utiliser `Theme.of(context)` pour les couleurs et styles
- Pas de couleurs/styles en dur dans les widgets
- Support dark mode natif via ThemeData

## Tests
- Nommer les fichiers : `feature_name_test.dart`
- Grouper les tests par fonctionnalité avec `group()`
- Tester la logique métier, les providers, les interactions widget
- NE PAS tester le contenu textuel statique des widgets
