---
description: Summarize daily engineering diary entries into a weekly rollup markdown file.
allowed-tools: Read, Write, Glob, Grep, Bash(date *)
---

# Summarize Week

Read daily diary entries from `~/dev/engineering-notes/daily/` and produce a weekly summary in `~/dev/engineering-notes/weekly/`.

## Input

The user may provide a date or week reference (e.g. "last week", "week of March 9", "2026-03-09"). If none is given, default to the current week (Monday through today).

## Steps

1. **Determine date range.** Resolve the target week to a Monday–Friday date range. Use `date` to get today's date if needed.

2. **Find diary files.** Glob for `~/dev/engineering-notes/daily/YYYY-MM-DD.md` files within the date range. If no files exist, tell the user and stop.

3. **Read all matching files.** Read every diary file in the range.

4. **Identify themes.** Group entries by recurring lines of work, not by day. Look for:
   - Features or components worked on across multiple sessions
   - PRs opened, updated, or merged
   - Bug fixes and investigations
   - Tooling, infrastructure, or environment work
   - Planning or design sessions

5. **Write the summary.** Create `~/dev/engineering-notes/weekly/week_of_YYYY_MM_DD.md` (where the date is the Monday of that week). Format:

```
# Week of YYYY-MM-DD

## Theme Name

- Bullet points summarizing what was done
- Reference PRs, branches, key files where relevant
- Note key decisions and architectural insights

## Another Theme

...
```

Rules:
- Group by theme/workstream, not by day
- Lead with the largest workstream
- Be concise but preserve key decisions, PR numbers, and architectural insights
- No emojis
- If a theme only has one entry, still include it — just keep it short
