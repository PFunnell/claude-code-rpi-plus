# Python CLI Example

Minimal example of the RPI Plus pack with a Python CLI project.

## Project Structure

```text
python-cli/
├── .claude/                  # RPI Plus pack
├── docs/
│   ├── plans/
│   ├── research/
│   ├── state/
│   └── verification/
├── scripts/
│   └── validate-artefacts.py
├── src/
│   └── cli.py               # Simple CLI
├── tests/
│   └── test_cli.py          # Basic tests
├── CLAUDE.md
└── pyproject.toml
```

## Configuration

`portable_config.local.yaml`:
```yaml
project:
  name: "PythonCLI"

paths:
  python: "python"

tests:
  command: "pytest tests/ -q"

artefacts:
  plans_dir: "docs/plans/"
  research_dir: "docs/research/"
  state_dir: "docs/state/"
  verification_dir: "docs/verification/"
```

## Usage

1. Install the RPI Plus pack to this directory
2. Copy `portable_config.local.example.yaml` to `portable_config.local.yaml`
3. Install dependencies: `pip install pytest`
4. Start Claude Code: `claude`
5. Try commands: `/phase_complete`, `/research_codebase`

## Sample Workflow

```text
# Understand the project
/research_codebase

# Plan a new feature
/create_plan
"Add a --verbose flag to the CLI"

# Implement after approval
/implement_plan

# Commit when done
/gitsync
```
