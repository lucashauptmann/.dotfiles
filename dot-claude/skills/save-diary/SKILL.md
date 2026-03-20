---
description: Save an engineering diary entry for the current session.
allowed-tools: Bash(bash ~/.claude/hooks/save-diary.sh)
---

# Save Diary

Save an engineering diary entry summarizing the current conversation.

## Steps

1. Run the save-diary hook manually:

```bash
echo '{"transcript_path": "'"$CLAUDE_TRANSCRIPT_PATH"'", "cwd": "'"$(pwd)"'"}' | bash ~/.claude/hooks/save-diary.sh
```

2. Confirm to the user that a diary entry is being saved in the background. The entry will appear in `~/dev/engineering-notes/daily/` under today's date.
