---
description: Push, create PR, merge, close issue and update GitHub Project
user_invocable: true
---

# /merge

Finalise un ticket : push la branche, crée la PR, merge, met à jour le projet GitHub et ferme l'issue.

## Steps
1. Run `git branch --show-current` to get the current branch name
2. Extract the ticket number from the branch name (e.g. `TK-007` from `feature/TK-007-dtos-mock-data`)
3. Verify we are NOT on `main` or `dev` — abort if so
4. Run `flutter analyze` to check for issues
5. Run `dart format . --set-exit-if-changed` to check formatting
6. Run `flutter test` to verify all tests pass
7. Push the branch: `git push -u origin <branch>`
8. Create the PR toward `dev`: `gh pr create --base dev --fill`
9. Merge the PR: `gh pr merge --merge`
10. Switch to dev: `git checkout dev && git pull`
11. Find the GitHub issue number matching the ticket (e.g. TK-007 → issue that has TK-007 in the title): `gh issue list --search "TK-XXX" --json number --jq '.[0].number'`
12. Update the GitHub Project fields:
    - Set **Status** to **Done** (option ID: `98236657`)
    - Set **Start date** to the date of the first commit on the branch
    - Set **Target date** (end date) to today's date
    - Use `gh api graphql` with the project ID `PVT_kwHOBwyxZs4BIbET` (owner: `Enzobu`)
    - First get the item ID: `gh project item-list 5 --owner Enzobu --format json` and find the item for this issue
    - Then update fields with `gh project item-edit`
13. Close the issue: `gh issue close <number>`
14. Confirm everything is done with a summary

## Getting project field IDs
```bash
# Get Status field ID
gh project field-list 5 --owner Enzobu --format json

# Get item ID for the issue
gh project item-list 5 --owner Enzobu --format json | jq '.items[] | select(.content.number == ISSUE_NUMBER)'
```

## Updating project fields via GraphQL
```bash
# Update Status to Done
gh api graphql -f query='mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwHOBwyxZs4BIbET"
    itemId: "ITEM_ID"
    fieldId: "STATUS_FIELD_ID"
    value: { singleSelectOptionId: "98236657" }
  }) { projectV2Item { id } }
}'

# Update date fields
gh api graphql -f query='mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwHOBwyxZs4BIbET"
    itemId: "ITEM_ID"
    fieldId: "DATE_FIELD_ID"
    value: { date: "YYYY-MM-DD" }
  }) { projectV2Item { id } }
}'
```

## Rules
- NEVER run on `main` or `dev`
- ALWAYS run checks (analyze, format, test) before pushing
- ALWAYS verify the PR is created successfully before merging
- If any check fails, stop and fix before continuing
- The start date is the date of the first commit on the branch (use `git log --reverse --format=%ai <branch> --not dev | head -1`)
- The end date (Target date) is today's date
