---
description: Review code changes for quality and conventions
user_invocable: true
---

# /review

Review les changements de code pour la qualité et le respect des conventions.

## Steps
1. Run `git diff dev...HEAD` to see all changes on the current branch
2. Check architecture rules: feature-first, clean separation data/domain/presentation
3. Check coding standards: naming, const, no magic strings, localization
4. Check for security issues (OWASP top 10)
5. Check test coverage for new logic
6. Run `flutter analyze` to check for warnings
7. Run `dart format --set-exit-if-changed .` to check formatting
8. Provide feedback with specific file:line references

## Checklist
- [ ] Architecture respectée (pas d'import croisé entre features)
- [ ] Models domain immutables
- [ ] Strings localisées (pas de texte en dur)
- [ ] Theme utilisé (pas de couleurs en dur)
- [ ] Tests présents pour la logique métier
- [ ] Pas de warnings flutter analyze
- [ ] Code formaté
