---
name: odd-plan
description: >
  Transform ODD research findings into a standalone mega-prompt that a fresh
  agent can execute to generate the full ODD document. Invoke manually as part
  of the odder workflow, after /odd-interview.
license: MIT
compatibility: Requires file reading and writing capabilities.
metadata:
  author: asuworks
  version: "0.1.0"
---

# ODD Generation Plan Builder

You are a prompt architect transforming research findings into a self-contained, executable generation plan. A fresh agent with zero prior context must be able to execute this plan to produce a complete ODD+2 document.

**IMMEDIATE EXECUTION**: When this skill is invoked, begin working immediately. Read the input files and start building the plan — do not wait for additional user input. **Exception:** In Guided mode, pause at the Diagram Plan step to present diagram recommendations for approval.

## Inputs

START by reading these files now:

1. `odder/research/findings.md` — structured research organized by ODD element
2. `odder/research/interview-log.md` — chronological record of modeler Q&A

If either file is missing, tell the user to run `/odd-interview` first. Otherwise, proceed immediately to the next step.

## Read Autonomy Level

Check the `Autonomy Level` field in the Model Overview section of `odder/research/findings.md`. This determines how the downstream `/odd-draft` and `/odd-check` skills should behave. You MUST embed this in the plan's Context section and adjust the plan's instructions accordingly:

- **Guided**: The plan should instruct the draft agent to present each ODD section to the user for review before continuing to the next. Include explicit pause points.
- **Semi-autonomous**: The plan should instruct the draft agent to generate the complete ODD, then present it as a whole for a single review pass.
- **Autonomous**: The plan should instruct the draft agent to generate the complete ODD in one pass with no mid-process review. Mark uncertain content with `{INFERRED}` or `{UNVERIFIABLE}` confidence tags. The user will review the final output.

## Read Voice Preference

Check the `Narrative Voice` field in the Model Overview section of `odder/research/findings.md`. Embed this in the plan's Context section. If not specified, default to **mixed**.

- **Mixed**: Instruct the draft agent to use first person ("we") for design rationale and third person ("the model") for descriptions
- **Third-person only**: Instruct the draft agent to always use "the model", never "we"
- **First-person**: Instruct the draft agent to use "we" throughout

## Plan Design Principles

The plan you produce must be:

1. **Self-contained**: A fresh agent with no prior context can execute it
2. **Knowledge-complete**: Every finding from the research phase is embedded in the plan
3. **Structurally explicit**: All 7 elements, all 11 design concepts enumerated as sections to produce
4. **Quality-specified**: Reimplementability bar, confidence annotations, citation format all defined
5. **Traceable**: Every claim in the plan cites its source from the research
6. **Formally precise**: Submodels must include equations/pseudocode requirements, not just prose descriptions

## Building the Plan

### Step 1: Assess Completeness

Review `odder/research/findings.md` for gaps:

- Are all 7 ODD elements covered?
- Are all 11 design concepts addressed?
- Are there open questions that should have been resolved?
- Is there enough detail for each submodel (equations, parameters, logic)?

If there are critical gaps (missing elements, unresolved conflicts), warn the user and recommend returning to `/interview` to address them before proceeding.

### Step 2: Determine Delegation Strategy

Based on model complexity (recorded in findings):

| Complexity                                       | Strategy                                                                                              |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| **Simple** (1-3 entity types, <5 submodels)      | Single agent handles entire ODD                                                                       |
| **Moderate** (3-10 entity types, 5-15 submodels) | Main agent + code analysis sub-agent for Element 7                                                    |
| **Complex** (10+ types or 15+ submodels)         | Main agent coordinates sub-agents: code analyzer for submodels, domain specialist for design concepts |

### Step 3: Plan Diagrams

Based on model complexity and the Diagrams Inventory from findings.md, determine which diagrams to include in the ODD.

**Complexity-based defaults:**

| Complexity | Recommended diagrams                                                                                                      |
| ---------- | ------------------------------------------------------------------------------------------------------------------------- |
| Simple     | Process scheduling flowchart (if scheduling has >3 steps)                                                                 |
| Moderate   | Process scheduling flowchart + Entity hierarchy                                                                           |
| Complex    | Process scheduling flowchart + Entity hierarchy + Interaction/network diagram + submodel flowcharts for complex submodels |

**Autonomy-adjusted behavior:**

- **Guided**: Present the recommended diagrams to the user via the structured interaction tool. Ask: "Based on the model complexity, I recommend these diagrams: [list]. Would you like to add, remove, or modify any?" Wait for approval before embedding in the plan.
- **Semi-autonomous**: Present recommendations as an informational note in the plan output. The user reviews the full plan before it's used.
- **Autonomous**: Select diagrams based on complexity defaults and the Diagrams Inventory. No pause needed.

For each planned diagram, specify in the plan's Knowledge Base:

- Diagram type (Mermaid flowchart / Mermaid classDiagram / Mermaid sequenceDiagram)
- Which ODD element it belongs to
- What entities/processes to include
- Expected level of detail
- Caption text

### Step 4: Construct the Plan

Build the mega-prompt with all sections below. Every piece of knowledge from the research must appear somewhere in the plan — nothing should be left in the research that the draft agent would need but not find in the plan.

### Step 5: Encode Terminology

Extract all domain-specific terms from the research findings and interview log. Create an explicit terminology table in the plan with:

- The exact term to use
- Terms to avoid (common paraphrases that would be incorrect)
- Definition in the model's context

### Step 6: Specify Progressive Disclosure

For simple models: the plan is one document with all details inline.

For complex models: structure the plan so the main document provides high-level instructions and references detailed sub-sections. The draft agent reads detailed sections on demand rather than loading everything at once.

## Output

Write to `odder/plan/odd-generation-plan.md`. Create the `odder/plan/` directory if it does not exist. Warn before overwriting existing files.

The plan must follow this structure:

```markdown
# ODD Generation Plan for [Model Name]

## Instructions for the Drafting Agent

You are an ODD technical writer. Execute this plan to produce a complete ODD+2 protocol
document. Read the ODD+2 protocol reference and guidance documents bundled with the /draft skill
(references/odd-protocol-ref.md and references/odd-guidance-ref.md).

Then read all source materials listed below and follow the section-by-section instructions.

## Context

- Model name: [name]
- Authors: [authors]
- Model complexity: [simple/moderate/complex]
- ODD format: [strict/extended/summary]
- Input quality: [assessment]
- Autonomy level: [guided/semi-autonomous/autonomous]
- Narrative voice: [mixed/third-person/first-person]

## Source Materials

Read these files before drafting:
[list every file the draft agent should read, with a note on what each contains]

## Terminology

| Term | Use This | NOT This | Definition |
| ---- | -------- | -------- | ---------- |

[terminology table]

## Knowledge Base

### Element 1: Purpose and Patterns

[all findings for this element, with source citations]
[specific instructions on what to write]

### Element 2: Entities, State Variables, and Scales

[all findings, with source citations]
[specific instructions: entity table format, state variable lists, scale specifications]

### Implementation Context

[Language/platform, version, libraries, repository URL, hardware requirements — from findings]
[Instruct draft agent to include this as a subsection within Element 2]

### Element 3: Process Overview and Scheduling

[all findings, with source citations]
[specific instructions: exact execution order, scheduling diagram format]

### Element 4: Design Concepts

#### 4.1 Basic principles

[findings and instructions]

#### 4.2 Emergence

[findings and instructions]

#### 4.3 Adaptation

[findings and instructions]

#### 4.4 Objectives

[findings and instructions]

#### 4.5 Learning

[findings and instructions]

#### 4.6 Prediction

[findings and instructions]

#### 4.7 Sensing

[findings and instructions]

#### 4.8 Interaction

[findings and instructions]

#### 4.9 Stochasticity

[findings and instructions]

#### 4.10 Collectives

[findings and instructions]

#### 4.11 Observation

[findings and instructions]

### Element 5: Initialization

[all findings, with source citations]
[specific instructions: initial values, spatial setup, variation between runs]

### Element 6: Input Data

[all findings, with source citations]
[specific instructions on external data description]

### Element 7: Submodels

#### Submodel: [name]

[all findings, equations, pseudocode, parameters with values/ranges/units/sources]
[repeat for each submodel]

## Diagram Plan

### Planned Diagrams

| #   | Diagram | Type | ODD Element | Entities/Processes | Caption |
| --- | ------- | ---- | ----------- | ------------------ | ------- |

### Diagram Instructions for Draft Agent

For each diagram above, generate a Mermaid code block inline in the ODD document.
The draft agent may add additional diagrams if it discovers something worth illustrating
during source code analysis, but must not remove any diagrams listed above.

## Quality Standards

### Reimplementability

A competent modeler who has never seen the code must be able to reimplement the model
from the ODD alone. This means:

- All parameters specified with values, units, and ranges
- All decision rules precisely defined with exact conditions and outcomes
- All equations written in LaTeX notation
- All algorithms described in pseudocode or step-by-step logic
- All boundary conditions and edge cases addressed

### Confidence Annotations

Tag every factual claim with one of:

- `{CODE_VERIFIED}` — verified by reading actual code [file:line]
- `{DOC_STATED}` — explicitly stated in documentation [doc:section]
- `{MODELER_CONFIRMED}` — confirmed by modeler during interview [interview Q#]
- `{INFERRED}` — reasonably inferred [inference chain]
- `{UNVERIFIABLE}` — cannot be verified [reason]

### Citation Format

Inline citations: `[source: file.py:42]` or `[source: paper.pdf, p.7]` or `[source: interview Q12]`

### Writing Rules

- Use exact terminology from the Terminology table
- Never paraphrase technical concepts into simpler language
- Describe what the program does, not what you think the model does
- Include rationale subsections where the modeler provided design rationale

## Autonomy Instructions

[Based on the autonomy level from the Context section above, include ONE of the following blocks:]

### If Guided:

Present each ODD section to the user for review before proceeding to the next section.
After each section, ask: "Does this section look correct? Any changes before I continue?"
Only proceed to the next section after explicit approval or correction.

### If Semi-autonomous:

Generate the complete ODD document in full, then present it to the user for a single review pass.
After the complete draft, ask: "Please review the full document. What changes are needed?"
Apply all requested changes in one round.

### If Autonomous:

Generate the complete ODD document in one pass. Do not pause for mid-process review.
Mark any uncertain content with {INFERRED} or {UNVERIFIABLE} confidence tags.
Present the finished document with a summary of confidence distribution.
The user will review the final output on their own.

## Sub-agent Instructions

[if applicable: what sub-agents to spawn, their specific tasks, tools to use]
[for simple models: "No sub-agents needed. Handle all sections directly."]

## Traceability Matrix

The draft must also produce `odder/draft/traceability-matrix.md` mapping every ODD claim to its source.
Format:
| ODD Section | Claim | Source | Confidence | Notes |
|-------------|-------|--------|------------|-------|

## Output Specifications

- Primary document: `odder/draft/odd.md`
- Traceability matrix: `odder/draft/traceability-matrix.md`
- Format: Markdown with inline citations and confidence annotations
```

After writing the plan, report to the user:

- Total number of findings encoded
- Any elements with thin coverage (few findings, low confidence)
- Whether sub-agent delegation is recommended
- Confirmation that the plan is ready for `/odd-draft`
