# Installation Guide

Detailed instructions for installing Claude Code RPI Plus.

## Recommended Workflow

**Run `/init` before installing the pack.** This ensures:
- Claude Code auto-detects your project's language, build system, and test framework
- A baseline `CLAUDE.md` exists before the pack is installed
- No confusion between pack files and your actual project code

## Step 1: Initialize with /init

```bash
cd /path/to/your/project
claude
> /init
```

For greenfield projects, have your PRD or spec ready so `/init` can reference it.

## Step 2: Install the Pack

### Unix/macOS

```bash
git clone https://github.com/youruser/claude-code-rpi-plus.git
./claude-code-rpi-plus/install.sh /path/to/your/project
```

### Windows

```powershell
git clone https://github.com/youruser/claude-code-rpi-plus.git
.\claude-code-rpi-plus\install.ps1 C:\path\to\your\project
```

## What Gets Installed

The installer copies these files to your project:

```text
your-project/
├── .claude/
│   ├── README.md
│   ├── settings.json
│   ├── settings.local.example.json
│   ├── portable_config.local.example.yaml
│   ├── portable_config.local.yaml        # Created from example
│   ├── statusline.py
│   ├── statusline.sh
│   ├── statusline.ps1
│   ├── commands/
│   │   ├── create_plan.md
│   │   ├── implement_plan.md
│   │   ├── research_codebase.md
│   │   ├── phase_complete.md
│   │   ├── gitsync.md
│   │   └── resume_project.md
│   ├── rules/
│   │   ├── hard-constraints.md
│   │   ├── phase-gates.md
│   │   ├── command-execution.md
│   │   ├── env-handling.md
│   │   └── diagnostics.md
│   └── extensions/                        # Optional modules
├── scripts/
│   ├── validate-artefacts.py
│   ├── cc-transcript.ps1
│   └── cc-transcript.sh
├── docs/
│   ├── plans/                             # Created empty
│   ├── research/                          # Created empty
│   ├── state/                             # Created empty
│   └── verification/                      # Created empty
├── CLAUDE.md.template                     # Rename and customize
├── templates/
│   └── claudeignore.template              # Optional: copy to .claudeignore
└── .gitignore                             # Updated or created
```

## Step 3: Merge Workflow into CLAUDE.md

After running the installer, use this prompt in Claude Code:

```text
Merge the workflow section from CLAUDE.md.template into the existing CLAUDE.md.
Then configure .claude/portable_config.local.yaml with the project name and test command.
Finally, run /phase_complete to verify setup and delete CLAUDE.md.template.
```

This merges the RPI workflow into your `/init`-generated CLAUDE.md, preserving the auto-detected project configuration.

### What Gets Merged

From `CLAUDE.md.template`:
- Development Workflow section (RPI commands)
- Configuration pointers (portable_config, rules, RESUME.md)
- Any project-specific constraints you add

Your existing CLAUDE.md keeps:
- Project overview from `/init`
- Build/test commands detected by `/init`
- Language-specific guidance

### Alternative: Fresh Project

If you haven't run `/init` yet, you can rename `CLAUDE.md.template` directly:

```bash
mv CLAUDE.md.template CLAUDE.md
# Then run /init to enhance it, or edit manually
```

## Manual Configuration

If you prefer to configure manually:

### 1. Configure portable_config.local.yaml

Edit `.claude/portable_config.local.yaml`:

```yaml
project:
  name: "YourProjectName"

tests:
  command: "pytest tests/ -q"       # Your test runner
```

### 2. Create CLAUDE.md

```bash
mv CLAUDE.md.template CLAUDE.md
# Edit CLAUDE.md with your project description
```

### 3. Verify Installation

```bash
claude
> /phase_complete
```

### 4. Clean Up

```bash
rm -rf templates/ examples/ install.sh install.ps1
```

## Manual Installation

If you prefer manual control:

### 1. Copy .claude directory

```bash
cp -r claude-code-rpi-plus/.claude your-project/
```

### 2. Copy scripts

```bash
mkdir -p your-project/scripts
cp claude-code-rpi-plus/scripts/validate-artefacts.py your-project/scripts/
cp claude-code-rpi-plus/scripts/cc-transcript.* your-project/scripts/
```

### 3. Create artefact directories

```bash
mkdir -p your-project/docs/{plans,research,state,verification}
```

### 4. Create configuration

```bash
cd your-project/.claude
cp portable_config.local.example.yaml portable_config.local.yaml
# Edit portable_config.local.yaml
```

### 5. Update .gitignore

Add these entries:

```text
.claude/portable_config.local.yaml
.claude/settings.local.json
.env
.env.local
.env.backup.*
```

## Greenfield vs Existing Codebase

### New Project (Greenfield)

1. Create repo, add PRD or spec document
2. Run `/init` to generate baseline CLAUDE.md
3. Install pack
4. Merge CLAUDE.md.template into CLAUDE.md
5. Start with `/create_plan` for your first feature

### Existing Codebase

1. Run `/init` to generate CLAUDE.md from existing code
2. Install pack
3. Merge CLAUDE.md.template workflow section
4. Use `/research_codebase` to understand current state
5. Gradually adopt phase gates for new features
6. Existing code doesn't need retrofitting

## Installing Extensions

Extensions are optional. Install only what you need:

### UI Smoke (Web Applications)

```bash
cp .claude/extensions/ui-smoke/ui_smoke.md .claude/commands/
# Update portable_config.local.yaml with ui settings
# Add Skill(ui_smoke) to settings.local.json
```

### Data Contracts (APIs, Databases)

```bash
cp .claude/extensions/data-contracts/data-contracts.md .claude/rules/
cp .claude/extensions/data-contracts/dictionary.template.md docs/data_dictionary.md
```

### Team Workflow

```bash
mkdir -p docs/workflow
cp .claude/extensions/team-workflow/*.md docs/workflow/
```

See [Extensions Guide](../.claude/extensions/README.md) for details.

## Updating the Pack

To update an existing installation:

1. Clone latest pack version
2. Compare your `.claude/` with the new version
3. Manually merge changes (commands may have new features)
4. Keep your `portable_config.local.yaml` and `settings.local.json`

**Note**: Your local config files won't be overwritten by reinstalling.

## Troubleshooting Installation

### Permission denied on scripts

```bash
chmod +x scripts/cc-transcript.sh
chmod +x install.sh
```

### Python not found for statusline

Update `settings.json` to use full Python path:

```json
{
  "statusLine": {
    "command": "/usr/bin/python3 .claude/statusline.py"
  }
}
```

### Commands not recognized

Verify Claude Code can read the commands directory:

```bash
ls -la .claude/commands/
```

All `.md` files should be present.
