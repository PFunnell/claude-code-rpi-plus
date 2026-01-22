# Configuration Reference

Complete reference for all configuration options.

## Configuration Files

| File | Purpose | Committed |
|------|---------|-----------|
| `portable_config.local.yaml` | Project settings | No |
| `portable_config.local.example.yaml` | Template | Yes |
| `settings.json` | Baseline permissions | Yes |
| `settings.local.json` | User-specific overrides | No |

## portable_config.local.yaml

Main configuration file. Copy from `.example` and customize.

### project

```yaml
project:
  name: "MyProject"    # Required - used in headers, statusline
```

### paths

```yaml
paths:
  python: "python"     # Python executable path
                       # Examples:
                       #   "python"
                       #   "python3"
                       #   "/usr/bin/python3"
                       #   "C:/Users/you/miniconda3/envs/myenv/python.exe"
```

### tests

```yaml
tests:
  command: "pytest tests/ -q"     # Primary test command
  ci_command: ""                  # Optional: different for CI
```

### validator

```yaml
validator:
  command: "python scripts/validate-artefacts.py"
  enabled: true                   # Set false to skip validation
```

### artefacts

```yaml
artefacts:
  plans_dir: "docs/plans/"
  research_dir: "docs/research/"
  state_dir: "docs/state/"
  verification_dir: "docs/verification/"
```

All paths are relative to repository root. Include trailing slash.

#### Artefact Location Enforcement

The validator (`scripts/validate-artefacts.py`) enforces artefact locations using **filename patterns**:

| Pattern | Expected Location | Example |
|---------|------------------|---------|
| `_plan` | plans_dir | `feature_plan.md` |
| `_implementation` | plans_dir | `api_implementation.md` |
| `_checkpoint` | state_dir | `wave1_checkpoint.md` |
| `_state` | state_dir | `session_state.md` |
| `_research` | research_dir | `auth_research.md` |
| `_analysis` | research_dir | `perf_analysis.md` |
| `.brief` | research_dir | `api.brief.md` |
| `verify_` | verification_dir | `verify_auth.md` |

**How it works**:
1. Validator reads paths from `portable_config.local.yaml` (falls back to defaults if missing)
2. Scans `docs/` and `thoughts/` directories for `.md` files
3. Matches filenames against patterns
4. Reports files in wrong locations

**Migration from `thoughts/shared/`**: If your project used `thoughts/shared/plans/` etc., either:
- Update `portable_config.local.yaml` to point to your existing paths, or
- Move artefacts to `docs/` structure (validator handles both)

### ui (optional)

```yaml
ui:
  enabled: false                  # Set true for web projects
  root: "ui/"                     # UI source directory
  url: "http://localhost:3000"    # Dev server URL
  dev_command: "npm run dev"      # How to start dev server
```

### workflow

```yaml
workflow:
  phase_gate:
    show_validation_report: true  # Show table at phase gates
    remind_transcript: true       # Remind about transcripts
  session:
    auto_detect_resume: true      # Prompt for /resume on start
  gitsync:
    check_ci_status: true         # Check CI before push (needs gh)
  research:
    link_to_resume: true          # Update RESUME.md after research
```

## settings.json

Baseline Claude Code permissions. Committed to repo.

```json
{
  "statusLine": {
    "type": "command",
    "command": "python .claude/statusline.py",
    "padding": 0
  },
  "permissions": {
    "allow": [
      "WebSearch",
      "Bash(python:*)",
      "Bash(pytest:*)",
      "Bash(git status:*)",
      "Skill(create_plan)",
      "Skill(implement_plan)"
    ]
  }
}
```

### statusLine

| Field | Type | Description |
|-------|------|-------------|
| type | string | "command" for custom script |
| command | string | Script to run |
| padding | number | Padding around output |

### permissions.allow

Array of permission patterns:
- `Bash(command:*)` - Allow bash command prefix
- `Skill(name)` - Allow skill/command
- `WebSearch` - Allow web search

## settings.local.json

User-specific overrides. Not committed.

```json
{
  "env": {
    "CLAUDE_CODE_SHELL": "powershell"
  },
  "permissions": {
    "allow": [
      "Bash(C:/full/path/to/python.exe:*)",
      "Skill(ui_smoke)"
    ]
  }
}
```

Use for:
- Machine-specific paths
- Additional permissions
- Environment variables
- Optional extension skills

## Rules Files

Claude Code automatically loads all `.md` files from `.claude/rules/`.

### Loading Precedence

1. `~/.claude/rules/` - User-level (applies to all your projects)
2. `./.claude/rules/` - Project-level (highest priority, overrides user-level)

### When to Use Each

**User-level** (`~/.claude/rules/`):
- Personal preferences (output style, transcript handling)
- Rules that apply to ALL your projects
- Not shared with team

**Project-level** (`./.claude/rules/`):
- Team conventions (committed to repo)
- Project-specific constraints
- Shared with all developers

### Path-Specific Rules

Rules can target specific files using frontmatter:

```markdown
---
paths:
  - "src/**/*.py"
---

# Python-specific rules here
```

## Environment Variables

Set in `.env` file (gitignored):

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost/db

# API Keys
API_KEY=your-key-here

# Feature flags
ENABLE_INTEGRATION_TESTS=true
```

**Never put credentials in settings files.** Use `.env` instead.

## Path Resolution

Paths in configuration are resolved:

1. **Relative paths**: From repository root
2. **Absolute paths**: Used as-is
3. **Command paths**: Subject to shell PATH

Examples:
```yaml
# Relative (recommended)
plans_dir: "docs/plans/"

# Absolute (when needed)
python: "C:/Users/you/miniconda3/envs/myenv/python.exe"
```

## Customizing for Your Stack

### Python project

```yaml
paths:
  python: "python"  # Or venv path
tests:
  command: "pytest tests/ -q"
```

### Node.js project

```yaml
paths:
  python: "python"  # Still needed for statusline
tests:
  command: "npm test"
ui:
  enabled: true
  dev_command: "npm run dev"
```

### Go project

```yaml
tests:
  command: "go test ./..."
```

### Multi-language project

```yaml
tests:
  command: "make test"  # Use Makefile to orchestrate
```

## Validation

Check configuration validity:

```bash
# Verify YAML syntax
python -c "import yaml; yaml.safe_load(open('.claude/portable_config.local.yaml'))"

# Verify JSON syntax
python -c "import json; json.load(open('.claude/settings.json'))"
```

Or use the pack validator:

```bash
python scripts/validate-pack.py
```
