---
description: Run tests and report results
user_invocable: true
---

# /test

Lance les tests et rapporte les résultats.

## Steps
1. Run `flutter test` to execute all tests
2. If specific feature requested, run `flutter test test/features/<feature_name>/`
3. Parse output for failures
4. For failures: read the failing test file, identify the issue, report with file:line
5. Report summary: total tests, passed, failed, skipped

## Options
- `/test` — run all tests
- `/test <feature>` — run tests for a specific feature
- `/test --coverage` — run with coverage report
