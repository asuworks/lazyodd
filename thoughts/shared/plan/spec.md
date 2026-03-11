# lazyodd — ODD Protocol Generation Plugin

## Executive Summary

A Claude Code plugin that generates complete ODD+2 protocol documents from agent-based model code and documentation through a 4-phase, human-in-the-loop workflow optimized for preservation of author's intent, scientific precision, and completeness.

## Problem Statement

ODD (Overview, Design concepts, and Details) protocol documentation for agent-based models is labor-intensive, often incomplete, and prone to inconsistency between what's described and what's actually implemented. Common failure modes:

- **Shallow documentation**: Prose descriptions that can't be reimplemented
- **Hallucinated mechanisms**: AI-generated descriptions that invent behaviors not in the model
- **Lost rationale**: Why design choices were made is rarely captured
- **Terminological drift**: Domain terms paraphrased into incorrect alternatives
- **Missing sections**: ODD elements skipped or superficially covered
- **No traceability**: Claims can't be traced back to code or documentation

This plugin provides a structured, AI-assisted workflow that addresses all of these through human-in-the-loop interviews, source-based confidence tracking, and post-generation verification.

## Success Criteria

1. Generated ODD is **structurally complete** — all 7 ODD elements and all 11 design concepts present
2. Every claim **traces to a source** — code location, document reference, or modeler statement
3. A modeler who didn't write the code could **reimplement the model** from the ODD alone
4. **Confidence categories** clearly indicate the evidentiary basis for each claim
5. Verification report identifies specific issues with **actionable fix instructions**
6. **Author's intent preserved** — design rationale captured, no hallucinated mechanisms, exact terminology used

## User Personas

| Persona | Goal | Technical Level |
|---------|------|-----------------|
| **Model Developer** | Better documentation of their own model | High — wrote the code |
| **Reimplementer** | Precise description to rebuild the model | High — needs exact specs |
| **Reviewer/Auditor** | Evaluate model validity for publication | Variable — needs clarity |

## User Journey

Four phases, each a separate Claude Code session:

```
/lazyodd:interview  →  research/  →  /lazyodd:plan  →  plan/  →  /lazyodd:draft  →  draft/  →  /lazyodd:check  →  checked/
     (HITL)              artifacts      (autonomous)       artifacts   (autonomous)      artifacts   (autonomous)       artifacts
```

Human checkpoints between each phase are intentional — the user reviews artifacts before proceeding.

---

## Phase 1: `/lazyodd:interview` (RESEARCH)

### Purpose
Review all available model files and conduct an adaptive interview with the modeler to gather complete information for ODD generation.

### Inputs
- Model code (any language — language agnostic)
- Documentation files (papers, READMEs, supplementary materials, code comments)
- Modeler (human, present for interactive Q&A)

### Adaptive Interview Strategy

The interview approach adapts based on input quality and model complexity:

| Input Quality | Strategy |
|---------------|----------|
| **Code + comprehensive docs** | Gap-driven — only ask about what's unclear |
| **Code + minimal docs** | Conceptual-first — establish purpose/narrative, then verify against code |
| **Docs only (no code)** | Deep interrogation — probe for precise process logic, parameters, scheduling |
| **Code only (no docs)** | Reverse-engineer — present code understanding for modeler confirmation |

The agent should:
1. First scan all available files to assess input quality
2. Determine model complexity (number of entity types, submodels, spatial structure, stochasticity)
3. Select interview strategy based on assessment
4. Walk through information needs organized by ODD element
5. Use AskUserQuestion for structured choices, free-form for open-ended

### Interview Priorities (hardest ODD elements)
- **Element 3 (Process overview and scheduling)**: Execution order must match code exactly
- **Element 4 (Design concepts)**: All 11 sub-concepts must be addressed with rationale
- **Element 7 (Submodels)**: Requires pseudocode or equations, not prose

### ODD Configurability
During the interview, the agent determines the appropriate ODD format:
- **Strict ODD+2**: Follow Grimm et al. 2020 exactly
- **ODD+2 with extensions**: Standard sections + additional metadata (design rationale, uncertainty sections)
- **Summary ODD**: Abbreviated version for journal article body (full version as supplement)

This decision is based on the modeler's stated needs (publication target, documentation purpose).

### Output → `research/`

**`research/findings.md`** — Structured by ODD element:

```markdown
# ODD Research Findings

## Model Overview
- Name: [model name]
- Authors: [authors]
- Purpose: [1-2 sentence summary]
- Input Sources: [list of files reviewed]
- Input Quality Assessment: [code+docs / code-only / docs-only]
- Model Complexity: [simple / moderate / complex]
- ODD Format Decision: [strict / extended / summary]

## Element 1: Purpose and Patterns
### Findings
[what was learned]
### Sources
[specific file:line or document:page references]
### Confidence
[CODE_VERIFIED / DOC_STATED / MODELER_CONFIRMED / INFERRED / UNVERIFIABLE]
### Open Questions
[anything still unclear]

## Element 2: Entities, State Variables, and Scales
[same structure]

## Element 3: Process Overview and Scheduling
[same structure]

## Element 4: Design Concepts
### 4.1 Basic principles
### 4.2 Emergence
### 4.3 Adaptation
### 4.4 Objectives
### 4.5 Learning
### 4.6 Prediction
### 4.7 Sensing
### 4.8 Interaction
### 4.9 Stochasticity
### 4.10 Collectives
### 4.11 Observation
[each with findings, sources, confidence, open questions]

## Element 5: Initialization
[same structure]

## Element 6: Input Data
[same structure]

## Element 7: Submodels
### Submodel: [name]
[for each identified submodel: findings, sources, confidence, open questions]
```

**`research/interview-log.md`** — Chronological record of all questions asked and modeler's responses, preserving exact wording for author's intent.

---

## Phase 2: `/lazyodd:plan` (PLAN)

### Purpose
Transform research findings into a standalone, self-contained mega-prompt that a fresh agent can execute to generate the full ODD without access to the original conversation context.

### Inputs
- `research/findings.md`
- `research/interview-log.md`
- ODD+2 protocol specification (embedded from .devcontext/)
- ODD Guidance and Checklists (embedded from .devcontext/)

### Plan Design Principles

The plan must:
1. **Be self-contained**: A fresh agent with no prior context can execute it
2. **Embed all gathered knowledge**: Every finding from RESEARCH phase injected into the plan
3. **Specify ODD structure explicitly**: All 7 elements, all 11 design concepts enumerated as sections
4. **Include quality standards**: Reimplementability bar, confidence annotation requirements, citation format
5. **Prescribe sub-agent delegation** (if appropriate): For complex models, specify which sections need specialist sub-agents and what tools they should use
6. **Include the traceability requirement**: Every claim must cite its source
7. **Specify pseudocode/math requirements**: Submodels must include formal process descriptions, not just prose

### Sub-agent Delegation Guidance

The plan determines sub-agent needs based on model complexity:

| Complexity | Delegation Strategy |
|------------|-------------------|
| **Simple** (1-3 entity types) | Single agent handles entire ODD |
| **Moderate** (3-10 entity types) | Main agent + code analysis sub-agent for Element 7 |
| **Complex** (10+ submodels) | Main agent coordinates: code analyzer for submodels, domain specialist for design concepts, writer for prose |

### Output → `plan/`

**`plan/odd-generation-plan.md`** — The mega-prompt. This is a complete, executable instruction set structured as:

```markdown
# ODD Generation Plan for [Model Name]

## Context
[Model summary, complexity assessment, ODD format choice]

## Source Materials
[List of all files the drafting agent should read]

## Knowledge Base
[All findings from research, organized by ODD element — this is the bulk of the plan]

## ODD Structure Requirements
[Exact sections to produce, with specific instructions per section]

## Quality Standards
- Reimplementability: [specific bar]
- Confidence annotations: [format specification]
- Citation format: [inline + traceability matrix spec]
- Mathematical precision: [equations/pseudocode requirements]
- Terminological fidelity: [exact terms to use, terms to avoid]

## Sub-agent Instructions
[If applicable: what sub-agents to spawn, their tasks, their tools]

## Output Specifications
- Primary output: draft/odd.md
- Traceability matrix: draft/traceability-matrix.md
- Format: Markdown with inline citations
```

---

## Phase 3: `/lazyodd:draft` (IMPLEMENT)

### Purpose
Execute the generation plan to produce the full ODD document and traceability matrix.

### Inputs
- `plan/odd-generation-plan.md` (the mega-prompt)
- Model source files (code and docs — for direct reference during drafting)
- ODD+2 protocol specification (embedded from .devcontext/)

### Execution

The drafting agent:
1. Reads the generation plan completely
2. Reads all source materials specified in the plan
3. Follows the plan's structure requirements exactly
4. Generates each ODD element with:
   - Precise technical content (equations, pseudocode where specified)
   - Inline source citations: `[source: file.py:42]` or `[source: paper.pdf, p.7]` or `[source: modeler interview, Q12]`
   - Confidence annotations per claim: `{CODE_VERIFIED}`, `{DOC_STATED}`, `{MODELER_CONFIRMED}`, `{INFERRED}`, `{UNVERIFIABLE}`
5. Spawns sub-agents if instructed by the plan
6. Produces the traceability matrix as a companion document

### Confidence Categories

| Category | Meaning | Evidence Standard |
|----------|---------|-------------------|
| `CODE_VERIFIED` | Claim verified by reading actual code | Specific file:line reference |
| `DOC_STATED` | Explicitly stated in documentation | Specific document:page/section reference |
| `MODELER_CONFIRMED` | Confirmed by modeler during interview | Interview log question reference |
| `INFERRED` | Reasonably inferred but not explicitly stated | Inference chain documented |
| `UNVERIFIABLE` | Cannot be verified from available sources | Reason for unverifiability stated |

### Output → `draft/`

**`draft/odd.md`** — The complete ODD document following ODD+2 structure:

```markdown
# ODD Protocol: [Model Name]

> Generated by lazyodd | Date: [date]
> ODD Format: [strict ODD+2 / extended / summary]
> Input Sources: [list]
> Confidence Legend: CODE_VERIFIED | DOC_STATED | MODELER_CONFIRMED | INFERRED | UNVERIFIABLE

## 1. Purpose and Patterns
[content with inline citations and confidence annotations]

## 2. Entities, State Variables, and Scales
[content]

## 3. Process Overview and Scheduling
[content — with precise execution order]

## 4. Design Concepts
### 4.1 Basic principles
### 4.2 Emergence
### 4.3 Adaptation
### 4.4 Objectives
### 4.5 Learning
### 4.6 Prediction
### 4.7 Sensing
### 4.8 Interaction
### 4.9 Stochasticity
### 4.10 Collectives
### 4.11 Observation

## 5. Initialization
[content]

## 6. Input Data
[content]

## 7. Submodels
### 7.1 [Submodel Name]
[pseudocode/equations + prose description]
[for each submodel]

## References
[cited sources]
```

**`draft/traceability-matrix.md`** — Maps every ODD claim to its source:

```markdown
# Traceability Matrix: [Model Name]

| ODD Section | Claim | Source | Confidence | Notes |
|-------------|-------|--------|------------|-------|
| 1. Purpose | Model simulates X | paper.pdf, p.3 | DOC_STATED | |
| 2. Entities | Agent has energy attribute | model.py:42 | CODE_VERIFIED | |
| 3. Scheduling | Movement before feeding | model.py:87-92 | CODE_VERIFIED | |
| 4.2 Emergence | Population cycles emerge | interview Q5 | MODELER_CONFIRMED | |
| 7.1 Movement | See pseudocode | model.py:100-120 | CODE_VERIFIED | |
```

---

## Phase 4: `/lazyodd:check` (VERIFY)

### Purpose
Independently verify the generated ODD against the source materials and ODD+2 requirements, producing a scored assessment with actionable recommendations.

### Inputs
- `draft/odd.md`
- `draft/traceability-matrix.md`
- `research/findings.md` (to cross-check against original research)
- Model source files (code and docs — for independent verification)
- ODD+2 protocol specification (embedded from .devcontext/)
- ODD Guidance and Checklists (embedded from .devcontext/)

### Verification Checks

#### A. Structural Completeness
- All 7 ODD elements present
- All 11 design concepts addressed (even if "not applicable" — must be stated)
- No empty or placeholder sections

#### B. Source Traceability
- Every factual claim has an inline citation
- Citations are valid (referenced files/lines exist)
- Traceability matrix is complete and consistent with inline citations
- No orphaned claims (claims without sources)

#### C. Semantic Consistency
- No contradictions between sections (e.g., Element 2 lists entities not mentioned in Element 7)
- Terminology used consistently throughout
- Parameter names match between sections
- Process order in Element 3 consistent with submodel descriptions in Element 7

#### D. Code Alignment (when code is available)
- Process descriptions in Element 3 match actual code execution order
- Submodel equations/pseudocode in Element 7 match code logic
- Entity state variables in Element 2 match code data structures
- Initialization values in Element 5 match code defaults

#### E. Reimplementability Assessment
- Could a competent modeler rebuild this model from the ODD alone?
- Are all parameters specified with values or ranges?
- Are all decision rules precisely defined (not "agents decide based on...")?
- Are boundary conditions and edge cases addressed?

#### F. Confidence Audit
- Are confidence categories used appropriately?
- Are INFERRED claims reasonable?
- Are UNVERIFIABLE claims truly unverifiable?
- Is the distribution of confidence categories reasonable for the input quality?

### Scoring Rubric

Each ODD element scored on 4 dimensions (1-5 scale):

| Dimension | 1 (Poor) | 3 (Adequate) | 5 (Excellent) |
|-----------|----------|--------------|----------------|
| **Completeness** | Major gaps | All required topics present | Comprehensive with nuance |
| **Precision** | Vague prose | Specific but some ambiguity | Pseudocode/equations, unambiguous |
| **Traceability** | No sources | Most claims sourced | Every claim traced with confidence |
| **Consistency** | Contradictions found | Minor inconsistencies | Fully internally consistent |

### Output → `checked/`

**`checked/verification-report.md`**:

```markdown
# ODD Verification Report: [Model Name]

> Verified by lazyodd:check | Date: [date]
> ODD Document: draft/odd.md
> Overall Grade: [A/B/C/D/F]

## Summary
[2-3 sentence overall assessment]

## Scores by Element

| Element | Completeness | Precision | Traceability | Consistency | Overall |
|---------|-------------|-----------|--------------|-------------|---------|
| 1. Purpose | 4 | 5 | 4 | 5 | 4.5 |
| 2. Entities | 3 | 4 | 5 | 4 | 4.0 |
| ... | ... | ... | ... | ... | ... |
| **Average** | | | | | **X.X** |

## Issues Found

### Critical (must fix)
1. **[Element X]: [Issue title]**
   - Problem: [description]
   - Evidence: [what was found]
   - Fix: [specific instruction]

### Major (should fix)
1. ...

### Minor (nice to fix)
1. ...

## Verification Details

### A. Structural Completeness: [PASS/FAIL]
[details]

### B. Source Traceability: [PASS/FAIL]
[details]

### C. Semantic Consistency: [PASS/FAIL]
[details]

### D. Code Alignment: [PASS/FAIL or N/A]
[details]

### E. Reimplementability: [PASS/FAIL]
[details]

### F. Confidence Audit: [PASS/FAIL]
[details]

## Recommendations
[prioritized list of improvements]
```

---

## Technical Architecture

### Plugin Structure

```
lazyodd/
├── .claude-plugin/
│   └── plugin.json                  # Plugin manifest
├── skills/
│   ├── interview/
│   │   ├── SKILL.md                 # /lazyodd:interview
│   │   ├── odd-protocol-ref.md      # Full ODD+2 protocol (bundled)
│   │   └── odd-guidance-ref.md      # Full guidance & checklists (bundled)
│   ├── plan/
│   │   └── SKILL.md                 # /lazyodd:plan (no ref files — reads research/)
│   ├── draft/
│   │   ├── SKILL.md                 # /lazyodd:draft
│   │   ├── odd-protocol-ref.md      # Full ODD+2 protocol (bundled)
│   │   └── odd-guidance-ref.md      # Full guidance & checklists (bundled)
│   └── check/
│       ├── SKILL.md                 # /lazyodd:check
│       ├── odd-protocol-ref.md      # Full ODD+2 protocol (bundled)
│       └── odd-guidance-ref.md      # Full guidance & checklists (bundled)
├── .devcontext/                     # Original source files
│   ├── ODD_Protocol_Second_Update_Grimm_et_al_2020.md
│   ├── ODD Guidance and Checklists.md
│   └── prompt_hierarchy_framework.md
└── README.md
```

Skills support supporting files, `${CLAUDE_SKILL_DIR}` variable, `disable-model-invocation`, and `allowed-tools` restrictions.


### Phase Artifacts (created in user's model repo)

```
<model-repo>/
├── research/
│   ├── findings.md              # Structured by ODD element
│   └── interview-log.md         # Record of modeler Q&A
├── plan/
│   └── odd-generation-plan.md   # Standalone mega-prompt
├── draft/
│   ├── odd.md                   # Full ODD document
│   └── traceability-matrix.md   # Source mapping
└── checked/
    └── verification-report.md   # Scored rubric + recommendations
```

### Handoff Protocol

All phase transitions use markdown files:
- Each phase reads from the previous phase's directory
- Each phase writes to its own directory
- No shared state beyond the file system
- Human reviews artifacts between phases

### Plugin Manifest

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

---

## Input Handling

### Variable Input Quality

| Available Inputs | Agent Behavior |
|-----------------|----------------|
| **Code + comprehensive docs** | Extract from both, cross-validate, minimal interview |
| **Code + minimal docs** | Heavy code analysis, interview for purpose/rationale |
| **Code only** | Reverse-engineer structure, extensive interview needed |
| **Docs only** | Extract from docs, interview for precision/formalization |

### Language Agnostic Code Analysis

The system handles model code in any language by:
1. Using the agent's general code comprehension (no language-specific parsers)
2. Focusing on structure: entity definitions, process scheduling, state updates, parameters
3. Asking the modeler to clarify language-specific idioms if needed

---

## Scientific Precision Requirements

### Mathematical Exactness
- Equations must be extracted precisely (LaTeX notation in markdown)
- Parameters must include names, symbols, units, default values, and ranges
- Stochastic elements must specify distributions and parameters

### Terminological Fidelity
- Use exact terms from the model's domain (ecology, economics, sociology, etc.)
- Never paraphrase technical concepts into simpler language
- If the modeler uses a specific term, use that term throughout

### Behavioral Accuracy
- Process descriptions must match actual code behavior
- Execution order must match code scheduling
- Decision rules must reflect actual implemented logic

### Uncertainty Quantification
- Every claim annotated with source-based confidence category
- Inference chains documented for INFERRED claims
- UNVERIFIABLE claims explain why verification isn't possible

---

## ODD+2 Reference Structure

The 7 ODD elements (from Grimm et al. 2020):

1. **Purpose and Patterns** — Why the model was built, what patterns it reproduces
2. **Entities, State Variables, and Scales** — What things exist, their properties, spatial/temporal scales
3. **Process Overview and Scheduling** — What happens each time step, in what order
4. **Design Concepts** — 11 sub-concepts:
   - 4.1 Basic principles
   - 4.2 Emergence
   - 4.3 Adaptation
   - 4.4 Objectives
   - 4.5 Learning
   - 4.6 Prediction
   - 4.7 Sensing
   - 4.8 Interaction
   - 4.9 Stochasticity
   - 4.10 Collectives
   - 4.11 Observation
5. **Initialization** — Starting state of the model
6. **Input Data** — External data driving the model
7. **Submodels** — Detailed description of each process

---

## Out of Scope (v0.1)

- Batch processing of multiple models
- Plugin marketplace distribution
- Automated hooks between phases
- TRACE document generation
- Model card generation
- Integration with NetLogo/Mesa/other framework-specific tools
- Automated code execution for verification

## Resolved Design Questions

1. **Embedding strategy**: Full embed — entire ODD+2 protocol text and guidance checklists are bundled as supporting files alongside each skill's SKILL.md, referenced via `${CLAUDE_SKILL_DIR}`.
2. **Research output format**: One consolidated `findings.md` structured by ODD element (+ separate `interview-log.md`).
3. **Context window strategy for complex models**: Progressive disclosure — the mega-prompt starts with high-level structure and the draft agent progressively reads detailed sections as needed, rather than loading everything at once. For simple models the plan fits in one document; for complex models the plan references detailed sub-sections that the agent reads on demand.
4. **Verification independence**: The verification agent sees only the ODD + source materials (code/docs). It does NOT see the generation plan — this ensures truly independent verification against the sources rather than checking plan compliance.
