# LazyODD Implementation Plan

## Overview

Build a Claude Code plugin with 4 skills and supporting reference files.

```
lazyodd/
├── .claude-plugin/
│   └── plugin.json                  # Task 1 (trivial)
├── skills/
│   ├── interview/
│   │   ├── SKILL.md                 # Task 2 (large — core interview logic)
│   │   ├── odd-protocol-ref.md      # Task 6 (shared — bundled per skill)
│   │   └── odd-guidance-ref.md      # Task 6 (shared — bundled per skill)
│   ├── plan/
│   │   └── SKILL.md                 # Task 3 (medium — plan generation)
│   ├── draft/
│   │   ├── SKILL.md                 # Task 4 (large — ODD generation)
│   │   ├── odd-protocol-ref.md      # Task 6 (shared)
│   │   └── odd-guidance-ref.md      # Task 6 (shared)
│   └── check/
│       ├── SKILL.md                 # Task 5 (large — verification)
│       ├── odd-protocol-ref.md      # Task 6 (shared)
│       └── odd-guidance-ref.md      # Task 6 (shared)
└── .devcontext/                     # Original source files (already exists)
```

## Architecture Decisions (from plugin docs research)

### Why `skills/`
Skills are the standard way to extend Claude Code plugins. They support:
- Supporting files alongside SKILL.md (our reference docs)
- `${CLAUDE_SKILL_DIR}` variable for portable file references
- `disable-model-invocation: true` to prevent auto-triggering
- `allowed-tools` for per-phase tool restrictions
- `$ARGUMENTS` for passing model paths

### Reference File Strategy
The docs recommend keeping SKILL.md under 500 lines and using supporting files for reference material. Strategy:

- Each skill that needs ODD reference gets its own copy of `odd-protocol-ref.md` and `odd-guidance-ref.md` (bundled per skill because plugin caching copies to `~/.claude/plugins/cache` — symlinks work but separate copies are simpler)
- SKILL.md references these files explicitly: "Read `${CLAUDE_SKILL_DIR}/odd-protocol-ref.md` for the full ODD+2 structure"
- The `plan/` skill does NOT need reference files — it reads `research/findings.md` which already contains structured ODD knowledge

### Frontmatter Configuration

All 4 skills use:
```yaml
---
name: <name>
description: <description>
disable-model-invocation: true
---
```

`disable-model-invocation: true` because these are deliberate workflow phases, not auto-triggered behaviors.

## Task Breakdown

### Task 1: Plugin Manifest
**File**: `.claude-plugin/plugin.json`
**Effort**: Trivial

```json
{
  "name": "lazyodd",
  "description": "Generate complete ODD+2 protocol documents from agent-based model code and documentation",
  "version": "0.1.0",
  "author": {
    "name": "ASU Works"
  }
}
```

### Task 2: `/lazyodd:interview` skill
**File**: `skills/interview/SKILL.md`
**Effort**: Large (biggest prompt — sets the tone for everything)
**Frontmatter**: `disable-model-invocation: true`, `argument-hint: [path/to/model/files]`
**Sections**:
1. Role definition — ODD documentation expert conducting HITL research
2. Instruction to read `${CLAUDE_SKILL_DIR}/odd-protocol-ref.md` and `${CLAUDE_SKILL_DIR}/odd-guidance-ref.md`
3. Phase 1: File inventory — scan all model files (use `$ARGUMENTS` if path provided), assess input quality
4. Phase 2: Complexity assessment — count entity types, submodels, spatial structure
5. Phase 3: Adaptive interview — question strategy based on input quality assessment
6. Phase 4: ODD configurability — determine strict/extended/summary format
7. Interview question bank — organized by ODD element, with probing sub-questions
8. Output specification — `research/findings.md` and `research/interview-log.md` templates
9. Quality rules: never invent, never skip, always cite, always ask when uncertain

**Key challenge**: The interview question bank must be comprehensive enough to cover all 7 elements and 11 design concepts, but adaptive enough to skip irrelevant questions based on model type.

### Task 3: `/lazyodd:plan` skill
**File**: `skills/plan/SKILL.md`
**Effort**: Medium
**Frontmatter**: `disable-model-invocation: true`
**No supporting files** — reads research artifacts instead
**Sections**:
1. Role definition — prompt architect transforming research into executable plan
2. Input reading — read `research/findings.md` and `research/interview-log.md`
3. Plan structure template — what the mega-prompt must contain
4. Sub-agent delegation logic — rules for when to prescribe sub-agents
5. Progressive disclosure strategy — how to structure the plan for large models
6. Quality standards injection — confidence categories, citation format, precision requirements
7. Output specification — `plan/odd-generation-plan.md` template

**Key challenge**: The plan must be self-contained — a fresh agent with zero prior context must be able to execute it. All knowledge from research must be encoded in the plan.

**Note**: This skill does NOT bundle ODD reference files. It reads the research artifacts which already contain structured findings. The plan itself will instruct the draft agent to read its own bundled reference files.

### Task 4: `/lazyodd:draft` skill
**File**: `skills/draft/SKILL.md`
**Effort**: Large
**Frontmatter**: `disable-model-invocation: true`
**Supporting files**: `odd-protocol-ref.md`, `odd-guidance-ref.md`
**Sections**:
1. Role definition — ODD technical writer executing a generation plan
2. Instruction to read `${CLAUDE_SKILL_DIR}/odd-protocol-ref.md` and `${CLAUDE_SKILL_DIR}/odd-guidance-ref.md`
3. Input reading — read `plan/odd-generation-plan.md`, then read all source files specified in plan
4. Execution protocol — follow plan structure exactly, section by section
5. Writing standards — precision requirements, terminological fidelity rules
6. Citation protocol — inline citation format, confidence category definitions
7. Traceability matrix generation — companion document specification
8. ODD document template — complete section structure with guidance per element
9. Output specification — `draft/odd.md` and `draft/traceability-matrix.md`

**Key challenge**: The draft agent must balance following the plan (model-specific knowledge) with following the ODD standard (protocol requirements). Plan takes precedence for content; standard takes precedence for structure.

### Task 5: `/lazyodd:check` skill
**File**: `skills/check/SKILL.md`
**Effort**: Large
**Frontmatter**: `disable-model-invocation: true`, `allowed-tools: Read, Grep, Glob, Write`
**Supporting files**: `odd-protocol-ref.md`, `odd-guidance-ref.md`
**Sections**:
1. Role definition — independent ODD verifier (does NOT see the generation plan)
2. Instruction to read `${CLAUDE_SKILL_DIR}/odd-protocol-ref.md` and `${CLAUDE_SKILL_DIR}/odd-guidance-ref.md`
3. Input reading — read `draft/odd.md`, `draft/traceability-matrix.md`, and all model source files
4. Verification checks A-F — detailed check procedures for each category
5. Scoring rubric — 4 dimensions × 7 elements, 1-5 scale with anchor descriptions
6. Issue classification — critical/major/minor severity definitions
7. Reimplementability test — specific questions to ask per section
8. Output specification — `checked/verification-report.md` template

**Key challenge**: Verification must be truly independent — the agent checks the ODD against sources and the ODD standard, not against the generation plan.

**Note**: `allowed-tools` restricts to read-only + Write (for the report). No Edit/Bash — the verifier should not modify the ODD.

### Task 6: Reference Files
**Files**: `odd-protocol-ref.md` and `odd-guidance-ref.md` (copied into 3 skill directories)
**Effort**: Medium
**Strategy**:
- Source from `.devcontext/ODD_Protocol_Second_Update_Grimm_et_al_2020.md` and `.devcontext/ODD Guidance and Checklists.md`
- May need light editing to optimize as reference material (remove paper-specific prose, keep structure + checklists)
- Or copy verbatim if the originals are clean enough
- Copy into `skills/interview/`, `skills/draft/`, `skills/check/`

## Implementation Order

```
Task 6 (reference files)  →  Task 1 (manifest)  →  Task 2 (interview)  →  Task 3 (plan)  →  Task 4 (draft)  →  Task 5 (check)
```

Task 6 first because the SKILL.md files reference these files — easier to write instructions when you know the reference content.

Tasks 2-5 must be sequential because:
- Task 2 defines the research output format that Task 3 reads
- Task 3 defines the plan format that Task 4 reads
- Task 4 defines the ODD output format that Task 5 verifies

## Testing Strategy

After building each skill, test with a known simple model:

1. **After Task 2**: Run `/lazyodd:interview` against a simple model (e.g., Schelling segregation). Verify it produces well-structured `research/findings.md`.
2. **After Task 3**: Run `/lazyodd:plan` on the research output. Verify the mega-prompt is self-contained and comprehensive.
3. **After Task 4**: Run `/lazyodd:draft` with the plan. Verify ODD structure, citations, and confidence annotations.
4. **After Task 5**: Run `/lazyodd:check` on the draft. Verify the rubric scoring and issue identification.

Test: `claude --plugin-dir ./lazyodd` then `/lazyodd:interview`

## Reference Documentation

Implementation agents should consult these docs for correct plugin/skill format:

| Topic | URL |
|-------|-----|
| Creating plugins | https://code.claude.com/docs/en/plugins |
| Plugin reference (manifest schema, directory structure, debugging) | https://code.claude.com/docs/en/plugins-reference |
| Skills (SKILL.md format, frontmatter, supporting files, invocation) | https://code.claude.com/docs/en/skills |
| Subagents | https://code.claude.com/docs/en/sub-agents |
| Hooks | https://code.claude.com/docs/en/hooks |
| Plugin marketplaces | https://code.claude.com/docs/en/plugin-marketplaces |
| Full docs index | https://code.claude.com/docs/llms.txt |

## Resolved Implementation Details

1. **$ARGUMENTS handling**: The `interview` skill accepts optional path to model files via `$ARGUMENTS`. Other skills don't need arguments — they read from fixed phase directories.
2. **Directory creation**: Skills should create their output directories (`research/`, `plan/`, `draft/`, `checked/`) automatically if they don't exist.
3. **Overwrite protection**: Skills should warn if output files already exist and ask before overwriting.
