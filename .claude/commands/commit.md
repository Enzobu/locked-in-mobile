---
description: Commit changes following project git conventions
user_invocable: true
---

# /commit

Commit les changements en suivant les conventions du projet.

## Steps
1. Run `git status` to see changed files
2. Run `git diff --staged` to see staged changes (if any)
3. If nothing is staged, stage relevant files with `git add <files>` (never use `git add .` or `git add -A`)
4. Run `git log --oneline -5` to check recent commit style
5. Create commit with conventional format: `type: TK-XXX description`
   - `feat:` new feature
   - `fix:` bug fix
   - `refactor:` code refactoring
   - `test:` tests
   - `docs:` documentation
   - `chore:` maintenance
6. Verify with `git status` after commit

## Rules
- ALWAYS include ticket number if working on a ticket branch
- NEVER commit on `main` or `dev` directly
- NEVER use `--no-verify`
- Stage specific files, not everything
