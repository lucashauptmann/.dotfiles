---
description: Summarize the current work context - branch, recent changes, and what's in progress.
allowed-tools: Bash(git *), Bash(pwd), Read, Glob, Grep
---

# Recap

Give a concise summary of the current work context so the user can pick up where they left off.

## Steps

1. **Branch and repo.** Run `git branch --show-current` and `pwd` to identify the branch and project.

2. **Recent commits on this branch.** Run `git log --oneline master..HEAD` (or `main..HEAD`) to see all commits on the current branch. If the branch has no divergence from master, show the last 5 commits instead.

3. **Uncommitted changes.** Run `git status --short` and `git diff --stat` to summarize any staged/unstaged work.

4. **Merge/rebase state.** Check for `.git/MERGE_HEAD`, `.git/rebase-merge/`, or `.git/rebase-apply/` to detect in-progress merges or rebases.

5. **Open PR.** Run `gh pr view --json title,url,state,reviewDecision,statusCheckRollup 2>/dev/null` to check if there's an open PR for this branch.

6. **Summarize.** Present a concise recap:

```
## Branch
{branch name} — {one-line purpose inferred from branch name and commits}

## Recent Commits
- {commit summaries}

## Uncommitted Work
{staged/unstaged summary, or "Clean working tree"}

## PR Status
{PR title, URL, review status, CI status — or "No PR yet"}

## What's Next
{Infer likely next steps from the state: e.g. "merge conflict to resolve", "CI failing", "ready to push", "waiting on review", "continue implementation"}
```

Rules:
- Be concise — this is a morning refresher, not a detailed report
- Infer purpose from branch name, commit messages, and changes
- If CI checks are failing, mention which ones
- No emojis
