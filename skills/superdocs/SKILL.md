---
name: superdocs
description: Generates a docs/ directory of markdown files giving AI and humans deep context on WHAT a project is, HOW it works, and WHY decisions were made. Researches any codebase or project, produces structured documentation. Runnable interactively or headlessly from CI via shell script.
license: MIT
allowed-tools: Read Write Edit Bash(ls:*) Bash(git:*) Bash(tree:*) Bash(wc:*) Bash(just:*) Bash(make:*) Glob Grep Task
metadata:
  generated-at: "2026-02-08"
  group: "enablement"
  category: "documentation"
  difficulty: "intermediate"
  step-count: "5"
---

# Superdocs: Deep Project Documentation Generator

Generate a `docs/` directory of markdown files that give AI agents and human contributors deep context on any project.

**References:** See [RESEARCH-PROMPTS.md](references/RESEARCH-PROMPTS.md) for codebase exploration prompts, [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md) for document templates, [EXAMPLE-OUTPUT.md](references/EXAMPLE-OUTPUT.md) for a sample output walkthrough.

## Philosophy

Documentation should answer three questions at every level:

| Question | What It Captures | Example |
|----------|-----------------|---------|
| **WHAT** | Facts, structures, components | "This is a REST API built with Express" |
| **HOW** | Processes, flows, mechanics | "Requests pass through auth middleware, then route handlers" |
| **WHY** | Rationale, trade-offs, history | "We chose SQLite over Postgres for single-binary deployment" |

Most documentation answers WHAT. Good documentation answers HOW. Great documentation answers WHY. **Docgen targets all three.**

## Invocation

```bash
/superdocs                         # Interactive - prompts for project root
/superdocs @README.md @CLAUDE.md   # With context files as hints
```

### Headless / CI Usage

```bash
# From the project root
./scripts/generate-docs.sh

# Or with options
./scripts/generate-docs.sh --project-dir /path/to/project --output-dir docs --mode full
```

See [scripts/generate-docs.sh](scripts/generate-docs.sh) for CI integration details.

## Output Structure

Docgen produces the following files in the output directory (default: `docs/`):

```
docs/
  overview.md          # WHAT: Project identity, purpose, scope
  architecture.md      # HOW + WHY: System design, component relationships
  getting-started.md   # HOW: Setup, prerequisites, first run
  development.md       # HOW: Contributing, testing, deploying
  decisions.md         # WHY: Key technical decisions and trade-offs
  glossary.md          # WHAT: Domain terms, acronyms, project-specific jargon
```

Each file is self-contained and cross-linked. AI agents can read any single file for focused context, or read all files for full project understanding.

---

## Core Workflow

```text
+-----------------------------------------------------------------------+
|                          SUPERDOCS WORKFLOW                               |
+-----------------------------------------------------------------------+
|                                                                       |
|  1. DISCOVER       ->  Scan project structure, detect stack, read     |
|        |               existing docs                                  |
|        v                                                              |
|  2. RESEARCH       ->  Deep-dive with parallel agents: architecture,  |
|        |               patterns, decisions, domain concepts           |
|        v                                                              |
|  3. OUTLINE        ->  Plan doc structure, identify gaps, confirm     |
|        |               with user (interactive) or proceed (headless)  |
|        v                                                              |
|  4. GENERATE       ->  Write all markdown files with WHAT/HOW/WHY    |
|        |               coverage at every level                        |
|        v                                                              |
|  5. VERIFY         ->  Cross-check completeness, validate links,     |
|                        report coverage summary                        |
|                                                                       |
+-----------------------------------------------------------------------+
```

---

## Reference Index

**Read the relevant reference BEFORE starting each phase.**

| When | Reference | What You Get |
|------|-----------|--------------|
| **Phase 2: Research** | [RESEARCH-PROMPTS.md](references/RESEARCH-PROMPTS.md) | Exact prompts for parallel exploration agents |
| **Phase 4: Generate** | [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md) | Templates for each output document |
| **Phase 5: Verify** | [EXAMPLE-OUTPUT.md](references/EXAMPLE-OUTPUT.md) | Example of well-generated docs for reference |

---

## Phase 1: DISCOVER - Scan the Project

### Step 1: Identify Project Root and Existing Documentation

```text
DISCOVERY CHECKLIST
--------------------

1. Confirm project root directory (cwd or user-specified)
2. Read existing docs in priority order:
   - README.md (primary project description)
   - CLAUDE.md / AGENTS.md (agent context)
   - CONTRIBUTING.md (development workflow)
   - CHANGELOG.md / HISTORY.md (evolution)
   - docs/ directory (existing documentation)
   - .github/ (CI, issue templates, PR templates)
3. Record what already exists vs what needs generating
```

### Step 2: Detect Technology Stack

Identify the primary language, framework, and tooling:

| Detection | Check For |
|-----------|-----------|
| **Language** | File extensions, package files (package.json, pyproject.toml, go.mod, Cargo.toml, etc.) |
| **Framework** | Framework-specific config (next.config.js, django settings, etc.) |
| **Build system** | Makefile, Justfile, Taskfile, build scripts |
| **Test framework** | jest.config, pytest.ini, go test conventions, etc. |
| **CI/CD** | .github/workflows, .gitlab-ci.yml, Jenkinsfile |
| **Infrastructure** | Dockerfile, docker-compose.yml, terraform/, k8s/ |
| **Documentation** | Existing docs/, wiki references, ADRs |

### Step 3: Build Project Tree

Generate a `.gitignore`-aware tree snapshot:

```bash
tree --gitignore -a -L 3
```

If `--gitignore` is unavailable, use `tree -a -L 3 --prune` and manually exclude ignored paths.

Save the tree output for use in architecture documentation.

### Step 4: Estimate Project Scope

| Size | Criteria | Documentation Approach |
|------|----------|----------------------|
| **Small** | <20 files, <2K LOC | Concise docs, merge overview+architecture |
| **Medium** | 20-100 files, 2-20K LOC | Full doc set, standard depth |
| **Large** | >100 files, >20K LOC | Full doc set, deeper architecture, component breakdown |
| **Monorepo** | Multiple packages/services | Per-package overview + root architecture |

### CHECKPOINT - Phase 1

```text
DISCOVERY COMPLETE
-------------------

Project: [name]
Stack: [language/framework]
Size: [small/medium/large]
Existing docs: [list what already exists]
Docs to generate: [list what's missing]
```

---

## Phase 2: RESEARCH - Deep Codebase Analysis

> **STOP. Read [RESEARCH-PROMPTS.md](references/RESEARCH-PROMPTS.md) NOW** for exact agent prompts.

### Launch Parallel Research Agents

Launch 4 parallel Explore agents to gather comprehensive project context:

```text
LAUNCHING RESEARCH AGENTS
--------------------------

Agent 1: Architecture & Structure      [scanning...]
Agent 2: Patterns & Conventions        [scanning...]
Agent 3: Domain & Business Logic       [scanning...]
Agent 4: Build, Test & Deploy Pipeline [scanning...]

Estimated time: 2-5 minutes
```

### Agent 1: Architecture & Structure

Discovers the high-level system design:
- Entry points (main files, server startup, CLI entry)
- Module/package boundaries
- Data flow (request lifecycle, event flow, pipeline stages)
- External dependencies and integrations
- Database schemas and data models

### Agent 2: Patterns & Conventions

Identifies how code is written:
- Naming conventions (files, functions, variables)
- Error handling patterns
- Logging approach
- Configuration management
- Code organization style (feature-based, layer-based, etc.)

### Agent 3: Domain & Business Logic

Captures what the project actually does:
- Core domain concepts and entities
- Business rules and validation logic
- User-facing features and capabilities
- API surface area (endpoints, commands, exports)
- Key algorithms or processing pipelines

### Agent 4: Build, Test & Deploy Pipeline

Maps the development lifecycle:
- How to install dependencies
- How to run the project locally
- How to run tests (unit, integration, e2e)
- How to build for production
- How to deploy (if applicable)
- CI/CD pipeline stages

### Verify Research Results

After agents complete, compile and cross-check:

- [ ] Architecture findings are consistent across agents
- [ ] No contradictory claims about project structure
- [ ] Domain concepts align with actual code
- [ ] Build/test commands are accurate (verify by reading config files)

### CHECKPOINT - Phase 2

```text
RESEARCH COMPLETE
------------------

Architecture style: [monolith/microservices/serverless/library/CLI/etc.]
Key components: [list top 5-8]
Domain concepts: [list core entities]
Build pipeline: [list key commands]
Notable decisions found: [list any decision records, comments, or rationale]
```

---

## Phase 3: OUTLINE - Plan Documentation Structure

### Determine Which Documents to Generate

Based on project size and existing documentation:

| Document | Always Generate? | Skip When |
|----------|-----------------|-----------|
| `overview.md` | Yes | Never skip |
| `architecture.md` | Yes | Never skip |
| `getting-started.md` | Yes | Never skip |
| `development.md` | Yes, for codebases | Project is not a codebase (e.g., pure docs project) |
| `decisions.md` | Yes, if decisions found | No technical decisions discoverable |
| `glossary.md` | Yes, if domain terms found | Trivial project with no domain language |

### Outline Each Document

For each document, plan the sections based on research findings:

```text
DOCUMENT OUTLINE
-----------------

overview.md:
  - Project name and one-line description
  - Problem statement (WHY this exists)
  - Key features / capabilities (WHAT it does)
  - Target audience
  - Project status and maturity

architecture.md:
  - System diagram (text-based)
  - Component breakdown
  - Data flow
  - Key interfaces and boundaries
  - Design decisions (WHY these components)

getting-started.md:
  - Prerequisites
  - Installation steps
  - Configuration
  - First run / hello world
  - Common issues

development.md:
  - Repository structure
  - Development workflow
  - Testing strategy
  - Code style and conventions
  - CI/CD pipeline

decisions.md:
  - Decision log (one entry per significant choice)
  - Each entry: Context, Decision, Consequences, Status

glossary.md:
  - Alphabetical term list
  - Each entry: Term, Definition, Context/Usage
```

### Interactive Mode: Confirm with User

In interactive mode, present the outline and ask:

```text
DOCUMENTATION PLAN
-------------------

I'll generate the following docs:
  1. overview.md      - Project identity and purpose
  2. architecture.md  - System design and components
  3. getting-started.md - Setup and first run
  4. development.md   - Contributing and testing
  5. decisions.md     - Technical decision log
  6. glossary.md      - Domain terminology

Output directory: docs/

Proceed with this plan? (y/n)
Any documents to skip or add?
```

### Headless Mode: Proceed Automatically

In headless mode (CI), generate all applicable documents without prompting.

---

## Phase 4: GENERATE - Write Documentation

> **STOP. Read [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md) NOW** for document templates.

### Writing Principles

1. **Facts over opinions** - State what IS, not what SHOULD BE
2. **Specific over general** - Use actual file paths, command names, config values
3. **WHY alongside WHAT** - Every structural choice deserves rationale
4. **Cross-link liberally** - Reference other docs in the set
5. **Code examples from the actual codebase** - Not hypothetical snippets
6. **Keep it current-state** - Document what exists now, not aspirations
7. **Concise but complete** - No fluff, no gaps

### Writing Order

Generate documents in this order (each builds on the previous):

1. **glossary.md** first - establishes shared vocabulary
2. **overview.md** - uses glossary terms, sets context
3. **architecture.md** - references overview for scope, links to glossary
4. **getting-started.md** - references architecture for understanding
5. **development.md** - references getting-started for setup, architecture for structure
6. **decisions.md** last - references everything, captures cross-cutting rationale

### Per-Document Process

For each document:

1. Read the template from [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md)
2. Fill in sections using research findings from Phase 2
3. Add cross-links to other documents in the set
4. Include actual paths, commands, and code snippets from the project
5. Flag any sections where information was uncertain with `<!-- TODO: verify -->`

### Output Location

Write all files to the output directory:

```bash
mkdir -p docs/
```

Write each file using the Write tool.

### CHECKPOINT - Phase 4

After all documents are written:

```text
GENERATION COMPLETE
--------------------

Files written:
  docs/overview.md          [X lines]
  docs/architecture.md      [X lines]
  docs/getting-started.md   [X lines]
  docs/development.md       [X lines]
  docs/decisions.md         [X lines]
  docs/glossary.md          [X lines]

Total: [N] files, [M] total lines
```

---

## Phase 5: VERIFY - Validate Documentation

### Completeness Check

Verify WHAT/HOW/WHY coverage across all documents:

```text
COVERAGE MATRIX
----------------

                    WHAT    HOW     WHY
overview.md         [x]     [ ]     [x]
architecture.md     [x]     [x]     [x]
getting-started.md  [x]     [x]     [ ]
development.md      [x]     [x]     [ ]
decisions.md        [ ]     [ ]     [x]
glossary.md         [x]     [ ]     [ ]

Legend: [x] = covered, [ ] = not applicable for this doc
```

### Cross-Link Validation

Verify that documents reference each other where appropriate:

- [ ] overview.md links to architecture.md for deeper technical context
- [ ] overview.md links to getting-started.md for setup
- [ ] architecture.md links to glossary.md for domain terms
- [ ] architecture.md links to decisions.md for design rationale
- [ ] getting-started.md links to development.md for next steps
- [ ] development.md links to architecture.md for structure context

### Accuracy Spot-Check

For each document, verify at least 2 claims against the actual codebase:

- [ ] File paths mentioned actually exist
- [ ] Commands listed actually work (check package.json/Makefile/Justfile)
- [ ] Dependencies listed match actual package files
- [ ] Architecture description matches actual directory structure

### TODO Audit

Search all generated docs for `<!-- TODO: verify -->` markers:

- List all TODOs found
- In interactive mode: ask user to clarify
- In headless mode: leave markers in place and list in summary

### Final Summary

```text
SUPERDOCS COMPLETE
================

Project: [name]
Output: docs/
Files: [N]
Total lines: [M]

WHAT coverage: [X/N] documents
HOW coverage:  [X/N] documents
WHY coverage:  [X/N] documents

Cross-links: [X/Y] verified
TODOs remaining: [N] (items needing human verification)

Documents generated:
  docs/overview.md
  docs/architecture.md
  docs/getting-started.md
  docs/development.md
  docs/decisions.md
  docs/glossary.md
```

---

## Headless Mode (CI / Automation)

When invoked via `scripts/generate-docs.sh`, superdocsruns without user interaction:

1. **No confirmation prompts** - generates all applicable documents
2. **Stdout progress** - prints phase progress to stdout for CI logs
3. **Exit codes** - 0 on success, non-zero on failure
4. **TODO markers** - places `<!-- TODO: verify -->` instead of asking
5. **Idempotent** - safe to run repeatedly; overwrites existing docs/

See [scripts/generate-docs.sh](scripts/generate-docs.sh) for implementation.

---

## Incremental Updates

When `docs/` already exists, superdocscan update rather than regenerate:

1. **Read existing docs** to understand current state
2. **Diff against codebase** to find what changed
3. **Update only stale sections** rather than rewriting everything
4. **Preserve manual edits** outside of generated sections

In incremental mode, wrap generated content with markers:

```markdown
<!-- superdocs:start:section-name -->
Generated content here...
<!-- superdocs:end:section-name -->
```

Content outside markers is preserved during updates.

---

## Tone and Style

| Aspect | Guideline |
|--------|-----------|
| **Voice** | Technical writer - precise, neutral, helpful |
| **Audience** | Assume reader is a competent developer unfamiliar with this specific project |
| **Length** | Concise but complete - every sentence should add information |
| **Formatting** | Use tables for structured data, code blocks for commands, headers for navigation |
| **Examples** | Use actual project code and commands, not hypothetical ones |
| **Jargon** | Define on first use or link to glossary.md |

---

## Key Principles

1. **WHAT + HOW + WHY** - Answer all three at every level of documentation
2. **Actual over aspirational** - Document what exists, not what's planned
3. **Self-contained files** - Each doc is useful on its own
4. **Cross-linked set** - Together they form a complete picture
5. **Machine-readable** - AI agents can parse and use the docs effectively
6. **Human-readable** - Developers can navigate and understand quickly
7. **CI-friendly** - Automatable via shell script for continuous freshness
