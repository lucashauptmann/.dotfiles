## Critical Rules

- Be extremely concise. Sacrifice grammar for concision.
- No emojis in code, comments, or documentation
- Immutability always — never mutate objects or arrays

### Plans

- Multi-phase. Each phase = one PR ideally.
- End with unresolved questions, if any.

### Execution

- When executing multi-phase plans, write PR title + concise description (1-2 paragraphs) per phase.
- Many small files over few large files. High cohesion, low coupling. Organize by feature/domain.
- TDD: write tests first. Unit for utilities, integration for APIs, E2E for critical flows.

### Documentation

- Write for the reader. Include only what's relevant.
- Write less — only what you can commit to maintaining.
- Use headings and code formatting. Avoid walls of text.

## NEVER

- Publish secrets (passwords, API keys, tokens) to git/npm/docker
- Commit `.env` files — verify `.gitignore` includes them

## New Project Setup

Required files: `.env`, `.env.example`, `.gitignore`, `CLAUDE.md`

```
project/
├── src/
├── tests/
├── docs/
├── .claude/
│   └── skills/
└── scripts/
```
