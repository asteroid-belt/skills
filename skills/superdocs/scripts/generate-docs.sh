#!/usr/bin/env bash
set -euo pipefail

# Script: generate-docs.sh
# Purpose: Generate project documentation via superdocs skill using Claude Code CLI.
#          Designed for local use and CI pipelines.
#          Automatically detects codebase type, existing docs state, and monorepo layout.
# Requirements: claude CLI

REQUIRED_ARGS=()
REQUIRED_ENV_VARS=()
REQUIRED_PROGRAMS=("claude")

# Defaults
PROJECT_DIR="${PWD}"
OUTPUT_DIR="docs"
PRINT_ONLY="false"

usage() {
  cat << 'EOF'
Usage: generate-docs.sh [OPTIONS]

Generate project documentation using the superdocs skill.

Superdocs automatically detects:
- Whether this is a codebase (validates source code exists)
- Whether this is a monorepo (generates per-package docs with root index)
- Whether docs already exist (migrates or updates as needed)
- What changed since docs were last updated (git-based staleness)

Options:
  --project-dir <path>   Project root directory (default: current directory)
  --output-dir <name>    Output directory name relative to project root (default: docs)
  --print-only           Print the prompt that would be sent to claude without executing
  -h, --help             Show this help message

Examples:
  # Generate docs for current project
  generate-docs.sh

  # Generate docs for a specific project
  generate-docs.sh --project-dir /path/to/project

  # Preview the prompt without executing
  generate-docs.sh --print-only

  # CI pipeline usage
  generate-docs.sh --project-dir . --output-dir docs

External tools:
  claude    Claude Code CLI (https://docs.anthropic.com/en/docs/claude-code)
EOF
}

check_requirements() {
  local -r provided_arg_count=$1
  local missing=0

  if [ ${#REQUIRED_ARGS[@]} -gt 0 ] && [ "$provided_arg_count" -lt ${#REQUIRED_ARGS[@]} ]; then
    printf 'Error: Expected %s arguments (%s) but received %s.\n' \
      ${#REQUIRED_ARGS[@]} "${REQUIRED_ARGS[*]}" "$provided_arg_count" >&2
    missing=1
  fi

  local env_var
  for env_var in "${REQUIRED_ENV_VARS[@]}"; do
    if [ -z "${!env_var:-}" ]; then
      printf 'Error: Missing required environment variable %s. Please set it before rerunning.\n' "$env_var" >&2
      missing=1
    fi
  done

  local program
  for program in "${REQUIRED_PROGRAMS[@]}"; do
    if ! command -v "$program" > /dev/null 2>&1; then
      printf 'Error: Required program %s is not installed or not on PATH. Please install it first.\n' "$program" >&2
      missing=1
    fi
  done

  if [ "$missing" -ne 0 ]; then
    printf '\n' >&2
    usage >&2
    return 1
  fi
}

build_prompt() {
  local project_dir="$1"
  local output_dir="$2"

  cat << PROMPT
Project directory: ${project_dir}
Output directory: ${output_dir}

Execute the superdocs skill. Run fully automatically — no user prompts or confirmations at any point.

Phase 1 — DISCOVER:
1. Validate this is a codebase (has package files, source dirs, or build config). If not, exit with an error.
2. Detect if this is a monorepo (workspace configs, multi-package dirs, monorepo tools). Classify as SINGLE or MONOREPO.
3. Scan the entire repo for existing ADRs in any location (adr/, adrs/, decisions/, doc/adr/, scattered ADR-*.md files). Record what exists so they can be centralized into ${output_dir}/adr/.
4. Check for existing docs in ${output_dir}/. Classify as:
   - FRESH: No ${output_dir}/ directory → full generation from scratch
   - MIGRATE: ${output_dir}/ exists but not in superdocs format → absorb existing content, then generate
   - UPDATE: ${output_dir}/ exists in superdocs format → diff codebase changes, update stale content
5. If UPDATE: compute git-based staleness by comparing last docs commit to HEAD. List changed files and map them to affected superdocs documents.
6. Detect tech stack (language, framework, build system, test framework, CI/CD).
7. Read existing docs (README.md, CLAUDE.md, AGENTS.md, CONTRIBUTING.md, CHANGELOG.md).
8. Build project tree and estimate scope.

Phase 1b — MIGRATE (only if MIGRATE state):
- Inventory existing docs, map content to superdocs structure, extract reusable content, restructure.
- Centralize any existing ADRs found in step 3 into ${output_dir}/adr/, normalizing format and renumbering sequentially.

Phase 2 — RESEARCH:
Launch 5 parallel exploration agents:
   Agent 1: Architecture & Structure (entry points, components, data flow, integrations)
   Agent 2: Patterns & Conventions (naming, error handling, config, code style)
   Agent 3: Domain & Business Logic (entities, features, API surface, glossary terms)
   Agent 4: Build, Test & Deploy Pipeline (commands, CI/CD, deployment)
   Agent 5: Decision Archaeology (git history, plan files, code comments for ADR candidates)

For MONOREPO: run agents per-package, parallelizing across packages.
For UPDATE: focus research on areas identified as changed in the staleness report.

Phase 3 — OUTLINE:
Plan which documents to generate. For UPDATE mode, build a change plan showing which docs are stale, which need new content, and which are unchanged.

Phase 4 — GENERATE:
Write markdown files to ${output_dir}/:
   - overview.md: WHAT the project is, WHY it exists, key features
   - architecture.md: HOW the system is structured, component relationships, WHY design choices were made
   - getting-started.md: HOW to set up and run the project
   - development.md: HOW to contribute, test, and deploy
   - adr/README.md: Index of Architecture Decision Records
   - adr/NNNN-[slug].md: Individual ADRs mined from git history, plan files, code comments, and project structure
   - glossary.md: WHAT domain-specific terms mean in this project

For MONOREPO: generate per-package docs, then a root ${output_dir}/README.md linking to each package.
For UPDATE: rewrite only stale documents, create new ADRs, leave accurate docs untouched.

For each document:
   - Use actual file paths, commands, and code from the project
   - Include cross-links to other documents
   - Flag uncertain claims with <!-- TODO: verify --> comments
   - Answer WHAT, HOW, and WHY at every level

Phase 5 — VERIFY:
Check that all file paths mentioned exist, all commands are valid, cross-links work, and WHAT/HOW/WHY coverage is complete.

Print a final summary showing:
- Project name and type (SINGLE/MONOREPO)
- Docs state (FRESH/MIGRATE/UPDATE)
- Files generated/updated/unchanged
- Line counts
- WHAT/HOW/WHY coverage matrix
- TODOs remaining
PROMPT
}

parse_args() {
  while [ $# -gt 0 ]; do
    case $1 in
      --project-dir)
        PROJECT_DIR="$2"
        shift 2
        ;;
      --output-dir)
        OUTPUT_DIR="$2"
        shift 2
        ;;
      --print-only)
        PRINT_ONLY="true"
        shift
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        printf 'Error: Unknown option: %s\n' "$1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

main() {
  parse_args "$@"
  check_requirements 0 || exit 1

  # Resolve project directory to absolute path
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

  if [ ! -d "$PROJECT_DIR" ]; then
    printf 'Error: Project directory does not exist: %s\n' "$PROJECT_DIR" >&2
    exit 1
  fi

  local prompt
  prompt="$(build_prompt "$PROJECT_DIR" "$OUTPUT_DIR")"

  if [ "$PRINT_ONLY" = "true" ]; then
    printf '%s\n' "$prompt"
    exit 0
  fi

  printf 'Superdocs: Generating documentation for %s\n' "$PROJECT_DIR"
  printf 'Output directory: %s/%s\n' "$PROJECT_DIR" "$OUTPUT_DIR"
  printf '---\n'

  claude --print \
    --project-dir "$PROJECT_DIR" \
    --allowedTools "Read,Write,Edit,Bash(ls:*),Bash(git:*),Bash(tree:*),Bash(wc:*),Bash(mkdir:*),Glob,Grep,Task" \
    "$prompt"

  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    printf '\n---\n'
    printf 'Superdocs: Documentation generated successfully in %s/%s\n' "$PROJECT_DIR" "$OUTPUT_DIR"
  else
    printf '\n---\n' >&2
    printf 'Superdocs: Documentation generation failed (exit code %s)\n' "$exit_code" >&2
  fi

  return $exit_code
}

main "$@"
