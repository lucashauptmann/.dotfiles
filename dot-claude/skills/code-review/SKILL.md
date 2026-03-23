# Code Review

Comprehensive security and quality review.

## Scope

Determine what to review based on arguments:

- **GitHub PR link provided** (e.g. `https://github.com/org/repo/pull/123`): Fetch the PR diff with `gh pr diff <url>`. Also read the PR description with `gh pr view <url>` to verify the code implements the proposed change.
- **No arguments**: Review uncommitted changes via `git diff --name-only HEAD`.

## Checklist

For each changed file, check for:

**Logic (when reviewing a PR):**

- Code implements the proposed change (PR description or Jira ticket)

**Security Issues (CRITICAL):**

- Hardcoded credentials, API keys, tokens
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing input validation
- Insecure dependencies
- Path traversal risks

**Code Quality (HIGH):**

- Functions > 50 lines
- Files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log statements
- TODO/FIXME comments
- Missing JSDoc for public APIs

**Best Practices (MEDIUM):**

- Mutation patterns (use immutable instead)
- Emoji usage in code/comments
- Missing tests for new code
- Accessibility issues (a11y)

## Report

Generate report with:

- Severity: CRITICAL, HIGH, MEDIUM, LOW
- File location and line numbers
- Issue description
- Suggested fix

Block commit if CRITICAL or HIGH issues found.

Never approve code with security vulnerabilities!
