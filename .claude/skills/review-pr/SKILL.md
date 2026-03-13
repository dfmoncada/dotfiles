---
name: review-pr
description: Review a pull request for quality, security, and correctness. Pass PR number as argument.
disable-model-invocation: true
context: fork
agent: code-reviewer
allowed-tools: Bash(command gh *), Bash(command git *)
---

Review pull request #$ARGUMENTS.

## Process

1. Fetch PR details: `command gh pr view $0 --json title,body,files,commits`
2. Get the diff: `command gh pr diff $0`
3. Read changed files in full context (not just the diff)
4. Run the review checklist from your agent instructions
5. Check for:
   - Breaking changes not mentioned in PR description
   - Missing tests for new functionality
   - Security issues (exposed secrets, SQL injection, XSS)
   - Performance regressions
   - API contract changes

## Output Format

Organize findings as:
- **Critical** (must fix before merge)
- **Warnings** (should fix)
- **Suggestions** (nice to have)
- **Positive** (good patterns worth noting)

Reference specific files and line numbers.
