---
description: Refactor code while preserving behavior
user_invocable: true
---

# /refactor

Refactorise du code en préservant le comportement existant.

## Steps
1. Read the code to refactor and understand its current behavior
2. Run existing tests to establish baseline: `flutter test`
3. Plan the refactoring (extract method, rename, restructure, etc.)
4. Apply changes incrementally
5. Run `flutter analyze` after changes
6. Run `flutter test` to verify no regression
7. Run `dart format .` to ensure formatting
8. Summarize what was refactored and why

## Rules
- NEVER change behavior during refactoring
- All existing tests must still pass
- If tests break, the refactoring introduced a bug — revert and retry
- Follow project architecture rules (feature-first, clean arch)
