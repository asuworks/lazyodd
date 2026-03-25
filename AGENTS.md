# lazyodd

A set of Agent Skills for generating complete ODD+2 protocol documents from agent-based model code and documentation.

## Skills

Six skills that form a sequential workflow. Each skill is a separate session with human review between phases:

| Order | Skill | Purpose | Inputs | Outputs |
|-------|-------|---------|--------|---------|
| 1 | `odd-interview` | Research + modeler interview | Model code and docs | `lazyodd/research/findings.md`, `lazyodd/research/interview-log.md` |
| 2 | `odd-plan` | Create standalone generation instructions | Research artifacts | `lazyodd/plan/odd-generation-plan.md` |
| 3 | `odd-draft` | Execute the plan to produce the ODD | Plan + source files | `lazyodd/draft/odd.md`, `lazyodd/draft/traceability-matrix.md` |
| 4 | `odd-check` | Independently verify the ODD | Draft + source files | `lazyodd/checked/verification-report.md` |
| 5 | `odd-feedback` | Collect scientist feedback | Completed workflow | `lazyodd/feedback/{datetime}.md` |
| 6 | `odd-integrate-feedback` | Plan plugin improvements | Feedback reports | `lazyodd/suggested-changes/{datetime}.md` |

## Workflow

```
/odd-interview → review → /odd-plan → review → /odd-draft → review → /odd-check → review → /odd-feedback
```

Human checkpoints between phases are intentional. Review artifacts before proceeding.

## Requirements

- **odd-interview, odd-feedback, odd-integrate-feedback**: Need structured user interaction (multiple-choice questions)
- **odd-check**: Read-only verification — should not modify the ODD draft
- **All skills**: Need file reading and writing capabilities

## Key Design Decisions

- **Source-based confidence**: Every claim tagged with `CODE_VERIFIED`, `DOC_STATED`, `MODELER_CONFIRMED`, `INFERRED`, or `UNVERIFIABLE`
- **Dual traceability**: Inline citations + companion traceability matrix
- **Independent verification**: The check skill does NOT see the generation plan
- **Reimplementability**: The quality bar is "could someone rebuild this model from the ODD alone?"
