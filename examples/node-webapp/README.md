# Node.js Web App Example

Example with UI smoke testing enabled for a web application.

## Project Structure

```text
node-webapp/
├── .claude/                  # RPI Plus pack
├── docs/
│   ├── plans/
│   ├── research/
│   ├── state/
│   └── verification/
│       └── ui/              # UI smoke screenshots
├── scripts/
│   └── validate-artefacts.py
├── src/
│   └── index.js             # Express server
├── ui/
│   ├── index.html           # Frontend
│   └── app.js
├── tests/
│   └── app.test.js
├── CLAUDE.md
└── package.json
```

## Configuration

`portable_config.local.yaml`:
```yaml
project:
  name: "NodeWebApp"

paths:
  python: "python"            # Still needed for statusline

tests:
  command: "npm test"

ui:
  enabled: true
  root: "ui/"
  url: "http://localhost:3000"
  dev_command: "npm run dev"

artefacts:
  plans_dir: "docs/plans/"
  research_dir: "docs/research/"
  state_dir: "docs/state/"
  verification_dir: "docs/verification/"
```

## Settings

`settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "Skill(ui_smoke)"
    ]
  }
}
```

## Usage

1. Install the RPI Plus pack
2. Install the ui-smoke extension
3. Configure settings as shown above
4. Start Claude Code with Chrome: `claude --chrome`
5. Start dev server: `npm run dev`
6. Run UI smoke: `/ui_smoke`

## UI Smoke Workflow

When you modify UI files:

```text
# Phase gate will detect UI changes
/phase_complete

# If Chrome connected, runs UI smoke automatically
# If Chrome not connected, blocks with instructions
```

Screenshots saved to `docs/verification/ui/YYYYMMDD/`
