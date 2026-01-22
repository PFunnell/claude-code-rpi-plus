# Troubleshooting Guide

Common issues and their solutions.

## Installation Issues

### "Permission denied" on install.sh

```bash
chmod +x install.sh
./install.sh
```

### Python not found

The statusline requires Python. Either:

1. Install Python 3.8+
2. Update statusline command path in `settings.json`:
   ```json
   "command": "/full/path/to/python3 .claude/statusline.py"
   ```
3. Use bash alternative:
   ```json
   "command": "bash .claude/statusline.sh"
   ```

### Directory already exists

If `.claude/` exists, installer asks to merge. Options:
- Answer 'y' to merge (overwrites existing files)
- Answer 'n' to abort
- Manually backup and remove `.claude/` first

## Configuration Issues

### "Missing config file"

Commands show:
```text
ERROR: Missing config file .claude/portable_config.local.yaml
```

Solution:
```bash
cp .claude/portable_config.local.example.yaml .claude/portable_config.local.yaml
# Edit the file with your settings
```

### YAML parse error

Check YAML syntax:
```python
python -c "import yaml; yaml.safe_load(open('.claude/portable_config.local.yaml'))"
```

Common issues:
- Tabs instead of spaces (use spaces)
- Missing quotes around special characters
- Incorrect indentation

### Command not recognized

Skill not allowed. Add to permissions:

```json
{
  "permissions": {
    "allow": ["Skill(command_name)"]
  }
}
```

Then restart Claude Code.

## Workflow Issues

### Tests fail during phase gate

The phase gate is working correctly. Options:

1. Fix the failing tests
2. Check if tests are flaky
3. Verify test environment is set up

**Do not bypass** the test requirement.

### Validator reports misplaced artefacts

Files are in wrong directories. Move them:

```bash
# Example: plan in wrong location
mv docs/wrong_plan.md docs/plans/
```

Or if locations are intentional, update `portable_config.local.yaml`.

### Chrome not connected (UI smoke)

```text
BLOCKED: Chrome not connected.
```

Solution:
1. Exit Claude Code
2. Restart with Chrome: `claude --chrome`
3. Ensure Chrome browser is installed

### RESUME.md not found

Normal for new sessions. Either:
1. Start fresh (no prior context)
2. Create RESUME.md manually
3. Run `/implement_plan` to generate one

## Shell Issues

### Shell syntax errors

Claude Code's Bash tool uses bash, not PowerShell. Use bash syntax:

```bash
# Correct (bash)
export VAR=value
if [ -n "$VAR" ]; then echo "set"; fi

# Wrong (PowerShell)
$env:VAR = "value"
if ($var) { Write-Host "set" }
```

### Command chaining breaks permissions

Piped commands bypass permission matching:

```bash
# May prompt for permission even if pytest is allowed
pytest tests/ | head -20
```

Solution: Use tool flags instead:
```bash
pytest tests/ --tb=short
```

### "Command not found"

Python/tool not in PATH. Options:

1. Use full path in config:
   ```yaml
   paths:
     python: "/full/path/to/python"
   ```

2. Activate environment before starting Claude Code:
   ```bash
   conda activate myenv
   claude
   ```

## Permission Issues

### "Permission denied" for bash commands

Add permission pattern to settings:

```json
"Bash(your-command:*)"
```

Use generic patterns for portability.

### Skill permission denied

Add to settings:

```json
"Skill(skill_name)"
```

### Too many permission prompts

Add commonly used commands to `settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(python:*)",
      "Bash(pytest:*)",
      "Bash(git:*)"
    ]
  }
}
```

## Git Issues

### Git hooks fail

Check what hook is failing:
```bash
git commit -m "test" 2>&1
```

Common causes:
- Pre-commit hook runs tests that fail
- Linting errors
- Missing dependencies

### Commit blocked by /gitsync

`/gitsync` requires tests to pass. Either:
1. Fix failing tests
2. Manually commit if tests are known-failing

### Wrong branch

Check current branch:
```bash
git branch
```

RESUME.md may reference a different branch than you're on.

## Extension Issues

### UI smoke can't connect

1. Verify Claude Code started with `--chrome`
2. Check Chrome is installed
3. Close other Chrome debugging sessions
4. Try restarting both Chrome and Claude Code

### Data dictionary not found

Create from template:
```bash
cp .claude/extensions/data-contracts/dictionary.template.md docs/data_dictionary.md
```

## Performance Issues

### Statusline slow

The Python statusline runs git commands. If slow:

1. Check git repository size
2. Use simpler bash statusline
3. Disable statusline temporarily:
   ```json
   "statusLine": null
   ```

### Commands timeout

Some operations take time. Options:
1. Wait for completion
2. Run command manually to see output
3. Check for infinite loops in custom scripts

## Getting Help

### Collect diagnostic info

```bash
# Python version
python --version

# Git version
git --version

# Config file contents
cat .claude/portable_config.local.yaml

# Directory structure
ls -la .claude/
ls -la .claude/commands/
ls -la .claude/rules/
```

### Verify pack integrity

```bash
python scripts/validate-pack.py
```

### Check artefact locations

```bash
python scripts/validate-artefacts.py
```
