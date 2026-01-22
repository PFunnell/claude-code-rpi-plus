# Claude Code RPI Plus

A professional workflow configuration for [Claude Code](https://claude.ai/code) that brings structure, quality assurance, and controllable autonomy to AI-assisted development.

## Features

- **RPI Workflow**: Research -> Plan -> Implement with explicit human gates
- **Phase Gates**: Checkpoints, verification, and session continuity
- **RESUME.md**: Never lose context across sessions or `/clear`
- **Cross-Platform**: Windows, macOS, Linux with Python/bash/PowerShell support
- **Extensible**: Optional modules for UI testing, data contracts, team workflows

## Quick Start

**Recommended workflow**: Run `/init` first, then install pack.

### 1. Initialize your project with Claude Code

```bash
cd /path/to/your/project
claude
> /init    # Auto-detects language, build system, test framework
```

This creates a baseline `CLAUDE.md` for your project.

### 2. Install the pack

```bash
# Clone the pack
git clone https://github.com/youruser/claude-code-rpi-plus.git

# Install to your project (Unix/macOS)
./claude-code-rpi-plus/install.sh /path/to/your/project

# Or Windows PowerShell
.\claude-code-rpi-plus\install.ps1 C:\path\to\your\project
```

### 3. Merge workflow into CLAUDE.md

In Claude Code, use this prompt:

```text
Merge the workflow section from CLAUDE.md.template into the existing CLAUDE.md.
Then configure .claude/portable_config.local.yaml with the project name and test command.
Finally, run /phase_complete to verify setup and delete CLAUDE.md.template.
```

This layers the RPI workflow onto your project's auto-detected configuration.

## Commands

| Command | Purpose |
|---------|---------|
| `/research_codebase` | Understand current code before changes |
| `/create_plan` | Design phased implementation approach |
| `/implement_plan` | Execute with verification at each phase |
| `/phase_complete` | Verify done-ness before commit |
| `/gitsync` | Stage, commit, push with checks |
| `/resume_project` | Restore session context |

## Why This Pack?

**Design Philosophy**: This pack prioritizes *developer control over automation* and *token efficiency over convenience*. Many AI coding configurations lean heavily into autonomous agents that consume large context windows rebuilding state each session. This pack takes a different approach.

**Core tradeoffs**:
- **Human gates, not auto-pilot**: Plans require explicit approval. Phases pause for review. You stay in control of what gets built and committed.
- **Predictable state, not context rebuilding**: RESUME.md and checkpoints create durable artefacts. New sessions read a small file instead of re-exploring the entire codebase.
- **Inspectable artefacts, not magic**: Research docs, plans, and checkpoints are plain markdown you can read, edit, and version control.
- **Individual-first, team-ready**: Works for solo developers; scales to teams by adding conventions rather than changing the core model.

**What this means in practice**:
- Lower token consumption per session (state is persisted, not rebuilt)
- Reduced risk (human approval gates prevent runaway changes)
- Full visibility (no opaque agent loops—you see every artefact)
- Portable knowledge (checkpoints survive session clears, context limits, and handoffs)

**What this pack adds**:
1. **Structure**: Defined workflow prevents context-free coding
2. **Continuity**: RESUME.md survives `/clear` and session resets
3. **Verification**: Phase gates catch issues before they compound
4. **Governance**: Rules prevent common mistakes (credential leaks, untested commits)

## The RPI Workflow

```text
    Research           Plan             Implement
   ┌─────────┐      ┌─────────┐      ┌─────────────┐
   │ Explore │ ──►  │ Design  │ ──►  │ Code + Test │
   │ Analyze │      │ Propose │      │ Verify      │
   └─────────┘      └────┬────┘      └──────┬──────┘
                         │                  │
                    Human Gate          Phase Gate
                    (approval)         (checkpoint)
```

- **Research**: Understand before changing
- **Plan**: Design before coding (human approves)
- **Implement**: Execute in phases with verification

## Documentation

- [Installation Guide](docs/install.md) - Detailed setup instructions
- [Configuration Reference](docs/configuration.md) - Full YAML/JSON reference
- [Workflow Deep-Dive](docs/workflow.md) - RPI workflow explained
- [Customization Guide](docs/customization.md) - Adapting for your project
- [For Teams](docs/for-teams.md) - Team adoption patterns
- [Troubleshooting](docs/troubleshooting.md) - Common issues and fixes

## Extensions

Optional modules for specific use cases:

| Extension | Use Case |
|-----------|----------|
| [ui-smoke](.claude/extensions/ui-smoke/) | Browser-based UI verification |
| [data-contracts](.claude/extensions/data-contracts/) | Schema and API governance |
| [team-workflow](.claude/extensions/team-workflow/) | Multi-developer conventions |

See [Extensions Guide](.claude/extensions/README.md) for installation.

## Project Structure

```text
claude-code-rpi-plus/
├── .claude/
│   ├── commands/        # Workflow commands
│   ├── rules/           # Behavioral constraints
│   ├── extensions/      # Optional modules
│   ├── settings.json    # Baseline permissions
│   └── statusline.py    # Custom statusline
├── scripts/
│   ├── validate-artefacts.py
│   └── cc-transcript.*  # Transcript capture
├── docs/                # Documentation
├── templates/           # Project templates
└── install.*            # Installers
```

## Requirements

- Claude Code CLI
- Python 3.8+ (for statusline and scripts)
- Git

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions welcome! Please:
1. Read the workflow documentation first
2. Use the RPI approach for contributions
3. Include tests for new functionality
4. Update documentation as needed

## Acknowledgments

Inspired by best practices in software engineering and the unique challenges of working with AI coding assistants. Started by applying the Portable Context Engineering Schema (PCES) principles and refined with multiple iterations of Claude Code self-improvement under pressure. PCES inspiration credit due to the Langchain/Langgraph teams, Manus team, Latent Space podcast, Simon Willison, et al. CCRPI+ approach was refined through comparison with various flavours of Ralph and Boris Cherny's own usage patterns.
