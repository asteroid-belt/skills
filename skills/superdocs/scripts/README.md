# Superdocs Scripts

## generate-docs.sh

Generate project documentation using the superdocs skill via Claude Code CLI.

### Local Usage

```bash
# Generate docs for current project
./scripts/generate-docs.sh

# Generate docs for a specific project
./scripts/generate-docs.sh --project-dir /path/to/project

# Update existing docs incrementally
./scripts/generate-docs.sh --mode incremental

# Preview the prompt without executing
./scripts/generate-docs.sh --print-only
```

### CI Pipeline Usage

```yaml
# GitHub Actions example
- name: Generate documentation
  run: ./scripts/generate-docs.sh --project-dir . --output-dir docs --mode full

# GitLab CI example
generate-docs:
  script:
    - ./scripts/generate-docs.sh --project-dir . --output-dir docs --mode full
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `--project-dir <path>` | Current directory | Project root to document |
| `--output-dir <name>` | `docs` | Output directory (relative to project root) |
| `--mode <mode>` | `full` | `full` (regenerate) or `incremental` (update) |
| `--print-only` | off | Print the prompt without running claude |
| `-h, --help` | - | Show usage information |

### Requirements

- `claude` CLI installed and configured
