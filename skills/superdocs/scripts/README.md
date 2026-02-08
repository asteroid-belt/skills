# Superdocs Scripts

## generate-docs.sh

Generate project documentation using the superdocs skill via Claude Code CLI.

Superdocs automatically detects the codebase type, existing docs state, and monorepo layout. No mode flags needed — it figures out what to do based on what it finds.

### Local Usage

```bash
# Generate docs for current project
./scripts/generate-docs.sh

# Generate docs for a specific project
./scripts/generate-docs.sh --project-dir /path/to/project

# Preview the prompt without executing
./scripts/generate-docs.sh --print-only
```

### CI Pipeline Usage

```yaml
# GitHub Actions example
- name: Generate documentation
  run: ./scripts/generate-docs.sh --project-dir . --output-dir docs

# GitLab CI example
generate-docs:
  script:
    - ./scripts/generate-docs.sh --project-dir . --output-dir docs
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `--project-dir <path>` | Current directory | Project root to document |
| `--output-dir <name>` | `docs` | Output directory (relative to project root) |
| `--print-only` | off | Print the prompt without running claude |
| `-h, --help` | - | Show usage information |

### Requirements

- `claude` CLI installed and configured
