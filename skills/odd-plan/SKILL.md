---
name: odd-plan
description: >
  Transform ODD research findings into a standalone mega-prompt that a fresh
  agent can execute to generate the full ODD document. Invoke manually as part
  of the lazyodd workflow, after /odd-interview.
license: MIT
compatibility: Requires file reading and writing capabilities.
metadata:
  author: asuworks
  version: "0.1.0"
---

# ODD Generation Plan Builder

You are a prompt architect transforming research findings into a self-contained, executable generation plan. A fresh agent with zero prior context must be able to execute this plan to produce a complete ODD+2 document.

**IMMEDIATE EXECUTION**: When this skill is invoked, begin working immediately. Read the input files and start building the plan — do not wait for additional user input.

## Inputs

START by reading these files now:

1. `lazyodd/research/findings.md` — structured research organized by ODD element
2. `lazyodd/research/interview-log.md` — chronological record of modeler Q&A

If either file is missing, tell the user to run `/odd-interview` first. Otherwise, proceed immediately to the next step.

## Read Autonomy Level

Check the `Autonomy Level` field in the Model Overview section of `lazyodd/research/findings.md`. This determines how the downstream `/odd-draft` and `/odd-check` skills should behave. You MUST embed this in the plan's Context section and adjust the plan's instructions accordingly:

- **Guided**: The plan should instruct the draft agent to present each ODD section to the user for review before continuing to the next. Include explicit pause points.
- **Semi-autonomous**: The plan should instruct the draft agent to generate the complete ODD, then present it as a whole for a single review pass.
- **Autonomous**: The plan should instruct the draft agent to generate the complete ODD in one pass with no mid-process review. Mark uncertain content with `{INFERRED}` or `{UNVERIFIABLE}` confidence tags. The user will review the final output.

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

Review `lazyodd/research/findings.md` for gaps:

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

### Step 3: Construct the Plan

Build the mega-prompt with all sections below. Every piece of knowledge from the research must appear somewhere in the plan — nothing should be left in the research that the draft agent would need but not find in the plan.

### Step 4: Encode Terminology

Extract all domain-specific terms from the research findings and interview log. Create an explicit terminology table in the plan with:

- The exact term to use
- Terms to avoid (common paraphrases that would be incorrect)
- Definition in the model's context

### Step 5: Specify Progressive Disclosure

For simple models: the plan is one document with all details inline.

For complex models: structure the plan so the main document provides high-level instructions and references detailed sub-sections. The draft agent reads detailed sections on demand rather than loading everything at once.

## Output

Write to `lazyodd/plan/odd-generation-plan.md`. Create the `lazyodd/plan/` directory if it does not exist. Warn before overwriting existing files.

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

The draft must also produce `lazyodd/draft/traceability-matrix.md` mapping every ODD claim to its source.
Format:
| ODD Section | Claim | Source | Confidence | Notes |
|-------------|-------|--------|------------|-------|

## Output Specifications

- Primary document: `lazyodd/draft/odd.md`
- Traceability matrix: `lazyodd/draft/traceability-matrix.md`
- Format: Markdown with inline citations and confidence annotations
```

After writing the plan, report to the user:

- Total number of findings encoded
- Any elements with thin coverage (few findings, low confidence)
- Whether sub-agent delegation is recommended
- Confirmation that the plan is ready for `/odd-draft`
