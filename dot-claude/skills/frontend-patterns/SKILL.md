---
name: frontend-patterns
description: Frontend development patterns for React, Next.js, state management, performance optimization, and UI best practices.
---

# Frontend Development Patterns

Modern frontend patterns for React, Next.js, and performant user interfaces.

## Component Patterns

### Composition

```typescript
interface CardProps {
  children: React.ReactNode
  variant?: 'default' | 'outlined'
}

function CardRoot({ children, variant = 'default' }: CardProps) {
  return <div className={`card card-${variant}`}>{children}</div>
}

function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header">{children}</div>
}

function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="card-body">{children}</div>
}

export const Card = Object.assign(CardRoot, {
  Header: CardHeader,
  Body: CardBody,
})

// Usage
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
</Card>
```

Remember: Modern frontend patterns enable maintainable, performant user interfaces. Choose patterns that fit your project complexity.
