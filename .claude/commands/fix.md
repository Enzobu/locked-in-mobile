---
description: Fix a bug or failing test
user_invocable: true
---

# /fix

Corrige un bug ou un test qui échoue.

## Steps
1. Identify the issue (user description, failing test, error message)
2. Read relevant source files to understand the context
3. Identify root cause — don't just patch symptoms
4. Apply the minimal fix needed
5. Run `flutter analyze` to verify no new warnings
6. Run relevant tests to verify the fix: `flutter test test/path/to/relevant_test.dart`
7. If all passes, summarize what was wrong and what was fixed

## Rules
- Minimal changes — fix the bug, don't refactor surrounding code
- Always verify the fix with tests
- If the fix touches a feature, run that feature's tests
