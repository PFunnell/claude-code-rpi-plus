# Adding to Existing Codebase

Guide for adding the RPI Plus pack to an existing project.

## Before You Start

1. **Commit or stash current work** - Clean working directory
2. **Backup .gitignore** - We'll be adding entries
3. **Note existing conventions** - Customize pack to match

## Installation Steps

### 1. Install the pack

```bash
./install.sh /path/to/existing/project
```

### 2. Customize configuration

Edit `.claude/portable_config.local.yaml`:

```yaml
project:
  name: "YourExistingProject"

paths:
  python: "python"              # Or your venv path

tests:
  command: "your-test-command"  # Match your existing setup
```

### 3. Create CLAUDE.md

Don't use the template blindly. Create CLAUDE.md that describes YOUR project:

```markdown
# CLAUDE.md

## Project Overview

[Describe your actual project]

## Architecture

[Document your actual structure]

## Commands

[Your actual commands]

## Constraints

[Your actual constraints]
```

### 4. Decide on artefact locations

Options:

**Option A: Use pack defaults**
```yaml
artefacts:
  plans_dir: "docs/plans/"
  state_dir: "docs/state/"
```

**Option B: Match existing structure**
```yaml
artefacts:
  plans_dir: "docs/design/"     # Your existing design docs
  state_dir: "docs/workflow/"   # New, but matches your style
```

**Option C: Hidden directories**
```yaml
artefacts:
  plans_dir: ".workflow/plans/"
  state_dir: ".workflow/state/"
```

### 5. Start gradually

Don't try to adopt everything at once:

**Week 1**: Just use `/research_codebase` to explore
**Week 2**: Try `/create_plan` for a new feature
**Week 3**: Full workflow with `/implement_plan`

## Handling Existing Patterns

### If you already have docs/

The pack creates `docs/plans/`, `docs/research/`, etc. as subdirectories.
Your existing docs are not affected.

### If you have different test setup

Update the test command:

```yaml
tests:
  command: "make test"          # If using Makefile
  command: "npm test"           # If Node.js
  command: "go test ./..."      # If Go
```

### If you have CI/CD

Add artefact validation to CI:

```yaml
# .github/workflows/ci.yml
- name: Validate artefacts
  run: python scripts/validate-artefacts.py
```

## What NOT to Retrofit

Don't try to:
- Create plans for past work
- Write checkpoints for completed features
- Restructure existing documentation

The pack is for **new work**. Existing code doesn't need workflow artefacts.

## Gradual Adoption Checklist

- [ ] Pack installed
- [ ] Configuration customized
- [ ] CLAUDE.md created
- [ ] Test command verified
- [ ] First `/research_codebase` run
- [ ] First `/create_plan` for real feature
- [ ] First full implement cycle complete
- [ ] Team onboarded (if applicable)

## Rolling Back

If you decide the pack isn't for you:

```bash
rm -rf .claude/
rm -rf docs/plans/ docs/research/ docs/state/ docs/verification/
rm scripts/validate-artefacts.py scripts/cc-transcript.*
# Remove pack entries from .gitignore
```

Your code is unchanged. Only workflow artefacts are removed.
