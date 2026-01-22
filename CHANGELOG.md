# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-22

### Added

- Initial public release
- Core workflow commands:
  - `/create_plan` - Planning with human gates
  - `/implement_plan` - Phase-based implementation
  - `/research_codebase` - Codebase exploration
  - `/phase_complete` - Verification before commit
  - `/gitsync` - Automated commit workflow
  - `/resume_project` - Session restoration
- Behavioral rules:
  - `hard-constraints.md` - Non-negotiable constraints
  - `phase-gates.md` - Checkpoint protocol
  - `command-execution.md` - Shell guidelines
  - `env-handling.md` - Credential safety
  - `diagnostics.md` - Troubleshooting protocol
- Extensions system:
  - `ui-smoke` - Browser-based UI verification
  - `data-contracts` - Schema governance
  - `team-workflow` - Multi-developer patterns
- Cross-platform support:
  - Unix/macOS installer (`install.sh`)
  - Windows installer (`install.ps1`)
  - Python statusline with bash/PowerShell alternatives
- Documentation:
  - Installation guide
  - Configuration reference
  - Workflow deep-dive
  - Customization guide
  - Team adoption patterns
  - Troubleshooting guide
- Scripts:
  - `validate-artefacts.py` - Artefact location validation
  - `cc-transcript.ps1` / `cc-transcript.sh` - Transcript capture
  - `validate-pack.py` - Pack validation for releases

### Notes

- Extracted and generalized from production usage
- Designed for both individual developers and teams
- Extensible architecture for project-specific needs
