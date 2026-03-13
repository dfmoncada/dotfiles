---
name: pr
description: Create a pull request with consistent format. Analyzes all commits, generates summary, and opens PR via gh CLI.
disable-model-invocation: true
allowed-tools: Bash(command git *), Bash(command gh *)
---

Create a pull request for the current branch.

## Process

1. Get current branch: `command git branch --show-current`
2. Get base branch (usually `main` or `master`): `command git remote show origin | rg 'HEAD branch'`
3. Get all commits since divergence: `command git log <base>..HEAD --oneline`
4. Get full diff: `command git diff <base>...HEAD --stat`
5. Analyze changes and generate PR

## PR Format

```
gh pr create --title "<type>: <concise title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullet points explaining what and why>

## Changes
<list of key changes with file references>

## Testing
<how this was tested>
EOF
)"
```

Types: feat, fix, refactor, docs, test, chore

If $ARGUMENTS contains additional context, incorporate it into the PR description.
