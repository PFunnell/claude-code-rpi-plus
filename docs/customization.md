# Customization Guide

Adapting the RPI Plus pack for your project.

## Adding Custom Commands

### Create the command file

Location: `.claude/commands/your_command.md`

```markdown
# /your_command

Description of what this command does.

## Configuration

Read `.claude/portable_config.local.yaml` for settings.

## Steps

1. Step one
2. Step two
3. Step three

## Constraints

- Constraint one
- Constraint two
```

### Add permission

In `.claude/settings.json` (for team) or `settings.local.json` (for you):

```json
{
  "permissions": {
    "allow": [
      "Skill(your_command)"
    ]
  }
}
```

### Command best practices

- Read from config file, don't hardcode paths
- Include clear error handling
- Document prerequisites
- Keep commands focused on one task

## Adding Custom Rules

### Create the rule file

Location: `.claude/rules/your-rule.md`

```markdown
# Your Rule Name

Brief description of what this rule enforces.

## Protocol

Step-by-step instructions for following this rule.

## Examples

Good:
- Example of correct behavior

Bad:
- Example of incorrect behavior

## Rationale

Why this rule exists.
```

### Rule best practices

- Be specific and actionable
- Include examples
- Explain the "why"
- Reference other rules if related

## Modifying Existing Commands

### Safe modifications

- Adding optional steps
- Adjusting output format
- Adding configuration options
- Extending verification

### Dangerous modifications

- Removing verification steps
- Bypassing phase gates
- Removing human approval requirements

### How to modify

1. Read the original command fully
2. Understand the workflow it supports
3. Make targeted changes
4. Test the modified command
5. Document changes

## Creating Project-Specific Extensions

### Extension structure

```text
.claude/extensions/your-extension/
├── README.md           # What, why, how
├── command.md          # Command file (copy to commands/)
├── rule.md             # Rule file (copy to rules/)
└── template.md         # Any templates
```

### README template

```markdown
# Your Extension

What this extension does.

## When to Use

Install if: [conditions]
Skip if: [conditions]

## Prerequisites

- Requirement 1
- Requirement 2

## Installation

1. Copy files
2. Update config
3. Add permissions

## Usage

How to use after installation.
```

## Customizing Artefact Directories

### Change locations

In `portable_config.local.yaml`:

```yaml
artefacts:
  plans_dir: "docs/design/"           # Custom location
  research_dir: "docs/analysis/"      # Custom location
  state_dir: ".workflow/state/"       # Hidden location
  verification_dir: "docs/qa/"        # Custom location
```

### Update validator

If using custom locations, verify `scripts/validate-artefacts.py` reads from config.

### Update .gitignore

Ensure new locations are appropriately tracked or ignored.

## Customizing the Statusline

### Python version

Edit `.claude/statusline.py`:

```python
# Add custom indicators
def get_custom_status():
    # Your logic here
    return "[CUSTOM]"

# Include in output
status += f" | {get_custom_status()}"
```

### Switch to bash/PowerShell

Update `settings.json`:

```json
{
  "statusLine": {
    "command": "bash .claude/statusline.sh"
  }
}
```

Or:

```json
{
  "statusLine": {
    "command": "powershell -File .claude/statusline.ps1"
  }
}
```

## Customizing Permissions

### Generic patterns (recommended)

```json
"Bash(pytest:*)"           // Any pytest command
"Bash(npm:*)"              // Any npm command
"Bash(docker:*)"           // Any docker command
```

### Specific paths (when needed)

```json
"Bash(/usr/local/bin/special-tool:*)"
```

### Why generic is better

- Works across machines
- Survives path changes
- Easier to maintain
- More portable

## Integrating with CI/CD

### GitHub Actions

Add pack validation to CI:

```yaml
- name: Validate artefacts
  run: python scripts/validate-artefacts.py
```

### Pre-commit hooks

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
python scripts/validate-artefacts.py
```

### CI test command

In `portable_config.local.yaml`:

```yaml
tests:
  command: "pytest tests/ -q"
  ci_command: "pytest tests/ --tb=short --strict-markers"
```

## Language-Specific Customizations

### Python

```yaml
paths:
  python: "python"  # Or venv path
tests:
  command: "pytest tests/ -v -o addopts=''"
```

### JavaScript/TypeScript

```yaml
tests:
  command: "npm test"
ui:
  enabled: true
  dev_command: "npm run dev"
```

### Go

```yaml
tests:
  command: "go test ./..."
```

### Rust

```yaml
tests:
  command: "cargo test"
```

### Multi-language

```yaml
tests:
  command: "make test"  # Orchestrate with Makefile
```

## Debugging Customizations

### Test commands manually

```bash
# Test your custom command works
python scripts/validate-artefacts.py
```

### Check configuration parsing

```python
import yaml
config = yaml.safe_load(open('.claude/portable_config.local.yaml'))
print(config)
```

### Verify permissions

Start Claude Code and try the command. Permission errors indicate missing entries.
