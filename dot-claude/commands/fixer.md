---
description: Parse error, find root cause, propose fix. Fast and minimal.
---

# Fix Command

Invokes the **quick-fix** agent to debug errors from console logs, stack traces, or error messages.

## What This Command Does

1. **Parse error** - Extract file, line, error type, message
2. **Locate code** - Read files from stack trace
3. **Identify cause** - Find the bug
4. **Propose fix** - Concise solution with exact code change

## When to Use

Use `/fix` when you have:

- Stack traces
- Console errors
- Build failures
- Type errors
- Runtime exceptions

## Output Format

````markdown
## Error

[One-line summary]

## Cause

[Why it's happening - 1-2 sentences]

## Fix

File: `path/to/file.ts:123`

```diff
- broken code
+ fixed code
```
````

Notes (if needed)

- [Edge case or related issue]

```

## Example Usage

```

User: /fix
TypeError: Cannot read properties of undefined (reading 'map')
at UserList (src/components/UserList.tsx:15:23)

Agent (quick-fix):

## Error

Calling .map() on undefined users array

## Cause

`users` prop is undefined on initial render before data loads

## Fix

File: `src/components/UserList.tsx:15`

```diff
- {users.map(user => <UserCard key={user.id} {...user} />)}
+ {users?.map(user => <UserCard key={user.id} {...user} />)}
```

```

## Notes

- Uses haiku model (fast, cheap)
- Minimal output - no phases, risks, or testing strategy
- Research only - does not write code

## Related Agent

`~/.claude/agents/quick-fix.md`
```
