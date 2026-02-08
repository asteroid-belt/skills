---
name: superdocs
description: Generates a docs/ directory of markdown files giving AI and humans deep context on WHAT a codebase is, HOW it works, and WHY decisions were made. Scans any codebase, produces structured documentation. Re-runnable — detects existing docs, monorepos, and git-based staleness. Runs automatically without user interaction.
license: MIT
allowed-tools: Read Write Edit Bash(ls:*) Bash(git:*) Bash(tree:*) Bash(wc:*) Bash(just:*) Bash(make:*) Glob Grep Task
metadata:
  generated-at: "2026-02-08"
  group: "enablement"
  category: "documentation"
  difficulty: "intermediate"
  step-count: "7"
---

# Superdocs: Deep Codebase Documentation Generator

Generate a `docs/` directory of markdown files that give AI agents and human contributors deep context on any codebase.

**Scope:** Superdocs works on **codebases** — repositories containing source code with build/test/deploy pipelines. It does not generate documentation for pure-docs projects, wikis, or non-code repositories.

**Re-runnable:** Safe to run multiple times. First run generates from scratch (migrating existing docs if found). Subsequent runs detect what changed in the codebase since the last docs update and refresh only stale content.

**References:** See [RESEARCH-PROMPTS.md](references/RESEARCH-PROMPTS.md) for codebase exploration prompts, [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md) for document templates, [EXAMPLE-OUTPUT.md](references/EXAMPLE-OUTPUT.md) for a sample output walkthrough.

## Philosophy

Documentation should answer three questions at every level:

| Question | What It Captures | Example |
|----------|-----------------|---------|
| **WHAT** | Facts, structures, components | "This is a REST API built with Express" |
| **HOW** | Processes, flows, mechanics | "Requests pass through auth middleware, then route handlers" |
| **WHY** | Rationale, trade-offs, history | "We chose SQLite over Postgres for single-binary deployment" |

Most documentation answers WHAT. Good documentation answers HOW. Great documentation answers WHY. **Superdocs targets all three.**

## Invocation

```bash
/superdocs                         # Uses cwd as project root
/superdocs @README.md @CLAUDE.md   # With context files as hints
```

Superdocs runs fully automatically — no user prompts or confirmations. It scans, classifies, researches, generates, and verifies in one pass.

### CI Usage

```bash
# From the project root
./scripts/generate-docs.sh

# Or with options
./scripts/generate-docs.sh --project-dir /path/to/project --output-dir docs
```

See [scripts/generate-docs.sh](scripts/generate-docs.sh) for CI integration details.

## Output Structure

### Single Codebase

```text
docs/
  overview.md          # WHAT: Project identity, purpose, scope
  architecture.md      # HOW + WHY: System design, component relationships
  getting-started.md   # HOW: Setup, prerequisites, first run
  development.md       # HOW: Contributing, testing, deploying
  adr/                 # WHY: Architecture Decision Records
    README.md          #   Index of all ADRs with status summary
    0001-[title].md    #   Individual ADR per significant decision
    0002-[title].md    #   ...numbered sequentially
  glossary.md          # WHAT: Domain terms, acronyms, project-specific jargon
```

### Monorepo

When the project contains multiple deployable apps or packages, superdocs generates per-package docs with a root index:

```text
docs/
  README.md            # Root index linking to each package's docs
apps/
  web/
    docs/              # Full superdocs set for the web app
      overview.md
      architecture.md
      getting-started.md
      development.md
      adr/
      glossary.md
  api/
    docs/              # Full superdocs set for the api
      ...
packages/
  shared-lib/
    docs/              # Full superdocs set for shared-lib
      ...
```

Each package gets its own complete superdocs set. The root `docs/README.md` serves as a navigation index.

---

## Core Workflow

```text
+-----------------------------------------------------------------------+
|                          SUPERDOCS WORKFLOW                           |
+-----------------------------------------------------------------------+
|                                                                       |
|  1. DISCOVER       ->  Validate codebase, detect monorepo,           |
|        |               classify docs state, compute staleness         |
|        v                                                              |
|  1b. MIGRATE       ->  (If non-superdocs docs/ exist) Absorb         |
|        |               existing content into superdocs structure      |
|        v                                                              |
|  2. RESEARCH       ->  Deep-dive with parallel agents: architecture,  |
|        |               patterns, decisions, domain concepts           |
|        v                                                              |
|  3. OUTLINE        ->  Plan doc structure, identify gaps, scope       |
|        |               updates using git diff data                    |
|        v                                                              |
|  4. GENERATE       ->  Write all markdown files with WHAT/HOW/WHY    |
|        |               coverage at every level                        |
|        v                                                              |
|  5. VERIFY         ->  Cross-check completeness, validate links,     |
|                        report coverage summary + change log           |
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

## Phase 1: DISCOVER - Classify the Codebase

### Step 1: Validate This Is a Codebase

Confirm the project contains source code. Check for at least one of:

- Package files: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, `build.gradle`
- Source directories: `src/`, `lib/`, `app/`, `cmd/`, `internal/`
- Build/test config: `Makefile`, `Justfile`, `Dockerfile`, CI config

**If none found:** EXIT with message — "Superdocs requires a codebase with source code. This directory does not appear to contain one."

### Step 2: Detect Monorepo vs Single Codebase

Check for monorepo indicators:

| Indicator | Check For |
|-----------|-----------|
| **Workspace config** | `workspaces` in package.json, `pnpm-workspace.yaml`, Cargo workspace in `Cargo.toml`, Go workspace in `go.work` |
| **Multi-package dirs** | `apps/`, `packages/`, `services/`, `libs/`, `modules/` containing multiple subdirs with their own package files |
| **Monorepo tools** | `lerna.json`, `nx.json`, `turbo.json`, `rush.json`, `pants.toml`, `BUILD` files (Bazel) |

**Classification:**

| Result | Criteria | Action |
|--------|----------|--------|
| **SINGLE** | One deployable codebase | Generate `docs/` at project root |
| **MONOREPO** | Multiple packages/apps detected | Generate root `docs/README.md` index + per-package `docs/` |

For monorepos, identify each package:

```text
MONOREPO PACKAGES DETECTED
----------------------------

| Package | Path | Type | Has Existing Docs? |
|---------|------|------|--------------------|
| [name] | apps/web/ | app | Yes/No |
| [name] | apps/api/ | app | Yes/No |
| [name] | packages/shared/ | library | Yes/No |
```

### Step 3: Scan for Existing ADRs Anywhere in the Codebase

Before classifying docs state, scan the entire repo for scattered ADRs that should be centralized into `docs/adr/`:

```bash
# Find existing ADR directories
find . -type d -name "adr" -o -name "adrs" -o -name "decisions" | grep -v node_modules | grep -v .git

# Find individual ADR files by naming convention
find . -type f \( -name "ADR-*.md" -o -name "adr-*.md" -o -name "[0-9][0-9][0-9][0-9]-*.md" \) | grep -v node_modules | grep -v docs/adr
```

| Location Found | Action |
|----------------|--------|
| `adr/` or `decisions/` at project root | Move contents into `docs/adr/`, renumber if needed |
| `doc/adr/` or `doc/decisions/` | Move contents into `docs/adr/`, renumber if needed |
| ADR files scattered in subdirectories | Copy into `docs/adr/`, preserve original, add source reference |
| Existing `docs/adr/` in superdocs format | Keep as-is (handled by UPDATE state) |

Record all found ADRs for use in Phase 1b (MIGRATE) or Phase 4 (GENERATE):

```text
EXISTING ADRs FOUND
---------------------

| # | File | Location | Status | Action |
|---|------|----------|--------|--------|
| 1 | 0001-use-postgres.md | adr/ (root) | Valid ADR | Centralize to docs/adr/ |
| 2 | ADR-auth-strategy.md | doc/decisions/ | Valid ADR | Centralize + renumber |
| 3 | 0003-api-versioning.md | docs/adr/ | Already centralized | Keep |

Total: [N] existing ADRs found, [M] need centralizing
```

### Step 4: Classify Existing Documentation State

For each docs target (project root for SINGLE, each package for MONOREPO):

| State | Detection | Action |
|-------|-----------|--------|
| **FRESH** | No `docs/` directory exists | Full generation from scratch |
| **MIGRATE** | `docs/` exists but is NOT superdocs format | Absorb existing content, then generate |
| **UPDATE** | `docs/` exists in superdocs format | Diff codebase changes, update stale content |

To detect superdocs format, check for the presence of at least 3 of: `overview.md`, `architecture.md`, `getting-started.md`, `development.md`, `adr/README.md`, `glossary.md`.

### Step 5: Compute Git-Based Staleness (UPDATE state only)

When existing superdocs are detected, determine exactly what changed since the last docs update:

```bash
# Find when docs/ was last modified
git log -1 --format="%H" -- docs/

# Count commits since last docs update
git rev-list --count <docs-last-sha>..HEAD

# List files changed since last docs update
git diff --name-only <docs-last-sha>..HEAD

# Summarize changes by directory
git diff --stat <docs-last-sha>..HEAD
```

Build a **staleness report:**

```text
STALENESS REPORT
-----------------

Docs last updated: [SHA] ([date], [N] commits ago)
Commits since:     [count]
Files changed:     [count]

Changes by area:
  src/api/         [N files changed] -> architecture.md, development.md may be stale
  src/models/      [N files changed] -> architecture.md, glossary.md may be stale
  package.json     [modified]        -> getting-started.md may be stale
  Dockerfile       [modified]        -> development.md may be stale
  [new directory]  [added]           -> architecture.md needs new component

Affected superdocs files:
  overview.md          [STALE / OK]
  architecture.md      [STALE / OK]
  getting-started.md   [STALE / OK]
  development.md       [STALE / OK]
  adr/                 [STALE / OK] — [N] new ADR candidates
  glossary.md          [STALE / OK]
```

### Step 6: Detect Technology Stack

Identify the primary language, framework, and tooling:

| Detection | Check For |
|-----------|-----------|
| **Language** | File extensions, package files |
| **Framework** | Framework-specific config (next.config.js, django settings, etc.) |
| **Build system** | Makefile, Justfile, Taskfile, build scripts |
| **Test framework** | jest.config, pytest.ini, go test conventions, etc. |
| **CI/CD** | .github/workflows, .gitlab-ci.yml, Jenkinsfile |
| **Infrastructure** | Dockerfile, docker-compose.yml, terraform/, k8s/ |

### Step 7: Read Existing Documentation

```text
DISCOVERY CHECKLIST
--------------------

1. Use project root directory (cwd or user-specified)
2. Read existing docs in priority order:
   - README.md (primary project description)
   - CLAUDE.md / AGENTS.md (agent context)
   - CONTRIBUTING.md (development workflow)
   - CHANGELOG.md / HISTORY.md (evolution)
   - docs/ directory (existing documentation)
   - .github/ (CI, issue templates, PR templates)
3. Record what already exists vs what needs generating
```

### Step 8: Build Project Tree and Estimate Scope

```bash
tree --gitignore -a -L 3
```

| Size | Criteria | Documentation Approach |
|------|----------|----------------------|
| **Small** | <20 files, <2K LOC | Concise docs, merge overview+architecture |
| **Medium** | 20-100 files, 2-20K LOC | Full doc set, standard depth |
| **Large** | >100 files, >20K LOC | Full doc set, deeper architecture, component breakdown |

### CHECKPOINT - Phase 1

```text
DISCOVERY COMPLETE
-------------------

Project: [name]
Type: [SINGLE / MONOREPO ([N] packages)]
Stack: [language/framework]
Size: [small/medium/large]
Docs state: [FRESH / MIGRATE / UPDATE]
Staleness: [N/A / [N] commits behind, [N] files changed]
Existing docs: [list what already exists]
Existing ADRs: [N] found ([M] need centralizing)
```

**CHECKPOINT: Run `/compact focus on: Phase 1 DISCOVER complete. Project=[name], Type=[type], Stack=[stack], Docs state=[state], [N] existing ADRs found. Phase 1b/2 goals next.`**

---

## Phase 1b: MIGRATE - Absorb Existing Documentation (MIGRATE state only)

> **Skip this phase if docs state is FRESH or UPDATE.**
> For FRESH/UPDATE: existing ADRs found in Step 3 are centralized during Phase 4 (GENERATE) instead.

When `docs/` exists but is not in superdocs format, absorb the existing content before generating.

### Step 1: Inventory Existing Docs

Read every file in `docs/` and catalog:

| File | Content Summary | Maps To Superdocs File |
|------|----------------|----------------------|
| `[existing-file.md]` | [Brief summary] | `[overview.md / architecture.md / adr/NNNN / etc. / NONE]` |

### Step 2: Extract Reusable Content

For each existing doc file, extract content that can be incorporated:

- **Facts** (file paths, commands, config values) -> feed into relevant superdocs file
- **Architecture descriptions** -> absorb into `architecture.md`
- **Setup instructions** -> absorb into `getting-started.md`
- **Decision rationale** -> convert into individual ADRs in `adr/`
- **Glossary terms** -> absorb into `glossary.md`

### Step 3: Centralize Existing ADRs

For each existing ADR found in Phase 1, Step 3:

1. **Read the ADR content** — preserve the full text
2. **Normalize to superdocs ADR format** — ensure it has Context, Decision, Consequences, Sources sections (add empty sections if missing, mark with `<!-- TODO: verify -->`)
3. **Renumber sequentially** — assign the next available `NNNN` number in `docs/adr/`
4. **Create slug from title** — lowercase, hyphen-separated (e.g., `0001-use-postgres-over-sqlite.md`)
5. **Write to `docs/adr/`** — the centralized location
6. **Add source reference** — note original file path in Sources table
7. **Remove original** — if fully absorbed; leave a redirect note if other docs reference the old path

```text
ADR CENTRALIZATION
--------------------

| Original | Centralized As | Action |
|----------|---------------|--------|
| adr/0001-use-postgres.md | docs/adr/0001-use-postgres.md | Moved, reformatted |
| doc/decisions/auth.md | docs/adr/0002-auth-strategy.md | Moved, renumbered, reformatted |
| src/README.md (decision section) | docs/adr/0003-event-sourcing.md | Extracted, new ADR created |
```

### Step 4: Restructure

1. Create the superdocs directory structure: `mkdir -p docs/adr/`
2. Remove old files that have been fully absorbed into the new structure
3. Remove empty ADR/decision directories that are now centralized
4. Preserve any files that don't map to superdocs (leave them in `docs/` untouched)

### CHECKPOINT - Phase 1b

```text
MIGRATION COMPLETE
-------------------

Files absorbed: [count]
Content mapped:
  [old-file.md] -> [superdocs-file.md]
  ...
ADRs centralized: [count]
  [original-path] -> docs/adr/[new-name].md
  ...
Files preserved (unmapped): [list any files left as-is]
Files removed: [list files fully absorbed and deleted]
Old ADR dirs removed: [list directories cleaned up]
```

**CHECKPOINT: Run `/compact focus on: Phase 1b MIGRATE complete. [N] files absorbed, [M] ADRs centralized into docs/adr/. Phase 2 RESEARCH goals next.`**

---

## Phase 2: RESEARCH - Deep Codebase Analysis

> **STOP. Read [RESEARCH-PROMPTS.md](references/RESEARCH-PROMPTS.md) NOW** for exact agent prompts.

### Scope Research Using Staleness Data

- **FRESH / MIGRATE**: Research the entire codebase.
- **UPDATE**: Focus research on areas identified as changed in the staleness report. Still scan unchanged areas briefly to verify docs are still accurate, but spend most effort on changed files/directories.

### Launch Parallel Research Agents

Launch 5 parallel Explore agents to gather comprehensive codebase context:

```text
LAUNCHING RESEARCH AGENTS
--------------------------

Agent 1: Architecture & Structure      [scanning...]
Agent 2: Patterns & Conventions        [scanning...]
Agent 3: Domain & Business Logic       [scanning...]
Agent 4: Build, Test & Deploy Pipeline [scanning...]
Agent 5: Decision Archaeology          [scanning...]

Estimated time: 2-5 minutes
```

For **MONOREPO**: run agents per-package, parallelizing across packages where possible.

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

Captures what the codebase actually does:

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

### Agent 5: Decision Archaeology

Mines project history and artifacts for architecture decisions:

- Git history: significant commits, merge commits, tag messages, large refactors
- Plan files: any planning documents, RFCs, design docs in the repo
- Code comments: `// WHY:`, `// DECISION:`, `// NOTE:`, rationale in docstrings
- Dependency choices: why specific libraries were chosen (README, commit messages)
- Configuration patterns: why certain tools/configs are used
- CHANGELOG / HISTORY entries explaining breaking changes
- **Existing ADRs already centralized** — read from `docs/adr/` (if MIGRATE ran) or from scattered locations found in Phase 1, Step 3. Do NOT duplicate decisions already captured in existing ADRs. Instead, supplement them with new decisions found in git history that aren't yet recorded.
- PR/MR descriptions referenced in merge commits

### Verify Research Results

After agents complete, compile and cross-check:

- [ ] Architecture findings are consistent across agents
- [ ] No contradictory claims about project structure
- [ ] Domain concepts align with actual code
- [ ] Build/test commands are accurate (verify by reading config files)
- [ ] Decision archaeology findings have supporting evidence (commits, code, docs)

### CHECKPOINT - Phase 2

```text
RESEARCH COMPLETE
------------------

Architecture style: [monolith/microservices/serverless/library/CLI/etc.]
Key components: [list top 5-8]
Domain concepts: [list core entities]
Build pipeline: [list key commands]
Decisions found: [count] from git history, [count] from code/docs, [count] inferred
Existing ADRs read: [count] (centralized in Phase 1b or found in Phase 1)
New ADR candidates: [list decision titles not already captured]
```

**CHECKPOINT: Run `/compact focus on: Phase 2 RESEARCH complete. [N] components, [M] domain concepts, [K] ADR candidates ([J] existing + [L] new). Phase 3 OUTLINE goals next.`**

---

## Phase 3: OUTLINE - Plan Documentation Structure

### Determine Which Documents to Generate

Based on codebase size and existing documentation:

| Document | Always Generate? | Skip When |
|----------|-----------------|-----------|
| `overview.md` | Yes | Never skip |
| `architecture.md` | Yes | Never skip |
| `getting-started.md` | Yes | Never skip |
| `development.md` | Yes | Never skip |
| `adr/` | Yes, if decisions found | No technical decisions discoverable |
| `glossary.md` | Yes, if domain terms found | Trivial codebase with no domain language |

### UPDATE Mode: Scope Changes Using Staleness Report

In UPDATE mode, cross-reference the staleness report (Phase 1, Step 4) with research findings to build a precise change plan:

```text
CHANGE PLAN
-------------

Stale documents: [list docs needing updates]
New documents: [list new docs to create, e.g., new ADRs]
Unchanged documents: [list docs that are still accurate]

Changes by file:
  architecture.md:
    - ADD: [new component from src/new-module/]
    - REMOVE: [deleted component]
    - UPDATE: [changed data flow]
  getting-started.md:
    - UPDATE: [new dependency version in package.json]
  adr/:
    - NEW: 0005-[title].md (from commit abc1234)
    - SUPERSEDE: 0002-[title].md -> 0005-[title].md
  glossary.md: OK (no domain changes)
  overview.md: OK (scope unchanged)
```

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

adr/README.md:
  - Index of all ADRs with status and summary
  - Link to each individual ADR file

adr/NNNN-[title].md (one per decision):
  - Status (Accepted / Superseded / Deprecated)
  - Context: situation, constraints, forces at play
  - Decision: what was chosen
  - Consequences: benefits, trade-offs, alternatives considered
  - Sources: git commits, plan files, code references that evidence the decision

glossary.md:
  - Alphabetical term list
  - Each entry: Term, Definition, Context/Usage
```

### Proceed Automatically

Generate all applicable documents without prompting. Do not ask for user confirmation.

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
6. **adr/** last - each ADR references relevant docs, captures cross-cutting rationale
   - **Centralize first**: if existing ADRs were found in Phase 1 Step 3 (and not already centralized in Phase 1b), move/copy them into `docs/adr/` now, normalizing to superdocs ADR format and renumbering sequentially
   - Write `adr/README.md` index covering both centralized and newly generated ADRs
   - Write new `adr/NNNN-title.md` files for decisions discovered by Agent 5 that aren't already captured
   - Number new ADRs after the highest existing ADR number

### Monorepo: Generation Order

For monorepos, generate in this order:

1. **Per-package docs** - generate a full superdocs set for each package (parallelize across packages)
2. **Root `docs/README.md`** - write last, linking to each package's docs with a brief description

### UPDATE Mode: Selective Generation

In UPDATE mode, follow the change plan from Phase 3:

1. **Rewrite only stale documents** — replace sections that changed, preserve accurate content
2. **Create new files** — any new ADRs or docs identified
3. **Mark superseded ADRs** — update status and link to replacement
4. **Fix dead references** — update file paths, commands, and cross-links
5. **Do NOT rewrite unchanged documents** — leave accurate docs untouched

### Per-Document Process

For each document:

1. Read the template from [DOC-TEMPLATES.md](references/DOC-TEMPLATES.md)
2. Fill in sections using research findings from Phase 2
3. Add cross-links to other documents in the set
4. Include actual paths, commands, and code snippets from the codebase
5. Flag any sections where information was uncertain with `<!-- TODO: verify -->`

### Output Location

Write all files to the output directory:

```bash
mkdir -p docs/adr/
```

Write each file using the Write tool.

### CHECKPOINT - Phase 4

After all documents are written:

```text
GENERATION COMPLETE
--------------------

Docs state: [FRESH / MIGRATE / UPDATE]

Files written:   [count]
Files updated:   [count]  (UPDATE mode)
Files unchanged: [count]  (UPDATE mode)

  docs/overview.md              [X lines]
  docs/architecture.md          [X lines]
  docs/getting-started.md       [X lines]
  docs/development.md           [X lines]
  docs/adr/README.md            [X lines]
  docs/adr/0001-[title].md      [X lines]
  ...
  docs/glossary.md              [X lines]

Total: [N] files ([M] ADRs), [L] total lines
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
adr/                [ ]     [ ]     [x]     [N] ADR files
glossary.md         [x]     [ ]     [ ]

Legend: [x] = covered, [ ] = not applicable for this doc
```

### Cross-Link Validation

Verify that documents reference each other where appropriate:

- [ ] overview.md links to architecture.md for deeper technical context
- [ ] overview.md links to getting-started.md for setup
- [ ] architecture.md links to glossary.md for domain terms
- [ ] architecture.md links to adr/README.md for design rationale
- [ ] getting-started.md links to development.md for next steps
- [ ] development.md links to architecture.md for structure context
- [ ] adr/README.md links to each individual ADR file
- [ ] Individual ADRs link back to relevant docs (architecture.md, development.md, etc.)

### Accuracy Spot-Check

For each document, verify at least 2 claims against the actual codebase:

- [ ] File paths mentioned actually exist
- [ ] Commands listed actually work (check package.json/Makefile/Justfile)
- [ ] Dependencies listed match actual package files
- [ ] Architecture description matches actual directory structure

### TODO Audit

Search all generated docs for `<!-- TODO: verify -->` markers:

- List all TODOs found
- Leave markers in place and list in final summary

### Final Summary

```text
SUPERDOCS COMPLETE
================

Project: [name]
Type: [SINGLE / MONOREPO ([N] packages)]
Output: docs/
Docs state: [FRESH / MIGRATE / UPDATE]
Staleness: [N/A / was [N] commits behind, now current]

Files: [N]
Total lines: [M]

WHAT coverage: [X/N] documents
HOW coverage:  [X/N] documents
WHY coverage:  [X/N] documents

Cross-links: [X/Y] verified
TODOs remaining: [N] (items needing human verification)

Documents generated:  [count]
Documents updated:    [count]  (UPDATE only)
Documents unchanged:  [count]  (UPDATE only)
ADRs total:           [count]

  docs/overview.md
  docs/architecture.md
  docs/getting-started.md
  docs/development.md
  docs/adr/README.md
  docs/adr/0001-[title].md
  docs/adr/...
  docs/glossary.md
```

---

## Quality Enforcement

### Red Flags — If You Catch Yourself Doing These, STOP

| Red Flag | What's Wrong | Fix |
|----------|-------------|-----|
| Writing "the project uses modern best practices" | Vague filler with no information content | State the specific practice and where it's implemented |
| Describing a component without a file path | Unverifiable claim | Find the actual path or flag with `<!-- TODO: verify -->` |
| Listing a command without checking it exists | May be wrong | Read `package.json`, `Makefile`, or `Justfile` to confirm |
| Generating an ADR without a source reference | Fabricated rationale | Every ADR needs at least one evidence source (commit, code, doc) |
| Skipping cross-links between documents | Docs become isolated silos | Every doc links to at least 2 others |
| Writing aspirational content ("we plan to...") | Documents future, not present | Document only what EXISTS in the codebase now |
| Rewriting an unchanged document in UPDATE mode | Wasted effort, risks introducing errors | Check the staleness report — only touch stale docs |

### Rationalizations to Reject

These are excuses that should never bypass the workflow:

| Rationalization | Why It's Wrong | What to Do Instead |
|----------------|---------------|-------------------|
| "I'll skip the codebase validation, it's obviously code" | Validation takes seconds and prevents running on wikis/docs repos | Always run Step 1 |
| "I don't need to check for existing ADRs" | Scattered ADRs get duplicated or lost | Always scan in Step 3 |
| "I'll generate all docs without reading research first" | Docs will contain generic filler instead of actual project data | Research MUST complete before generation |
| "The staleness check isn't needed, I'll just regenerate everything" | Overwrites accurate content, loses manual edits | In UPDATE mode, always compute staleness first |
| "I'll write the ADR rationale from what seems reasonable" | Fabricated rationale is worse than no rationale | Every ADR needs evidence; use `Inferred — [evidence]` for low-confidence decisions |
| "Cross-link validation is optional" | Broken links make docs untrustworthy | Always validate in Phase 5 |

### Fresh Verification Required

Do NOT rely on memory or assumptions. For every claim in generated docs:

1. **File paths** — verify with `ls` or Glob that the path exists
2. **Commands** — verify by reading the config file that defines them (package.json scripts, Makefile targets, etc.)
3. **Dependencies** — verify by reading the actual package file
4. **Architecture claims** — verify by reading actual source files

If you cannot verify a claim, mark it with `<!-- TODO: verify -->` and list it in the final summary.

---

## Tone and Style

| Aspect | Guideline |
|--------|-----------|
| **Voice** | Technical writer - precise, neutral, helpful |
| **Audience** | Assume reader is a competent developer unfamiliar with this specific codebase |
| **Length** | Concise but complete - every sentence should add information |
| **Formatting** | Use tables for structured data, code blocks for commands, headers for navigation |
| **Examples** | Use actual codebase code and commands, not hypothetical ones |
| **Jargon** | Define on first use or link to glossary.md |

---

## Key Principles

1. **WHAT + HOW + WHY** - Answer all three at every level of documentation
2. **Actual over aspirational** - Document what exists, not what's planned
3. **Self-contained files** - Each doc is useful on its own
4. **Cross-linked set** - Together they form a complete picture
5. **Machine-readable** - AI agents can parse and use the docs effectively
6. **Human-readable** - Developers can navigate and understand quickly
7. **Re-runnable** - Safe to run repeatedly; uses git history to detect staleness
8. **Codebase-scoped** - Documents source code, not arbitrary projects
