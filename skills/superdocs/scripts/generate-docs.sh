#!/usr/bin/env bash
set -euo pipefail

# Script: generate-docs.sh
# Purpose: Generate project documentation via superdocs skill using Claude Code CLI.
#          Designed for local use and CI pipelines.
# Requirements: claude CLI

REQUIRED_ARGS=()
REQUIRED_ENV_VARS=()
REQUIRED_PROGRAMS=("claude")

# Defaults
PROJECT_DIR="${PWD}"
OUTPUT_DIR="docs"
MODE="full"
PRINT_ONLY="false"

usage() {
  cat << 'EOF'
Usage: generate-docs.sh [OPTIONS]

Generate project documentation using the superdocs skill.

Options:
  --project-dir <path>   Project root directory (default: current directory)
  --output-dir <name>    Output directory name relative to project root (default: docs)
  --mode <mode>          Generation mode: full or incremental (default: full)
  --print-only           Print the prompt that would be sent to claude without executing
  -h, --help             Show this help message

Modes:
  full          Generate all documentation from scratch
  incremental   Update existing docs, preserving manual edits

Examples:
  # Generate docs for current project
  generate-docs.sh

  # Generate docs for a specific project
  generate-docs.sh --project-dir /path/to/project

  # Update existing docs
  generate-docs.sh --mode incremental

  # CI pipeline usage
  generate-docs.sh --project-dir . --output-dir docs --mode full

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
  local mode="$3"

  local mode_instruction=""
  if [ "$mode" = "incremental" ]; then
    mode_instruction="Run in incremental mode: read existing docs in ${output_dir}/ and update only stale sections. Preserve content outside of <!-- superdocs:start --> / <!-- superdocs:end --> markers."
  else
    mode_instruction="Run in full mode: generate all documentation from scratch in ${output_dir}/."
  fi

  cat << PROMPT
You are running in headless/CI mode. Do not ask for user confirmation at any point. Proceed automatically through all phases.

Project directory: ${project_dir}
Output directory: ${output_dir}

${mode_instruction}

Execute the superdocs skill:

1. DISCOVER: Scan the project at ${project_dir}. Read README.md, CLAUDE.md, AGENTS.md, and any existing docs. Detect the tech stack. Build a project tree. Estimate project scope.

2. RESEARCH: Launch parallel exploration to understand:
   - Architecture and structure (entry points, components, data flow)
   - Patterns and conventions (naming, error handling, configuration)
   - Domain and business logic (entities, features, API surface)
   - Build, test, and deploy pipeline (commands, CI/CD, deployment)

3. OUTLINE: Plan which documents to generate based on what was discovered. Generate all applicable documents.

4. GENERATE: Write the following markdown files to ${output_dir}/:
   - overview.md: WHAT the project is, WHY it exists, key features
   - architecture.md: HOW the system is structured, component relationships, WHY design choices were made
   - getting-started.md: HOW to set up and run the project
   - development.md: HOW to contribute, test, and deploy
   - decisions.md: WHY key technical decisions were made (infer from code if no ADRs exist)
   - glossary.md: WHAT domain-specific terms mean in this project

   For each document:
   - Use actual file paths, commands, and code from the project
   - Include cross-links to other documents
   - Flag uncertain claims with <!-- TODO: verify --> comments
   - Answer WHAT, HOW, and WHY at every level

5. VERIFY: Check that all file paths mentioned exist, all commands are valid, cross-links work, and WHAT/HOW/WHY coverage is complete.

Print a final summary showing files generated, line counts, and any TODOs remaining.
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
      --mode)
        MODE="$2"
        if [ "$MODE" != "full" ] && [ "$MODE" != "incremental" ]; then
          printf 'Error: --mode must be "full" or "incremental", got "%s".\n' "$MODE" >&2
          exit 1
        fi
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
  prompt="$(build_prompt "$PROJECT_DIR" "$OUTPUT_DIR" "$MODE")"

  if [ "$PRINT_ONLY" = "true" ]; then
    printf '%s\n' "$prompt"
    exit 0
  fi

  printf 'Superdocs: Generating documentation for %s\n' "$PROJECT_DIR"
  printf 'Output directory: %s/%s\n' "$PROJECT_DIR" "$OUTPUT_DIR"
  printf 'Mode: %s\n' "$MODE"
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
