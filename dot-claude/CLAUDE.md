## Critical Rules

- In all interactions and commit messages, be extremely concise and sacrifice grammar and for the sake of concision.

### 1. Plans

At the end of each plan, give me a list of unresolved questions to answer, if any. Make the extremely concise. Sacrifice grammar and for the sake of concision.

Make the plan multi-phase. Ideally, each phase should correspond to a new pull request.

### 2. Execution

When executing a multi-phase plan, if each phase correspond to a new pull request, write a title and a concise description (one or two paragraphs) for the PR. If you are instructed to combine two phases, then the description should have all the necessary information about both phases.

#### 2.1. Code Organization

- Many small files over few large files
- High cohesion, low coupling
- Organize by feature/domain, not by type

#### 2.2 Code Style

- No emojis in code, comments, or documentation
- Immutability always - never mutate objects or arrays
- No console.log in production code
- Proper error handling with try/catch
- Input validation with Zod or similar

#### 2.3 Testing

- TDD: Write tests first
- 80% minimum coverage
- Unit tests for utilities
- Integration tests for APIs
- E2E tests for critical flows

#### 2.4 Security

- No hardcoded secrets
- Environment variables for sensitive data
- Validate all user inputs
- Parameterized queries only
- CSRF protection enabled
