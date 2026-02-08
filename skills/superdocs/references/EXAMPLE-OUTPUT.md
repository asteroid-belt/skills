# Example Output

> Reference this during Phase 5 (VERIFY) to understand what good superdocs output looks like.

## What Good Documentation Looks Like

### WHAT Coverage (Facts)

Good:
```markdown
## Components

### Auth Service
| Attribute | Value |
|-----------|-------|
| **Location** | `src/services/auth/` |
| **Responsibility** | JWT token issuance, validation, and refresh |
| **Dependencies** | `jsonwebtoken`, `bcrypt`, User model |
```

Bad:
```markdown
## Components

### Auth Service
The auth service handles authentication. It uses standard approaches.
```

**Why the good version works:** Specific file paths, library names, and concrete responsibilities. An AI agent or new developer can immediately locate and understand the component.

---

### HOW Coverage (Processes)

Good:
```markdown
## Authentication Flow

1. Client sends credentials to `POST /api/auth/login`
2. `src/routes/auth.ts:23` validates request body with Zod schema
3. `src/services/auth/login.ts:15` verifies password hash via bcrypt
4. On success, `src/services/auth/token.ts:8` issues JWT with 24h expiry
5. Token returned in response body (not cookies)
6. Subsequent requests include token in `Authorization: Bearer <token>` header
7. `src/middleware/auth.ts:12` validates token on protected routes
```

Bad:
```markdown
## Authentication Flow
Users log in with their credentials and receive a token for subsequent requests.
```

**Why the good version works:** Each step references actual files and line numbers. A developer can trace the flow through code. An AI agent can modify any step with confidence.

---

### WHY Coverage (Rationale via ADRs)

Good (individual ADR file `adr/0003-use-jwt-over-sessions.md`):
```markdown
# ADR-0003: Use JWT Over Sessions

**Status:** Accepted
**Date:** 2025-03-15

## Context

The API serves both a web frontend and a mobile app. Session-based auth
would require sticky sessions or a shared session store, adding
infrastructure complexity.

## Decision

Use stateless JWT tokens with 24-hour expiry and refresh token rotation.

## Consequences

### Benefits

- No session store needed - reduces infrastructure
- Works identically for web and mobile clients
- Horizontal scaling without session affinity

### Trade-offs

- Cannot instantly revoke tokens (must wait for expiry)
- Larger request payload than session cookies
- Must implement refresh token rotation for security

### Alternatives Considered

| Alternative | Why Not Chosen |
|-------------|---------------|
| Session + Redis | More infrastructure, but instant revocation |
| OAuth2 with external provider | Added dependency, but less custom code |

## Sources

| Source Type | Reference |
|-------------|-----------|
| Git commit | `a1b2c3d` — Add JWT auth middleware with refresh rotation |
| Code comment | `src/middleware/auth.ts:12` — "JWT chosen for stateless multi-client support" |
| Config file | `src/config/auth.ts` — Token expiry and rotation settings |

## Related

- [Architecture](../architecture.md) — Authentication Flow section
- [ADR-0001](0001-use-express-framework.md) — Framework choice affects middleware pattern
```

Bad:
```markdown
## Authentication
We use JWT for authentication because it's the industry standard.
```

**Why the good version works:** Each ADR is a self-contained file with traceable sources. The decision is linked to actual git commits, code comments, and config files. Future developers can verify the rationale and find related decisions.

---

## Coverage Matrix Example

A complete superdocs run should produce this kind of coverage:

```text
SUPERDOCS COMPLETE
===================

Project: acme-api
Type: SINGLE
Output: docs/
Docs state: FRESH

Files: 10 (5 docs + 1 ADR index + 4 ADRs)
Total lines: 1023

WHAT coverage: 4/6 documents
HOW coverage:  4/6 documents
WHY coverage:  3/6 documents

COVERAGE MATRIX
                    WHAT    HOW     WHY
overview.md         [x]     [ ]     [x]     Purpose, features, rationale
architecture.md     [x]     [x]     [x]     Components, flows, design decisions
getting-started.md  [x]     [x]     [ ]     Prerequisites, setup steps
development.md      [x]     [x]     [ ]     Structure, workflow, testing
adr/                [ ]     [ ]     [x]     4 ADRs (3 from git history, 1 inferred)
glossary.md         [x]     [ ]     [ ]     12 domain terms

Documents generated:  10
Documents updated:    0
Documents unchanged:  0
ADRs total:           4
  adr/0001-use-express-framework.md        [Accepted]
  adr/0002-feature-based-directory-layout.md [Accepted]
  adr/0003-use-jwt-over-sessions.md        [Accepted]
  adr/0004-sqlite-for-local-development.md [Accepted]

Cross-links: 18/18 verified
TODOs remaining: 2 (deployment config unclear, API rate limiting TBD)
```

---

## Anti-Patterns to Avoid

### 1. Vague Descriptions

| Avoid | Prefer |
|-------|--------|
| "The app uses a modern architecture" | "Feature-based directory structure with co-located tests" |
| "Standard error handling" | "Express error middleware in `src/middleware/error.ts` catches all unhandled errors and returns structured JSON responses" |
| "Well-tested codebase" | "142 unit tests (Jest), 23 integration tests (supertest), ~78% line coverage" |

### 2. Aspirational Documentation

| Avoid | Prefer |
|-------|--------|
| "We plan to add caching" | [Don't mention it - document what exists] |
| "The API should validate all inputs" | "Input validation via Zod schemas in `src/validators/`. 3 endpoints lack validation: `GET /users/:id`, `DELETE /posts/:id`, `PATCH /settings`" |

### 3. Generic Content

| Avoid | Prefer |
|-------|--------|
| "Follow standard Git workflow" | "Branch from `main`, prefix branches with `feat/`, `fix/`, or `chore/`. PRs require 1 approval. CI must pass." |
| "Install dependencies and run" | "Run `npm install` then `npm run dev`. Server starts on port 3000. Health check: `curl localhost:3000/health`" |

### 4. Missing Cross-Links

Every document should reference at least 2 others. If `architecture.md` mentions a domain term, link to `glossary.md`. If `getting-started.md` mentions project structure, link to `architecture.md`.

---

## Monorepo Coverage Matrix Example

A monorepo run generates per-package docs with a root index:

```text
SUPERDOCS COMPLETE
===================

Project: acme-platform
Type: MONOREPO (3 packages)
Output: docs/ + per-package docs/
Docs state: FRESH

Root index: docs/README.md (links to 3 packages)

Package: apps/web
  Files: 10 (5 docs + 1 ADR index + 4 ADRs)
  Lines: 892

Package: apps/api
  Files: 12 (5 docs + 1 ADR index + 6 ADRs)
  Lines: 1340

Package: packages/shared-ui
  Files: 8 (5 docs + 1 ADR index + 2 ADRs)
  Lines: 523

Total: 31 files, 2755 lines

Cross-links: 42/42 verified
TODOs remaining: 3
```

---

## UPDATE Mode Example

When re-running on a codebase with existing superdocs:

```text
SUPERDOCS COMPLETE
===================

Project: acme-api
Type: SINGLE
Output: docs/
Docs state: UPDATE
Staleness: was 23 commits behind, now current

Files: 10 (5 docs + 1 ADR index + 4 ADRs)
Total lines: 1089

Documents updated:    3 (architecture.md, development.md, getting-started.md)
Documents unchanged:  4 (overview.md, glossary.md, adr/0001, adr/0002)
Documents created:    1 (adr/0005-migrate-to-drizzle-orm.md)
ADRs superseded:      1 (adr/0003 -> adr/0005)
ADRs total:           5

Changes applied:
  architecture.md:
    - ADDED: New payments module (src/modules/payments/)
    - UPDATED: Data flow diagram with payment processing
  development.md:
    - UPDATED: Test commands (jest -> vitest migration)
  getting-started.md:
    - UPDATED: Node version 18 -> 20 in prerequisites
  adr/0005-migrate-to-drizzle-orm.md:
    - NEW: Decision to migrate from Prisma to Drizzle ORM
  adr/0003-use-prisma-orm.md:
    - SUPERSEDED by adr/0005

Cross-links: 20/20 verified
TODOs remaining: 1 (deployment config unclear)
```

---

## Verification Checklist

Use this checklist during Phase 5:

- [ ] Every file path mentioned in docs exists in the actual codebase
- [ ] Every command mentioned in docs is runnable (verified against package.json/Makefile/Justfile)
- [ ] Every component in architecture.md corresponds to an actual directory
- [ ] Every glossary term appears at least once in the codebase
- [ ] Every ADR has at least one traceable source (git commit, code comment, config file)
- [ ] adr/README.md index matches the actual ADR files in the directory
- [ ] All cross-links between documents are valid
- [ ] No placeholder text (`[brackets]`) remains
- [ ] No generic filler ("standard", "modern", "best practices") without specifics
- [ ] WHAT/HOW/WHY coverage matrix has no unexpected gaps
