---
description: Parse error, find root cause, propose fix. Fast and minimal.
---

# Fix

1. Parse error — extract file, line, error type, message
2. Locate code — read files from stack trace
3. Identify root cause
4. Propose fix as a diff

Output format: Error (one-line), Cause (1-2 sentences), Fix (file:line + diff).
Research only — do not write code.
