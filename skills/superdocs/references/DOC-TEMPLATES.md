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
- [Decisions](decisions.md) - Why things are the way they are
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

1. **[Decision]** - [Brief rationale]. See [decisions.md](decisions.md) for full context.

## Related Documentation

- [Overview](overview.md) - Project purpose and scope
- [Glossary](glossary.md) - Domain terminology used here
- [Decisions](decisions.md) - Full decision records
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

## 5. decisions.md

```markdown
# Technical Decisions

> Key technical decisions made in [Project Name] and their rationale.

This document records significant technical choices. Each entry follows the
format: **Context** (situation at the time), **Decision** (what was chosen),
**Consequences** (trade-offs accepted).

---

## [Decision Title]

**Date:** [When this was decided, or "Unknown" if inferred]
**Status:** [Active / Superseded / Deprecated]

### Context

[What was the situation? What problem needed solving? What constraints existed?]

### Decision

[What was chosen? Be specific about the technology, pattern, or approach.]

### Consequences

**Benefits:**
- [Positive outcome 1]
- [Positive outcome 2]

**Trade-offs:**
- [Negative consequence or limitation 1]
- [Negative consequence or limitation 2]

**Alternatives Considered:**
- [Alternative 1] - [Why it wasn't chosen]
- [Alternative 2] - [Why it wasn't chosen]

---

[Repeat for each decision discovered during research.
Aim for 3-8 decisions for a medium project.]

## Inferred Decisions

> These decisions were inferred from the codebase structure rather than
> explicit documentation. They may need verification.

| Decision | Evidence | Confidence |
|----------|----------|------------|
| [Inferred decision] | [What in the code suggests this] | [High/Medium/Low] |
```

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

## Template Usage Notes

1. **Delete inapplicable sections** - If the project has no CI/CD, remove that section from development.md entirely rather than writing "N/A"
2. **Add project-specific sections** - Templates are a starting point; add sections that capture important project-specific context
3. **Preserve cross-links** - Every document should link to at least 2 other documents in the set
4. **Use actual values** - Replace every `[placeholder]` with real data from the codebase
5. **Flag uncertainty** - Use `<!-- TODO: verify -->` for any claim you're not confident about
