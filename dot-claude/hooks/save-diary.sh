#!/bin/bash
# Engineering diary hook — saves a work summary before /clear, /compact
# Reads transcript JSONL, summarizes via claude -p, appends to daily file

set -euo pipefail

DIARY_DIR="$HOME/dev/engineering-notes"
MAX_CHARS="${DIARY_MAX_CHARS:-80000}"

# Read hook input from stdin
INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  exit 0
fi

# Extract readable conversation text (human + assistant text blocks)
CONVERSATION=$(jq -r '
  select(.message) |
  if .message.role == "user" then
    if (.message.content | type) == "string" then
      "USER: " + .message.content
    else
      "USER: " + ([.message.content[] | select(.type == "text") | .text] | join(" "))
    end
  elif .message.role == "assistant" then
    "ASSISTANT: " + ([.message.content[] | select(.type == "text") | .text] | join(" "))
  else
    empty
  end
' "$TRANSCRIPT_PATH" 2>/dev/null)

if [ -z "$CONVERSATION" ]; then
  exit 0
fi

TOTAL_CHARS=${#CONVERSATION}

# Truncate if too long: keep first half + last half
if [ "$TOTAL_CHARS" -gt "$MAX_CHARS" ]; then
  HALF=$(( MAX_CHARS / 2 ))
  FIRST_HALF="${CONVERSATION:0:$HALF}"
  LAST_HALF="${CONVERSATION:$(( TOTAL_CHARS - HALF ))}"
  CONVERSATION="${FIRST_HALF}

[... truncated $(( TOTAL_CHARS - MAX_CHARS )) chars ...]

${LAST_HALF}"
fi

PROJECT_NAME=$(basename "$CWD")
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%H:%M)
DIARY_FILE="$DIARY_DIR/daily/$DATE.md"

mkdir -p "$DIARY_DIR"

# Summarize via claude (unset CLAUDECODE to allow nested invocation from hooks)
SUMMARY=$(echo "$CONVERSATION" | CLAUDECODE= claude -p \
  "Summarize this Claude Code session for an engineering diary. Be concise. Use bullet points.
Focus on: what was built/changed, key decisions made, problems solved, files modified.
Skip meta/tool noise. Output plain markdown bullets only, no headers. Project: $PROJECT_NAME" \
  2>/dev/null) || true

if [ -z "$SUMMARY" ]; then
  exit 0
fi

# Create file header if new
if [ ! -f "$DIARY_FILE" ]; then
  echo "# $DATE" > "$DIARY_FILE"
  echo "" >> "$DIARY_FILE"
fi

# Append entry
cat >> "$DIARY_FILE" << EOF

## $TIMESTAMP — $PROJECT_NAME

$SUMMARY

---
EOF

# Commit and push
cd "$DIARY_DIR"
git add -A
git commit -m "diary: $DATE $TIMESTAMP $PROJECT_NAME" 2>/dev/null || true
git push 2>/dev/null || true

exit 0
