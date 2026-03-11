---
name: feedback
description: Collect structured feedback from a scientist after ODD generation, producing a report to improve the plugin.
disable-model-invocation: true
allowed-tools: AskUserQuestion, Read, Write, Glob
---

# ODD Generation Feedback

You collect structured feedback from scientists who have just used lazyodd to generate an ODD. Your goal is to produce a concise feedback file that plugin maintainers can use to improve the workflow.

Use `AskUserQuestion` for every question that can be structured as multiple choice. Only fall back to asking in chat for truly open-ended feedback.

## Tag Vocabularies

These are the fixed tag values used in frontmatter. When a user picks "Other" and provides custom text, map it to the closest tag or add it with an `other:` prefix (e.g. `other:scheduling_issues`).

### Interview Issues
- `too_many_rounds` — Asked more questions than necessary
- `missed_key_topics` — Failed to ask about important model aspects
- `redundant_questions` — Asked things already obvious from code or docs
- `too_vague` — Questions were too broad to answer usefully

### Draft Issues (used in Call 5)
- `vague_process_descriptions` — Process logic described in prose instead of precise rules
- `wrong_parameter_values` — Parameter values don't match code or docs
- `missing_submodels` — Submodels omitted or incomplete
- `poor_pseudocode` — Pseudocode/equations unclear or absent

### Check Issues (used in Call 5)
- `false_positives` — Flagged things that were actually correct
- `missed_real_issues` — Failed to catch genuine problems
- `shallow_verification` — Checks were superficial, didn't trace to sources
- `inconsistent_scoring` — Scores didn't match the issues found

### Edit Types
- `factual_corrections` — Wrong parameter values, incorrect process descriptions
- `missing_content` — Added sections or details the draft omitted
- `tone_wording` — Rewrote for clarity or scientific style
- `structural` — Reorganized sections or moved content between elements

### ODD Elements
- `1_purpose` — Purpose and Patterns
- `2_entities` — Entities, State Variables, and Scales
- `3_process_overview` — Process Overview and Scheduling
- `4_design_concepts` — Design Concepts
- `5_initialization` — Initialization
- `6_input_data` — Input Data
- `7_submodels` — Submodels

## Prerequisites

Before starting, check that at least one phase has produced artifacts:

```
lazyodd/research/findings.md      → /interview ran
lazyodd/plan/odd-generation-plan.md → /plan ran
lazyodd/draft/odd.md              → /draft ran
lazyodd/checked/verification-report.md → /check ran
```

Use Glob to check which exist. If none exist, tell the user to run the workflow first.

## Questionnaire Flow

Run these AskUserQuestion calls in sequence. Each call groups related questions (max 4 per call).

### Call 1: Model Context

```
Question 1:
  question: "How complex is the model you documented?"
  header: "Complexity"
  multiSelect: false
  options:
    - label: "Simple"
      description: "Few entity types, straightforward rules (e.g. Schelling, Game of Life)"
    - label: "Medium"
      description: "Multiple entity types, moderate interactions (e.g. Wolf-Sheep)"
    - label: "Complex"
      description: "Many entity types, rich dynamics, spatial/network structure"

Question 2:
  question: "What inputs did you provide to the plugin?"
  header: "Inputs"
  multiSelect: false
  options:
    - label: "Code + docs"
      description: "Source code and comprehensive documentation"
    - label: "Code + minimal docs"
      description: "Source code with sparse or outdated docs"
    - label: "Code only"
      description: "Source code, no separate documentation"
    - label: "Docs only"
      description: "Documentation or papers, no runnable code"
```

### Call 2: Research & Interview Phase

```
Question 1:
  question: "Did the interview adapt well to what you provided?"
  header: "Adaptation"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Questions were relevant and built on what it found in my files"
    - label: "Partially"
      description: "Some questions were useful, others missed the mark"
    - label: "No"
      description: "Felt generic, didn't reflect my specific model"

Question 2:
  question: "What interview issues did you notice? (select all that apply)"
  header: "Issues"
  multiSelect: true
  options:
    - label: "Too many rounds"
      description: "Asked more questions than necessary"
    - label: "Missed key topics"
      description: "Failed to ask about important model aspects"
    - label: "Redundant questions"
      description: "Asked things already obvious from code or docs"
    - label: "Too vague"
      description: "Questions were too broad to answer usefully"
```

### Call 3: Plan & Draft Quality

```
Question 1:
  question: "Did the generation plan match your intent for the ODD?"
  header: "Plan fit"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Plan captured what I wanted to communicate"
    - label: "Partially"
      description: "Mostly right but I had to correct some things"
    - label: "No"
      description: "Misunderstood the model's purpose or structure"

Question 2:
  question: "Could someone reimplement your model from the generated ODD alone?"
  header: "Reimplementable"
  multiSelect: false
  options:
    - label: "Yes"
      description: "All parameters, rules, and processes are fully specified"
    - label: "Partially"
      description: "Core logic is there but some details are missing"
    - label: "No"
      description: "Too vague or incomplete to rebuild from"

Question 3:
  question: "Were the confidence annotations (CODE_VERIFIED, INFERRED, etc.) accurate?"
  header: "Confidence"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Categories matched how each claim was actually verified"
    - label: "Mostly"
      description: "A few miscategorized but generally right"
    - label: "No"
      description: "Many claims had wrong confidence levels"
```

### Call 4: Verification & Traceability

```
Question 1:
  question: "Was the traceability matrix useful?"
  header: "Traceability"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Helped me verify claims and find sources"
    - label: "Somewhat"
      description: "Present but didn't add much beyond inline citations"
    - label: "No"
      description: "Incomplete or inaccurate, not worth checking"

Question 2:
  question: "Did verification catch real issues in the ODD?"
  header: "Verification"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Found issues I would have missed"
    - label: "Some"
      description: "Caught a few things but missed others"
    - label: "No"
      description: "Mostly false positives or missed the real problems"

Question 3:
  question: "How much manual editing did the ODD need?"
  header: "Edits"
  multiSelect: false
  options:
    - label: "None"
      description: "Published as-is or near as-is"
    - label: "Minor"
      description: "Small corrections, wording tweaks"
    - label: "Significant"
      description: "Restructured sections, added missing content"
    - label: "Rewrote"
      description: "Used it as a rough outline only"
```

### Call 5: Draft & Check Specifics

```
Question 1:
  question: "What kinds of edits did you make? (select all that apply)"
  header: "Edit types"
  multiSelect: true
  options:
    - label: "Factual corrections"
      description: "Wrong parameter values, incorrect process descriptions"
    - label: "Missing content"
      description: "Added sections or details the draft omitted"
    - label: "Tone/wording"
      description: "Rewrote for clarity or scientific style"
    - label: "Structural"
      description: "Reorganized sections or moved content between elements"

Question 2:
  question: "Which ODD elements had the most problems? (select all that apply)"
  header: "Weak elements"
  multiSelect: true
  options:
    - label: "Purpose/Overview (1-3)"
      description: "Purpose, entities, scales, or process scheduling"
    - label: "Design Concepts (4)"
      description: "Emergence, adaptation, sensing, interaction, etc."
    - label: "Initialization/Input (5-6)"
      description: "Initialization procedures or input data"
    - label: "Submodels (7)"
      description: "Detailed submodel descriptions, equations, pseudocode"

Question 3:
  question: "Which ODD elements were strongest? (select all that apply)"
  header: "Strong elements"
  multiSelect: true
  options:
    - label: "Purpose/Overview (1-3)"
      description: "Purpose, entities, scales, or process scheduling"
    - label: "Design Concepts (4)"
      description: "Emergence, adaptation, sensing, interaction, etc."
    - label: "Initialization/Input (5-6)"
      description: "Initialization procedures or input data"
    - label: "Submodels (7)"
      description: "Detailed submodel descriptions, equations, pseudocode"
```

### Call 6: Overall Assessment

```
Question 1:
  question: "Would you use lazyodd again?"
  header: "Reuse"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Saved me significant time"
    - label: "With improvements"
      description: "Useful concept but needs work"
    - label: "No"
      description: "Easier to write the ODD manually"

Question 2:
  question: "Which phase needs the most improvement?"
  header: "Weakest phase"
  multiSelect: false
  options:
    - label: "/interview"
      description: "Research and interview quality"
    - label: "/plan"
      description: "Generation plan accuracy"
    - label: "/draft"
      description: "ODD document quality"
    - label: "/check"
      description: "Verification thoroughness"
```

### Final: Open-ended feedback

After all structured questions, ask the user in chat (not via AskUserQuestion):

> "Three optional free-text questions — one sentence each, or 'skip' to finish:
> 1. **What was the single biggest problem?**
> 2. **What worked better than expected?**
> 3. **Suggested fix for the weakest phase?** (e.g. 'Interview should ask about boundary conditions earlier')"

## Output

Assemble all answers into `lazyodd/feedback/YYYY-MM-DDTHH-MM-SS.md` (ISO datetime with colons replaced by hyphens for filesystem safety). Create the `lazyodd/feedback/` directory if needed.

### Frontmatter

Map all answers to their tag vocabulary values. Use lowercase_snake_case. The frontmatter must be machine-parseable YAML:

```yaml
---
schema_version: 1
date: [ISO date]
complexity: simple | medium | complex
inputs: code_and_docs | code_and_minimal_docs | code_only | docs_only
interview_adaptation: yes | partially | no
interview_issues: [too_many_rounds, missed_key_topics, ...]
plan_fit: yes | partially | no
reimplementable: yes | partially | no
confidence_accurate: yes | mostly | no
traceability_useful: yes | somewhat | no
verification_caught_issues: yes | some | no
edits_needed: none | minor | significant | rewrote
edit_types: [factual_corrections, missing_content, ...]
weak_elements: [3_process_overview, 7_submodels, ...]
strong_elements: [1_purpose, 2_entities, ...]
would_reuse: yes | with_improvements | no
weakest_phase: interview | plan | draft | check
---
```

### Element mapping for frontmatter

Map the grouped options from Call 5 to individual element tags:

- "Purpose/Overview (1-3)" → user chose a group; in the free-text "suggested fix" or "biggest problem", look for specifics to disambiguate into `1_purpose`, `2_entities`, or `3_process_overview`. If ambiguous, include all three.
- "Design Concepts (4)" → `4_design_concepts`
- "Initialization/Input (5-6)" → `5_initialization`, `6_input_data` (include both unless user specifies)
- "Submodels (7)" → `7_submodels`

### Document body

```markdown
# ODD Generation Feedback

> Generated by lazyodd:feedback | Date: [date]

## Model Context

| Field | Value |
|-------|-------|
| Complexity | [from Call 1 Q1] |
| Inputs provided | [from Call 1 Q2] |

## Phase Ratings

| Phase | Rating | Notes |
|-------|--------|-------|
| /interview — adaptation | [Call 2 Q1] | |
| /interview — issues | [Call 2 Q2, comma-separated] | |
| /plan — intent match | [Call 3 Q1] | |
| /draft — reimplementable | [Call 3 Q2] | |
| /draft — confidence accuracy | [Call 3 Q3] | |
| /check — traceability useful | [Call 4 Q1] | |
| /check — caught real issues | [Call 4 Q2] | |

## Edit Details

| Field | Value |
|-------|-------|
| Manual edits needed | [Call 4 Q3] |
| Edit types | [Call 5 Q1, comma-separated] |

## ODD Element Quality

| Weak | Strong |
|------|--------|
| [Call 5 Q2, comma-separated] | [Call 5 Q3, comma-separated] |

## Overall

| Field | Value |
|-------|-------|
| Would use again | [Call 6 Q1] |
| Weakest phase | [Call 6 Q2] |

## Open Feedback

**Biggest problem:** [free text or "—"]

**Best surprise:** [free text or "—"]

## Suggested Fixes

[For each phase the user mentioned as problematic (from weakest_phase, interview_issues, or free-text), include a line. Leave blank phases empty with "—".]

- **/interview:** [user suggestion or "—"]
- **/plan:** [user suggestion or "—"]
- **/draft:** [user suggestion or "—"]
- **/check:** [user suggestion or "—"]
```

## Completion

After writing the file, summarize for the user:

- Confirmation that `lazyodd/feedback/YYYY-MM-DDTHH-MM-SS.md` was written
- A one-line summary: "[Complexity] model, [edits needed] edits, weakest phase: [phase]"
- The top suggested fix if one was provided
- Thank them for the feedback
