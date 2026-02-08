# Codebase Research Prompts

> **MANDATORY**: Use these exact prompts when researching the codebase in Phase 2.

## Launch 4 Parallel Explore Agents

### Agent 1: Architecture & Structure

```
"Analyze the high-level architecture of this project.

Search for:
- Entry points (main files, server startup, CLI entry, index files)
- Module/package boundaries (directories that represent distinct components)
- Data flow patterns (how data moves through the system)
- External service integrations (API clients, database connections, message queues)
- Database schemas or data models (ORM definitions, migration files, schema files)
- Configuration loading (env files, config modules, settings)

Return in this format:

## Entry Points
| File | Type | Purpose |
|------|------|---------|
| path/to/file | Server/CLI/Library/Worker | What it does |

## Component Boundaries
| Directory | Responsibility | Dependencies |
|-----------|---------------|--------------|
| src/component/ | What it owns | What it depends on |

## Data Flow
Describe the primary data flow through the system in 3-5 steps.

## External Integrations
| Service | Client Location | Purpose |
|---------|----------------|---------|
| Service name | path/to/client | Why it's used |

## Data Models
| Model/Entity | Location | Key Fields |
|-------------|----------|------------|
| ModelName | path/to/definition | field1, field2, field3 |
"
```

### Agent 2: Patterns & Conventions

```
"Identify coding patterns and conventions used in this project.

Search for:
- File naming conventions (kebab-case, camelCase, PascalCase)
- Directory organization style (feature-based, layer-based, domain-driven)
- Error handling patterns (try/catch, Result types, error middleware, custom error classes)
- Logging approach (logger library, log levels, structured logging)
- Configuration management (env vars, config files, feature flags)
- Authentication/authorization patterns (middleware, decorators, guards)
- Code reuse patterns (shared utilities, base classes, mixins, higher-order functions)
- Import/export conventions (barrel files, named exports, default exports)

Return in this format:

## Naming Conventions
| Element | Convention | Example |
|---------|-----------|---------|
| Files | convention | example-file.ts |
| Functions | convention | exampleFunction |
| Classes | convention | ExampleClass |
| Constants | convention | EXAMPLE_CONSTANT |

## Directory Organization
Style: [feature-based / layer-based / domain-driven / hybrid]
Description of the pattern.

## Error Handling
Pattern: [describe the primary error handling approach]
Location: [where error handling is centralized, if anywhere]
Example: [cite a specific file and line range]

## Logging
Library: [name or built-in]
Pattern: [structured/unstructured, log levels used]

## Configuration
Approach: [env vars / config files / both]
Location: [where config is loaded and validated]

## Notable Patterns
List 2-3 other significant patterns observed with file references.
"
```

### Agent 3: Domain & Business Logic

```
"Identify the core domain concepts and business logic in this project.

Search for:
- Domain entities (classes, types, interfaces that represent business concepts)
- Business rules (validation logic, state machines, workflow definitions)
- User-facing features (what end users can do with this system)
- API surface area (REST endpoints, GraphQL schema, CLI commands, exported functions)
- Key algorithms or processing pipelines (data transformations, calculations, workflows)
- Domain-specific terminology (terms used in code that have project-specific meaning)

Return in this format:

## Core Domain Entities
| Entity | Location | Description | Key Relationships |
|--------|----------|-------------|-------------------|
| EntityName | path/to/definition | What it represents | Related entities |

## Business Rules
| Rule | Location | Description |
|------|----------|-------------|
| Rule name | path/to/implementation | What it enforces |

## User-Facing Features
1. Feature name - brief description (entry point: path/to/file)
2. ...

## API Surface
| Endpoint/Command | Method | Handler | Description |
|-----------------|--------|---------|-------------|
| /api/resource | GET | path/to/handler | What it does |

## Domain Glossary
| Term | Meaning in This Project |
|------|------------------------|
| term | definition as used here |
"
```

### Agent 4: Build, Test & Deploy Pipeline

```
"Map the complete development lifecycle for this project.

Search for:
- Package/dependency files (package.json, pyproject.toml, go.mod, Cargo.toml, Gemfile)
- Build configuration (webpack, vite, esbuild, tsc, cargo build settings)
- Test configuration (jest.config, pytest.ini, test directories, fixtures)
- CI/CD configuration (.github/workflows, .gitlab-ci.yml, Jenkinsfile, Makefile, Justfile)
- Docker/container configuration (Dockerfile, docker-compose.yml)
- Deployment configuration (terraform, k8s manifests, serverless.yml, Procfile)
- Development tools (.editorconfig, .prettierrc, .eslintrc, pre-commit hooks)
- Scripts directory (scripts/, bin/, tools/)

Return in this format:

## Prerequisites
| Requirement | Version/Details | Install Command |
|------------|----------------|-----------------|
| Runtime | version | install command |

## Key Commands
| Action | Command | Source |
|--------|---------|--------|
| Install dependencies | command | package file |
| Run locally | command | script/config |
| Run tests | command | test config |
| Lint/format | command | config file |
| Build | command | build config |
| Deploy | command | deploy config |

## CI/CD Pipeline
| Stage | Trigger | Actions |
|-------|---------|---------|
| Stage name | on push/PR/tag | What it does |

## Development Tools
| Tool | Config File | Purpose |
|------|------------|---------|
| Tool name | .config-file | What it enforces |

## Scripts
| Script | Purpose |
|--------|---------|
| scripts/name.sh | What it does |
"
```

---

## Compiling Research Results

After all agents complete, compile results into a unified research document:

```markdown
## Research Summary

### Project Identity
- **Name**: [from package file or README]
- **Type**: [library / CLI / web app / API / monorepo / etc.]
- **Primary language**: [language]
- **Framework**: [if applicable]

### Architecture
[Summarize Agent 1 findings]

### Patterns & Conventions
[Summarize Agent 2 findings]

### Domain & Features
[Summarize Agent 3 findings]

### Development Pipeline
[Summarize Agent 4 findings]

### Technical Decisions Discovered
List any WHY rationale found in:
- Code comments explaining design choices
- README sections about architecture
- ADR (Architecture Decision Records) if they exist
- Git commit messages for significant changes
- CHANGELOG entries explaining breaking changes
```

---

## When Research Reveals Gaps

If agents cannot find certain information:

| Gap | Action |
|-----|--------|
| No README exists | Note in overview.md, generate from code analysis |
| No test configuration | Note in development.md, skip test documentation |
| No CI/CD pipeline | Note in development.md, skip CI documentation |
| No deployment config | Skip deployment section in development.md |
| No decision records | Infer decisions from code structure, note as inferred |
| Unclear domain | Use code identifiers as glossary terms, flag for review |

**Never fabricate information to fill gaps.** Document what exists and flag what's missing.
