# Team Adoption Guide

Patterns for teams adopting Claude Code RPI Plus.

## Team Benefits

- **Consistent workflow**: Everyone follows the same process
- **Knowledge sharing**: Checkpoints document decisions
- **Handoff support**: Work can transfer between developers
- **Quality gates**: Verification at every phase

## Adoption Strategy

### Phase 1: Pilot

1. One developer tries the pack on a feature
2. Document friction points
3. Customize configuration for your stack
4. Share learnings with team

### Phase 2: Team Standards

1. Agree on configuration settings
2. Commit `settings.json` (not `.local` files)
3. Document team-specific customizations
4. Add pack to project setup docs

### Phase 3: Full Adoption

1. All new features use RPI workflow
2. Code review includes checkpoint review
3. CI validates artefact locations
4. Regular retrospectives on workflow

## Configuration for Teams

### What to commit

```text
.claude/
├── settings.json              # Commit: team baseline
├── portable_config.local.example.yaml  # Commit: template
├── commands/                  # Commit: all
├── rules/                     # Commit: all
└── extensions/                # Commit: all
```

### What NOT to commit

```text
.claude/
├── settings.local.json        # Gitignore: personal settings
├── portable_config.local.yaml # Gitignore: local config
```

### Team settings.json

Define baseline permissions everyone needs:

```json
{
  "permissions": {
    "allow": [
      "Bash(python:*)",
      "Bash(pytest:*)",
      "Bash(npm:*)",
      "Bash(git:*)",
      "Skill(create_plan)",
      "Skill(implement_plan)",
      "Skill(research_codebase)",
      "Skill(phase_complete)",
      "Skill(gitsync)",
      "Skill(resume_project)"
    ]
  }
}
```

### Individual overrides

Each developer creates their own `settings.local.json`:

```json
{
  "env": {
    "CLAUDE_CODE_SHELL": "powershell"
  },
  "permissions": {
    "allow": [
      "Bash(C:/Users/me/miniconda3/envs/project/python.exe:*)"
    ]
  }
}
```

## Shared Artefacts

### Plans

- Commit plans to repository
- Reference in PRs
- Review before implementation

### Checkpoints

- Commit checkpoints
- Include in code review
- Use for handoffs

### RESUME.md

- Each developer maintains their own copy locally
- Don't commit (it's working state)
- Share via checkpoints when handing off

## Code Review Integration

### PR checklist addition

```markdown
## Workflow Verification

- [ ] Plan exists and was approved
- [ ] Checkpoints written for completed phases
- [ ] Tests pass at each checkpoint
- [ ] RESUME.md reflects current state
```

### Reviewing checkpoints

Look for:
- Clear acceptance criteria
- All tests passing
- Known issues documented
- Next steps clear

## Handoff Protocol

### When handing off work

1. Complete current phase (don't hand off mid-phase)
2. Write comprehensive checkpoint
3. Update RESUME.md with explicit context
4. Commit with message: `chore: handoff to @developer`
5. Notify incoming developer

### When receiving work

1. Read RESUME.md first
2. Read linked checkpoint
3. Read linked plan
4. Run `/resume_project` to verify understanding
5. Confirm understanding before starting

### Handoff checkpoint extras

Add a handoff section:

```markdown
## Handoff Context

**To**: @incoming-developer
**From**: @outgoing-developer

### Context not in code
- Decision X was made because Y
- Approach Z was tried but failed because...
- Watch out for edge case in module A

### Questions for incoming developer
- Do you have access to service X?
- Familiar with library Y?
```

## Team Extensions

### Install team-workflow extension

```bash
mkdir -p docs/workflow
cp .claude/extensions/team-workflow/*.md docs/workflow/
```

This adds:
- `pr-conventions.md` - PR format standards
- `review-checklist.md` - Review guidelines
- `shared-state.md` - Multi-developer patterns

### Customize for your team

Edit the copied files in `docs/workflow/` to match your:
- PR conventions
- Review standards
- Communication patterns

## Common Team Patterns

### Feature branches

```text
main
├── feature/auth      (developer A)
├── feature/search    (developer B)
└── feature/checkout  (developer C)
```

Each feature has its own plans and checkpoints.

### Parallel work on same feature

```text
feature/large-feature
├── phase-1-2 (developer A, backend)
└── phase-3-4 (developer B, frontend)
```

Requires:
- Clear interface contracts
- Frequent sync
- Clean handoff at phase boundaries

### Shared infrastructure changes

When changes affect multiple features:
1. Create separate infrastructure plan
2. Complete infrastructure first
3. Features rebase on infrastructure
4. Don't mix infrastructure and feature work

## Measuring Success

### Metrics to track

- Time to first commit (does planning help?)
- Checkpoint completion rate
- Handoff success rate
- Bugs caught at phase gates

### Signs it's working

- Fewer "what was I doing?" moments
- Smoother handoffs between developers
- Better PR descriptions
- More consistent code quality

### Signs of trouble

- Skipping checkpoints
- Empty or boilerplate plans
- RESUME.md always out of date
- Friction complaints

### Addressing friction

Regular retrospectives:
- What's working?
- What's frustrating?
- What can we simplify?
- What rules can we relax?

Adapt the pack to your team, not your team to the pack.
