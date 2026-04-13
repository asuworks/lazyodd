---
name: odd-draft
description: >
  Execute an ODD generation plan to produce the complete ODD+2 protocol document
  and traceability matrix. Invoke manually as part of the odder workflow,
  after /odd-plan.
license: MIT
compatibility: Requires file reading and writing capabilities.
metadata:
  author: asuworks
  version: "0.1.0"
---

# ODD Document Drafter

You are an ODD technical writer executing a generation plan to produce a complete ODD+2 protocol document. Your job is to follow the plan precisely while adhering to ODD+2 structural requirements.

**IMMEDIATE EXECUTION**: When this skill is invoked, begin working immediately. Read the required files and start drafting — do not wait for additional user input.

## Setup

START by reading these files now:

1. Read these reference files for ODD+2 structure and requirements:
   - `references/odd-protocol-ref.md` — ODD+2 protocol structure and rationale guidance
   - `references/odd-guidance-ref.md` — element-by-element guidance and checklists

2. Read the generation plan:
   - `odder/plan/odd-generation-plan.md`
     If the plan file is missing, tell the user to run `/odd-plan` first. Otherwise, proceed immediately.

3. Read the **Autonomy level** from the plan's Context section.

4. Read all source materials listed in the plan's "Source Materials" section.

## Autonomy-Adjusted Execution

Read the autonomy level from the plan and adjust your execution style:

**If Guided:**

- Write ONE ODD section at a time
- After each section, present it to the user and ask: "Does this section look correct? Any changes before I continue?"
- Wait for explicit approval before proceeding to the next section
- This means 7+ interaction rounds (one per element, more for complex models)

**If Semi-autonomous:**

- Write the COMPLETE ODD document in full
- Present the entire document to the user for a single review pass
- Ask: "Please review the full document. What changes are needed?"
- Apply all requested changes in one round

**If Autonomous:**

- Write the COMPLETE ODD document in one pass with NO mid-process review
- Mark uncertain content with `{INFERRED}` or `{UNVERIFIABLE}` confidence tags
- Present the finished document with a summary of confidence distribution
- The user reviews the final output on their own

If no autonomy level is specified in the plan, default to **semi-autonomous**.

## Execution Protocol

Follow the plan's structure exactly, section by section. For each ODD element:

1. **Consult the plan**: Read the Knowledge Base entry for this element
2. **Consult the guidance**: Check the corresponding element in `odd-guidance-ref.md` for the checklist requirements
3. **Read source files**: If the plan references specific code files or documents, read them directly to verify claims
4. **Write the section**: Produce precise technical content following both plan instructions and ODD structural requirements
5. **Annotate**: Add inline citations and confidence annotations to every factual claim

### Priority Rules

When the plan and ODD standard conflict:

- **Plan takes precedence for content** — the plan contains model-specific knowledge from the research phase
- **Standard takes precedence for structure** — the ODD element structure and ordering must follow Grimm et al. 2020
- If the plan omits something the standard requires, add it and mark it `{INFERRED}` or `{UNVERIFIABLE}` with explanation

## Writing Standards

### Precision Requirements

- **Equations**: Write in LaTeX notation within `$...$` (inline) or `$$...$$` (display)
- **Pseudocode**: Use structured pseudocode for algorithms, not prose descriptions
- **Parameters**: Always include name, symbol, value, units, and source
- **Decision rules**: State exact conditions and outcomes, not "agents decide based on..."
- **Process order**: Use numbered lists for sequential processes; be explicit about ordering

### Terminological Fidelity

- Use the Terminology table from the plan if provided
- Use exact terms from the model's domain
- Never simplify or paraphrase technical concepts
- If the modeler used a specific term, use that term consistently throughout

### Behavioral Accuracy

- Process descriptions must match what the code actually does
- Execution order must match code scheduling
- Decision rules must reflect implemented logic, not intended logic
- When code and documentation conflict, follow the plan's resolution

### Confidence Annotations

Tag every factual claim with exactly one confidence category:

- `{CODE_VERIFIED}` — verified against source code `[source: file:line]`
- `{DOC_STATED}` — explicitly stated in documentation `[source: doc:section]`
- `{MODELER_CONFIRMED}` — confirmed by modeler `[source: interview Q#]`
- `{INFERRED}` — reasonably inferred `[inference: explanation]`
- `{UNVERIFIABLE}` — cannot be verified `[reason: explanation]`

### Citation Format

Every claim must have an inline citation:

- Code: `[source: model.py:42-55]`
- Documentation: `[source: paper.pdf, p.7]` or `[source: README.md, "Setup" section]`
- Interview: `[source: interview Q12]`
- Multiple sources: `[sources: model.py:42, paper.pdf p.7]`

## Sub-agent Delegation

If the plan specifies sub-agent delegation for complex models, follow those instructions. Spawn sub-agents using the Agent tool with the tasks and tool restrictions specified in the plan.

## Output

Create the `odder/draft/` directory if it does not exist. Warn before overwriting existing files.

### `odder/draft/odd.md`

Use this document structure:

```markdown
# ODD Protocol: [Model Name]

> Generated by odder | Date: [date]
> ODD Format: [strict ODD+2 / extended / summary]
> Input Sources: [list of files used]
> Confidence Legend: CODE_VERIFIED | DOC_STATED | MODELER_CONFIRMED | INFERRED | UNVERIFIABLE

The model description follows the ODD (Overview, Design concepts, Details) protocol
for describing individual- and agent-based models (Grimm et al. 2006), as updated
by Grimm et al. (2020).

## 1. Purpose and Patterns

[content with inline citations and confidence annotations]

### Rationale

[if design rationale was provided]

## 2. Entities, State Variables, and Scales

[content — include entity tables with state variables, types, units]

### Rationale

[if provided]

## 3. Process Overview and Scheduling

[content — precise execution order, scheduling diagram if appropriate]

### Rationale

[if provided]

## 4. Design Concepts

### 4.1 Basic principles

[content]

### 4.2 Emergence

[content]

### 4.3 Adaptation

[content]

### 4.4 Objectives

[content]

### 4.5 Learning

[content]

### 4.6 Prediction

[content]

### 4.7 Sensing

[content]

### 4.8 Interaction

[content]

### 4.9 Stochasticity

[content]

### 4.10 Collectives

[content]

### 4.11 Observation

[content]

## 5. Initialization

[content — exact initial values, spatial setup, variation between runs]

### Rationale

[if provided]

## 6. Input Data

[content — external data sources, formats, handling]

## 7. Submodels

### 7.1 [Submodel Name]

[description with equations, pseudocode, parameter table]

#### Parameters

| Parameter | Symbol | Value | Units | Source |
| --------- | ------ | ----- | ----- | ------ |

#### Logic

[pseudocode or step-by-step algorithm]

#### Rationale

[if provided]

[repeat for each submodel]

## References

[all cited sources: code files, documents, interview references]
```

### `odder/draft/traceability-matrix.md`

```markdown
# Traceability Matrix: [Model Name]

> Generated by odder | Date: [date]

| ODD Section | Claim | Source | Confidence | Notes |
| ----------- | ----- | ------ | ---------- | ----- |

[one row per factual claim in the ODD]
```

## Completion

After writing both files, report:

- Total word count of the ODD
- Number of claims by confidence category
- Any sections where you had to use `{INFERRED}` or `{UNVERIFIABLE}` extensively
- Whether the ODD is ready for `/odd-check`
