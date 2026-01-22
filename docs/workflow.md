# Workflow Deep-Dive

Understanding the Research-Plan-Implement (RPI) workflow.

## The Problem This Solves

AI coding assistants are powerful but can:
- Start coding without understanding context
- Make changes that conflict with existing patterns
- Lose track of multi-step implementations
- Forget context after session resets

The RPI workflow adds structure to prevent these issues.

## The Three Phases

### 1. Research Phase

**Purpose**: Understand before changing

**Command**: `/research_codebase`

**What happens**:
1. Explore existing code structure
2. Read specifications and documentation
3. Identify patterns and conventions
4. Document findings in research file
5. Update RESUME.md with research link

**When to use**:
- Starting work on unfamiliar code
- Before proposing changes
- When investigating bugs
- To understand dependencies

**Output**: Research document in `docs/research/`

### 2. Plan Phase

**Purpose**: Design before coding

**Command**: `/create_plan`

**What happens**:
1. Define current state and desired end state
2. Identify non-goals
3. Break work into phases
4. Include verification steps
5. Request human approval

**When to use**:
- New features
- Significant refactors
- Complex bug fixes
- Architectural changes

**Output**: Plan document in `docs/plans/`

**Human gate**: Plan requires explicit approval before implementation.

### 3. Implement Phase

**Purpose**: Execute with verification

**Command**: `/implement_plan`

**What happens**:
1. Execute one phase at a time
2. Run tests after each phase
3. Write checkpoint
4. Update RESUME.md
5. Pause for human review

**Phase Gate** (after each phase):
- Run tests
- Run artefact validator
- Check UI if enabled
- Write checkpoint
- Await approval

**Output**:
- Code changes
- Checkpoints in `docs/state/`
- Updated RESUME.md

## The Checkpoint System

### What is a checkpoint?

A snapshot of phase completion:
- What was accomplished
- Test results
- Known issues
- Next steps

### Checkpoint structure

```markdown
# Phase 2.1 Checkpoint

**Status**: Complete
**Date**: 2026-01-22

## Summary
- Implemented user authentication
- Added session management
- Created login/logout endpoints

## Verification Summary
| Check | Result | Detail |
|-------|--------|--------|
| Tests | PASS | 45 passed, 0 failed |
| Validator | PASS | All artefacts in place |
| UI Smoke | SKIP | No UI changes |

## Next Phase
Phase 2.2: Add password reset flow
```

### Why checkpoints matter

1. **Context preservation**: Survive session resets
2. **Handoff support**: Others can pick up work
3. **Progress tracking**: Clear record of completion
4. **Verification evidence**: Tests passed at each stage

## RESUME.md

### Purpose

Single file that captures current state:
- Which plan is active
- Latest checkpoint
- Git position
- Immediate next actions

### Structure

```markdown
# RESUME

- Plan: docs/plans/auth_implementation.md
- Latest checkpoint: docs/state/phase_2.1_checkpoint.md
- Git: feature/auth @ abc1234
- Next actions:
  - Implement password reset endpoint
  - Add email service integration
- Verify: /phase_complete
```

### When it's updated

- After each phase completion
- After research completion
- After any significant milestone

### Using /resume_project

Start a new session:

```text
/resume_project
```

Output:
```text
Plan: auth_implementation - Phase 2 of 4
Status: Phase 2.1 complete
Git: feature/auth @ abc1234 (matches)
Next: Implement password reset endpoint
Issues: None
```

## Verification Commands

### /phase_complete

Standalone verification for any point in development:

```text
/phase_complete
```

Checks:
1. Git status (clean/dirty)
2. Tests pass
3. Artefacts in correct locations
4. UI verification (if enabled)

Use when:
- Before committing
- To verify current state
- After making changes
- Before starting new work

### /gitsync

Commit workflow with checks:

```text
/gitsync
```

Steps:
1. Run tests (abort if fail)
2. Review changes
3. Check CI status
4. Stage and commit
5. Push

## Workflow Patterns

### Feature Development

```text
1. /research_codebase         # Understand current state
2. /create_plan               # Design the feature
3. [Human approves plan]
4. /implement_plan            # Execute phase 1
5. [Human reviews checkpoint]
6. /implement_plan            # Execute phase 2
   ...
7. /gitsync                   # Commit when complete
```

### Bug Fix

```text
1. /research_codebase         # Investigate the bug
2. [Fix is obvious]           # Skip planning for simple fixes
3. [Make fix]
4. /phase_complete            # Verify fix
5. /gitsync                   # Commit
```

### Complex Bug Fix

```text
1. /research_codebase         # Deep investigation
2. /create_plan               # Plan the fix (multiple steps)
3. /implement_plan            # Execute with checkpoints
4. /gitsync
```

### Resuming Work

```text
1. /resume_project            # See current state
2. [Continue from checkpoint]
3. /implement_plan            # Pick up where left off
```

## Best Practices

### Do

- Run `/research_codebase` before unfamiliar code
- Plan features before implementing
- Complete phases fully before moving on
- Update RESUME.md at every milestone
- Run `/phase_complete` before committing

### Don't

- Skip research for "simple" changes that aren't
- Start implementing without a plan
- Leave checkpoints incomplete
- Forget to update RESUME.md
- Commit without verification
