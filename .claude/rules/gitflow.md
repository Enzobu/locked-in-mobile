# Git Flow Rules

## INTERDIT : JAMAIS de commit sur `dev` ou `main`
Aucun commit direct sur `dev` ou `main`. JAMAIS. Toute modification passe par une branche de ticket.

## STRICT: 1 Ticket = 1 Branche = 1 PR

Chaque tâche de développement DOIT suivre ce workflow dans l'ordre :

1. **Identifier le ticket** via GitHub Issues (`gh issue view TK-XXX`)
2. **Créer la branche** depuis `dev` : `git checkout dev && git pull && git checkout -b feature/TK-XXX-description`
3. **Développer avec des petits commits réguliers** — ne pas accumuler tout dans un seul commit. Committer à chaque étape logique (model créé, provider ajouté, écran terminé, tests écrits, etc.)
4. **Push la branche** sur le remote : `git push -u origin feature/TK-XXX-description`
5. **Créer une PR (merge request)** vers `dev` via `gh pr create`
6. **Merger la PR** via `gh pr merge --merge`
7. **Revenir sur dev** : `git checkout dev && git pull`
8. **Fermer l'issue GitHub** via `gh issue close`

## Convention de nommage des branches
- Features : `feature/TK-XXX-description-courte`
- Fixes : `fix/TK-XXX-description-courte`
- Refactors : `refactor/TK-XXX-description-courte`
- Tests : `test/TK-XXX-description-courte`

## Convention de commits
Format : `type: TK-XXX description`
- `feat:` nouvelle fonctionnalité
- `fix:` correction de bug
- `refactor:` refactoring sans changement fonctionnel
- `test:` ajout/modification de tests
- `docs:` documentation
- `chore:` maintenance, dépendances, config

### Petits commits réguliers — exemples
```
feat: TK-006 add Address and Company domain models
feat: TK-006 add Locker and LockerBay domain models
feat: TK-006 add Reservation and Customer domain models
test: TK-006 add unit tests for domain models
chore: TK-006 run flutter analyze and format
```

## Règles
- **JAMAIS** commit directement sur `main` ou `dev`
- TOUJOURS travailler sur une branche de ticket
- Commits petits et fréquents, pas de gros commit monolithique
- Push la branche avant de créer la PR
- Une PR doit être propre : code formaté, pas de warnings, tests passent
- Fermer l'issue GitHub une fois le ticket terminé
