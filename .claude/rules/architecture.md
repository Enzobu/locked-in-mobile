# Architecture Rules

## Feature-First Clean Architecture

Chaque feature suit la structure data/domain/presentation :

```
feature_name/
├── data/
│   ├── datasources/          # Mock ou API datasource
│   ├── repositories/         # Implémentation des repository interfaces
│   └── dtos/                 # Data Transfer Objects (JSON serialization)
├── domain/
│   ├── models/               # Entités métier (immutables)
│   └── repositories/         # Interfaces abstraites des repositories
└── presentation/
    ├── screens/              # Pages/écrans
    ├── widgets/              # Widgets spécifiques à la feature
    └── providers/            # Riverpod providers
```

## Règles strictes

1. **domain/ ne dépend de rien** sauf de Dart core
2. **data/ dépend de domain/** pour implémenter les interfaces
3. **presentation/ dépend de domain/** via les providers Riverpod
4. **Pas d'import croisé entre features** — utiliser core/ pour le code partagé
5. **Les models domain sont immutables** — utiliser copyWith si besoin
6. **Les DTOs gèrent la sérialisation JSON** — les models domain non
7. **Mock datasources** implémentent la même interface que les API datasources

## Riverpod
- Utiliser `@riverpod` annotation quand possible
- Providers dans `presentation/providers/`
- Un provider par responsabilité
- AsyncNotifier pour les états complexes avec mutations

## Widgets
- Extraire les widgets réutilisables dans `core/widgets/`
- Widgets spécifiques à une feature dans `feature/presentation/widgets/`
- Pas de logique métier dans les widgets — déléguer aux providers

## Navigation
- go_router avec routes déclarées dans `app/router.dart`
- Routes nommées avec constantes
