# Document Templates

> **MANDATORY**: Use these templates when generating documentation in Phase 4.

Each template provides the structure. Fill in content from Phase 2 research findings. Replace all `[bracketed placeholders]` with actual project data.

---

## 1. overview.md

```markdown
# [Project Name]

> [One-line description of what this project does]

## What Is This?

[2-3 paragraphs explaining:]
- [What problem this solves (WHY it exists)]
- [What it does at a high level (WHAT it is)]
- [Who it's for (target audience)]

## Key Features

| Feature | Description |
|---------|-------------|
| [Feature 1] | [Brief description] |
| [Feature 2] | [Brief description] |
| [Feature 3] | [Brief description] |

## Project Status

| Attribute | Value |
|-----------|-------|
| **Stage** | [Production / Beta / Alpha / Prototype / Archived] |
| **License** | [License type] |
| **Primary Language** | [Language] |
| **Framework** | [Framework, if applicable] |

## Quick Links

- [Getting Started](getting-started.md) - Set up and run the project
- [Architecture](architecture.md) - How the system is designed
- [Development](development.md) - Contributing and testing
- [Decisions](adr/README.md) - Architecture Decision Records
- [Glossary](glossary.md) - Project terminology
```

---

## 2. architecture.md

```markdown
# Architecture

> How [Project Name] is structured and why.

## System Overview

[Text-based diagram showing major components and their relationships.
Use ASCII art, Mermaid, or structured text.]

```text
[Component diagram here]
```

## Components

### [Component 1 Name]

| Attribute | Value |
|-----------|-------|
| **Location** | `[path/to/component/]` |
| **Responsibility** | [What it does] |
| **Dependencies** | [What it depends on] |
| **Depends On It** | [What depends on it] |

[1-2 paragraphs explaining HOW it works and WHY it's designed this way.]

### [Component 2 Name]

[Same structure as above]

## Data Flow

[Describe the primary data flow through the system. Use numbered steps.]

1. [Step 1: Entry point - what triggers the flow]
2. [Step 2: Processing - what happens to the data]
3. [Step 3: Storage/Output - where the data ends up]

## Key Interfaces

| Interface | Location | Purpose |
|-----------|----------|---------|
| [Interface name] | `[path/to/file]` | [What it defines] |

## External Dependencies

| Dependency | Purpose | Why This Choice |
|------------|---------|-----------------|
| [Library/Service] | [What it does for us] | [Why we chose it over alternatives] |

## Design Decisions

Key architectural choices and their rationale:

1. **[Decision]** - [Brief rationale]. See [ADR-NNNN](adr/NNNN-title.md) for full context.

## Related Documentation

- [Overview](overview.md) - Project purpose and scope
- [Glossary](glossary.md) - Domain terminology used here
- [Decisions](adr/README.md) - Architecture Decision Records
```

---

## 3. getting-started.md

```markdown
# Getting Started

> How to set up and run [Project Name] locally.

## Prerequisites

| Requirement | Version | Install |
|------------|---------|---------|
| [Runtime] | [>= X.Y] | [Install command or link] |
| [Package manager] | [>= X.Y] | [Install command or link] |
| [Other tools] | [version] | [Install command or link] |

## Installation

```bash
# Clone the repository
git clone [repo-url]
cd [project-name]

# Install dependencies
[install command]
```

## Configuration

[List required environment variables and configuration:]

| Variable | Required | Description | Default |
|----------|----------|-------------|---------|
| [VAR_NAME] | Yes/No | [What it does] | [default or none] |

```bash
# Copy example config
cp .env.example .env

# Edit with your values
[editor] .env
```

## Running Locally

```bash
# Start the project
[run command]
```

[Brief description of what you should see when it's working.]

## Verifying It Works

```bash
# Run the test suite
[test command]

# Or try a quick smoke test
[smoke test command, e.g., curl localhost:3000/health]
```

## Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| [Issue 1] | [Why it happens] | [How to fix it] |
| [Issue 2] | [Why it happens] | [How to fix it] |

## Next Steps

- [Development](development.md) - Learn how to contribute
- [Architecture](architecture.md) - Understand the system design
```

---

## 4. development.md

```markdown
# Development Guide

> How to contribute to [Project Name].

## Repository Structure

```text
[Trimmed tree output showing top 2-3 levels]
```

| Directory | Purpose |
|-----------|---------|
| `[dir/]` | [What lives here] |
| `[dir/]` | [What lives here] |

## Development Workflow

### Making Changes

1. [Branch naming convention, if any]
2. [Development process]
3. [How to submit changes]

### Code Style

| Aspect | Convention | Enforced By |
|--------|-----------|-------------|
| [Formatting] | [Style] | [Tool/config] |
| [Linting] | [Rules] | [Tool/config] |
| [Naming] | [Convention] | [Manual/tool] |

```bash
# Format code
[format command]

# Lint code
[lint command]
```

## Testing

### Test Structure

| Type | Location | Command |
|------|----------|---------|
| Unit | `[test/dir/]` | `[command]` |
| Integration | `[test/dir/]` | `[command]` |
| E2E | `[test/dir/]` | `[command]` |

```bash
# Run all tests
[test command]

# Run specific test file
[specific test command]

# Run with coverage
[coverage command]
```

## Building

```bash
# Build for production
[build command]

# Build output location
[where build artifacts go]
```

## CI/CD

[Describe the CI/CD pipeline:]

| Stage | Trigger | What It Does |
|-------|---------|-------------|
| [Stage] | [When it runs] | [What happens] |

## Deployment

[If applicable, describe deployment process:]

```bash
# Deploy command
[deploy command]
```

## Related Documentation

- [Getting Started](getting-started.md) - Initial setup
- [Architecture](architecture.md) - System design context
```

---

## 5. adr/ — Architecture Decision Records

Each significant technical decision gets its own numbered file in `docs/adr/`.
Generate two types of files: an index (`README.md`) and individual ADRs.

### 5a. adr/README.md (Index)

```markdown
# Architecture Decision Records

> Significant technical decisions made in [Project Name], recorded as individual ADRs.

ADRs capture the **context**, **decision**, and **consequences** of choices that
shape the project's architecture. They are mined from git history, plan files,
code comments, and project structure.

## ADR Index

| # | Title | Status | Date |
|---|-------|--------|------|
| [0001](0001-[slug].md) | [Decision title] | Accepted | [YYYY-MM-DD] |
| [0002](0002-[slug].md) | [Decision title] | Accepted | [YYYY-MM-DD] |

## Status Definitions

| Status | Meaning |
|--------|---------|
| **Proposed** | Under discussion, not yet adopted |
| **Accepted** | Active and in effect |
| **Superseded** | Replaced by a newer ADR (link to replacement) |
| **Deprecated** | No longer relevant |

## Related Documentation

- [Architecture](../architecture.md) - System design context
- [Development](../development.md) - Contributing workflow
- [Overview](../overview.md) - Project purpose and scope
```

### 5b. adr/NNNN-[slug].md (Individual ADR Template)

```markdown
# ADR-NNNN: [Decision Title]

**Status:** [Proposed | Accepted | Superseded | Deprecated]
**Date:** [YYYY-MM-DD — when decided, or best estimate from git history]
**Superseded by:** [ADR-NNNN, if applicable]

## Context

[What was the situation? What problem needed solving? What constraints existed?
What forces were at play (technical, business, team, timeline)?]

## Decision

[What was chosen? Be specific about the technology, pattern, or approach.]

## Consequences

### Benefits

- [Positive outcome 1]
- [Positive outcome 2]

### Trade-offs

- [Negative consequence or limitation 1]
- [Negative consequence or limitation 2]

### Alternatives Considered

| Alternative | Why Not Chosen |
|-------------|---------------|
| [Alternative 1] | [Reason] |
| [Alternative 2] | [Reason] |

## Sources

> Evidence used to reconstruct this decision.

| Source Type | Reference |
|-------------|-----------|
| Git commit | `[short SHA]` — [commit message summary] |
| Plan file | `[path/to/plan]` — [relevant section] |
| Code comment | `[path/to/file:line]` — [comment text] |
| Config file | `[path/to/config]` — [what it reveals] |
| CHANGELOG | `[entry date]` — [relevant entry] |

## Related

- [Architecture](../architecture.md) — [relevant section]
- [ADR-NNNN](NNNN-[slug].md) — [related decision]
```

### ADR Generation Guidelines

1. **Number sequentially** starting from `0001`
2. **Slug format**: lowercase, hyphen-separated (e.g., `0001-use-sqlite-over-postgres.md`)
3. **Mine git history** for decisions: `git log --oneline --all`, look for significant merges, refactors, dependency additions/removals, and config changes
4. **Mine plan files** for decisions: search for RFC docs, design docs, plan files, `ARCHITECTURE.md`
5. **Mine code comments** for rationale: grep for `WHY`, `DECISION`, `NOTE`, `HACK`, `TRADEOFF`
6. **Infer from structure**: if no explicit source exists, note confidence level in the Sources table as `Inferred — [evidence]`
7. **Aim for 3-8 ADRs** for a medium project, more for large/complex projects
8. **Each ADR must have at least one source** — never fabricate rationale without evidence

---

## 6. glossary.md

```markdown
# Glossary

> Project-specific terminology used in [Project Name].

Terms are defined as they are used in this project. General programming terms
are omitted unless they have a project-specific meaning.

| Term | Definition | Where Used |
|------|-----------|------------|
| [Term] | [Definition in this project's context] | [Files or areas where this term appears] |
| [Term] | [Definition in this project's context] | [Files or areas where this term appears] |

## Acronyms

| Acronym | Expansion | Meaning |
|---------|-----------|---------|
| [ABC] | [Alpha Beta Charlie] | [What it means in this project] |
```

---

## 7. Monorepo Root docs/README.md

> **Only generate this when the project is classified as MONOREPO.**

````markdown
# [Project Name] Documentation

> Documentation index for the [Project Name] monorepo.

## Packages

| Package | Path | Type | Description |
|---------|------|------|-------------|
| [package-name] | [`apps/web/docs/`](../apps/web/docs/overview.md) | App | [Brief description] |
| [package-name] | [`apps/api/docs/`](../apps/api/docs/overview.md) | App | [Brief description] |
| [package-name] | [`packages/shared/docs/`](../packages/shared/docs/overview.md) | Library | [Brief description] |

## Quick Links

Each package has its own full documentation set:

- **overview.md** — What the package is and why it exists
- **architecture.md** — How the package is structured and key design decisions
- **getting-started.md** — Setup and first run
- **development.md** — Contributing, testing, deploying
- **adr/** — Architecture Decision Records
- **glossary.md** — Domain terminology

## Monorepo Structure

```text
[Trimmed tree showing top-level layout]
```

| Directory | Purpose |
|-----------|---------|
| `apps/` | Deployable applications |
| `packages/` | Shared libraries and utilities |
| `docs/` | This index (you are here) |

## Cross-Package Concerns

[Document any cross-cutting concerns that span multiple packages:
shared configuration, monorepo tooling, workspace dependencies, shared CI/CD]
````

---

## Template Usage Notes

1. **Delete inapplicable sections** - If the project has no CI/CD, remove that section from development.md entirely rather than writing "N/A"
2. **Add project-specific sections** - Templates are a starting point; add sections that capture important project-specific context
3. **Preserve cross-links** - Every document should link to at least 2 other documents in the set
4. **Use actual values** - Replace every `[placeholder]` with real data from the codebase
5. **Flag uncertainty** - Use `<!-- TODO: verify -->` for any claim you're not confident about
