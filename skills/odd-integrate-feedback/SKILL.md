---
name: odd-integrate-feedback
description: >
  Analyze user feedback reports and conduct a structured interview with the
  plugin developer to plan concrete improvements to odder skills. Invoke
  manually when you have feedback reports to process.
license: MIT
compatibility: Requires structured user interaction (multiple-choice questions), file reading, searching, and writing.
metadata:
  author: asuworks
  version: "0.1.0"
---

# Feedback-Driven Plugin Improvement

You help a plugin developer improve odder by analyzing scientist feedback and conducting a structured interview to prioritize and plan changes.

Your audience is the **plugin developer**, not the scientist. You speak in terms of skill files, prompts, tag vocabularies, and workflow design.

## Phase 0: Discover Your Interaction Tools

Before starting, determine how to present structured multiple-choice questions to the user. You MUST use your agent's structured interaction tool — do NOT fall back to plain text for multiple-choice questions.

Known tools by agent:

- **Claude Code**: `AskUserQuestion` — questions array with header, options (label + description), multiSelect
- **Gemini CLI**: `ask_user` — questions array with header, options (label + description), multiSelect, type
- **OpenCode**: `ask_user` or ask-user-questions MCP plugin
- **Other agents**: Search your available tools for one that presents multiple-choice options to the user

If no structured interaction tool is available, present numbered options in chat and ask the user to reply with their choice number. Always include an "Other" option for custom input.

## Step 1: Collect Feedback Files

Glob for all feedback files:

```
odder/feedback/*.md
**/odder/feedback/*.md
```

If no feedback files are found, tell the developer to have scientists run `/odd-feedback` first.

Read all found files. Parse each file's YAML frontmatter into structured data.

## Step 2: Aggregate Patterns

Build a summary from the frontmatter fields across all reports. For each field, count occurrences:

**Compute these aggregates:**

| Metric                       | How                                                                                                                 |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Weakest phase                | Most frequent `weakest_phase` value                                                                                 |
| Top interview issues         | Most frequent tags in `interview_issues`                                                                            |
| Top edit types               | Most frequent tags in `edit_types`                                                                                  |
| Consistently weak elements   | Elements appearing in `weak_elements` across multiple reports                                                       |
| Consistently strong elements | Elements appearing in `strong_elements` across multiple reports                                                     |
| Reuse willingness            | Distribution of `would_reuse` values                                                                                |
| Edit severity                | Distribution of `edits_needed` values                                                                               |
| Reimplementability           | Distribution of `reimplementable` values                                                                            |
| Diagram/equation issues      | Count of `missing_diagrams`, `wrong_diagrams`, `unnumbered_equations`, `wrong_voice` in edit types and draft issues |

**Also collect:**

- All "Suggested Fixes" lines, grouped by phase
- All "Biggest problem" free-text entries
- All "Best surprise" free-text entries

## Step 3: Present Findings

Present the aggregated data to the developer as a briefing before starting the interview:

```
## Feedback Summary ({N} reports)

**Weakest phase:** /draft (5/8 reports)
**Top issues:** missed_key_topics (6x), vague_process_descriptions (4x), missing_content (4x)
**Weak elements:** 7_submodels (6x), 3_process_overview (4x)
**Strong elements:** 1_purpose (5x), 2_entities (4x)
**Would reuse:** yes: 2, with_improvements: 5, no: 1
**Edits needed:** none: 1, minor: 3, significant: 3, rewrote: 1

### User-suggested fixes (raw):
- "/draft: Element 7 submodels were prose, should be pseudocode"
- "/interview: Ask about boundary conditions earlier"
- "/draft: Missing stochastic distribution parameters"
...
```

## Step 4: Developer Interview

Conduct a structured interview with the developer using your agent's structured interaction tool (see Phase 0). The questions adapt based on the aggregated findings.

### Call 1: Scope & Priority

```
Question 1:
  question: "Which improvement area do you want to focus on?"
  header: "Focus"
  multiSelect: false
  options:
    - label: "[Top weakest phase]" (Recommended)
      description: "Flagged by {N}/{total} reports — {top issues for this phase}"
    - label: "[Second weakest phase]"
      description: "Flagged by {N}/{total} reports — {top issues for this phase}"
    - label: "Cross-cutting"
      description: "Address issues that span multiple phases"
    - label: "Quick wins"
      description: "Fix the easiest, most impactful issues first"

Question 2:
  question: "How much change are you comfortable with?"
  header: "Scope"
  multiSelect: false
  options:
    - label: "Prompt tuning"
      description: "Adjust existing skill instructions, add examples, refine wording"
    - label: "Structural changes"
      description: "Reorganize skill flow, add/remove steps, change output format"
    - label: "New capabilities"
      description: "Add new skills, new question types, new output sections"
    - label: "Full redesign"
      description: "Rethink how a phase works from scratch"
```

### Call 2: Phase-Specific Diagnosis

Based on the focus area chosen in Call 1, ask targeted questions about that phase. Read the relevant skill file before asking.

**If focus is /interview:**

```
Question 1:
  question: "The top interview issue is '{top_issue}'. What's the likely root cause?"
  header: "Root cause"
  multiSelect: false
  options:
    - label: "Missing context"
      description: "The skill doesn't read enough source material before asking questions"
    - label: "Generic questions"
      description: "Questions aren't tailored to the adaptive strategy for this input type"
    - label: "No stopping rule"
      description: "Interview continues past the point of useful information"
    - label: "Wrong priorities"
      description: "Asks about less important aspects while missing critical ones"

Question 2:
  question: "How should the interview adapt for models where '{weak_element}' is consistently weak?"
  header: "Adaptation"
  multiSelect: false
  options:
    - label: "Add targeted questions"
      description: "Explicitly ask about {weak_element} when the code/docs look thin there"
    - label: "Add checklist gate"
      description: "Before finishing, verify {weak_element} coverage against a checklist"
    - label: "Change question order"
      description: "Ask about {weak_element} early, not as a follow-up"
    - label: "Provide examples"
      description: "Show the scientist what good {weak_element} content looks like"
```

**If focus is /plan:**

```
Question 1:
  question: "Plans aren't matching user intent. What should change?"
  header: "Plan fix"
  multiSelect: false
  options:
    - label: "Include user intent summary"
      description: "Add a section capturing the modeler's stated goals from the interview"
    - label: "Add review checkpoint"
      description: "Show plan outline to user for approval before generating full plan"
    - label: "Tighter research coupling"
      description: "Plan should more directly reference findings.md structure"
    - label: "Add counter-examples"
      description: "Include 'do NOT do this' instructions based on common failures"
```

**If focus is /draft:**

```
Question 1:
  question: "Users report '{top_edit_type}' as the main edit needed. What should change in the draft skill?"
  header: "Draft fix"
  multiSelect: false
  options:
    - label: "Stronger prompting"
      description: "Add explicit instructions for the weak areas in SKILL.md"
    - label: "Add format examples"
      description: "Include good/bad examples of the problematic sections"
    - label: "Change output structure"
      description: "Restructure the ODD template to guide better content"
    - label: "Pre-draft checklist"
      description: "Agent checks a list of requirements before writing each section"

Question 2:
  question: "Element '{weak_element}' is consistently weak. Best fix?"
  header: "Element fix"
  multiSelect: false
  options:
    - label: "Element-specific prompts"
      description: "Add per-element generation instructions with precision requirements"
    - label: "Require pseudocode"
      description: "Force pseudocode/equations for process-heavy elements, not prose"
    - label: "Source-first drafting"
      description: "Quote the source material first, then write the ODD section around it"
    - label: "Multi-pass generation"
      description: "Generate, self-critique, then revise before outputting"
```

**If focus is /check:**

```
Question 1:
  question: "Verification has '{top_check_issue}'. What should change?"
  header: "Check fix"
  multiSelect: false
  options:
    - label: "Stricter sampling"
      description: "Verify more claims, not just a sample of 10"
    - label: "Element-weighted checks"
      description: "Spend more verification effort on historically weak elements"
    - label: "Separate fact-check pass"
      description: "Add a dedicated pass that only checks parameter values against code"
    - label: "Calibrate scoring"
      description: "Adjust rubric thresholds based on actual user editing patterns"
```

**If focus is Cross-cutting or Quick wins:**

```
Question 1:
  question: "Which cross-cutting improvement would help most?"
  header: "Cross-cut"
  multiSelect: false
  options:
    - label: "Better handoff format"
      description: "Improve how phases pass information to each other"
    - label: "Shared checklist"
      description: "All phases reference a common ODD completeness checklist"
    - label: "User feedback loop"
      description: "Let users flag issues mid-workflow, not just at the end"
    - label: "Element-specific guidance"
      description: "Add per-element reference material to all phase skills"
```

### Call 3: Confirm Approach

After the phase-specific diagnosis, summarize the proposed changes and confirm:

```
Question 1:
  question: "I'll generate a change plan targeting {focus_phase} with {scope} changes. Include user-suggested fixes?"
  header: "Suggestions"
  multiSelect: false
  options:
    - label: "Yes, incorporate all"
      description: "Use all user-suggested fixes relevant to the focus area"
    - label: "Cherry-pick"
      description: "I'll tell you which suggestions to include"
    - label: "Skip suggestions"
      description: "Generate improvements from the pattern analysis only"

Question 2:
  question: "Should the change plan include specific edits to skill files, or stay at the strategy level?"
  header: "Detail level"
  multiSelect: false
  options:
    - label: "Specific edits"
      description: "Show exactly what to add/change in each SKILL.md, with before/after"
    - label: "Strategy only"
      description: "Describe what to change and why, I'll write the edits myself"
```

If the developer chose "Cherry-pick", ask in chat which suggestions to include before proceeding.

## Step 5: Generate Change Plan

Write the change plan to `odder/suggested-changes/YYYY-MM-DDTHH-MM-SS.md` (ISO datetime with colons replaced by hyphens). Create the `odder/suggested-changes/` directory if needed.

The plan format depends on the detail level chosen:

### Strategy-level plan

```markdown
---
schema_version: 1
date: [ISO date]
feedback_files: [list of feedback files analyzed]
feedback_count: [N]
focus_phase: [phase]
scope: [prompt_tuning | structural | new_capabilities | full_redesign]
status: proposed
---

# Change Plan: [Focus Area]

> Based on {N} feedback reports | Generated by odder:integrate-feedback

## Problem Summary

[2-3 sentences describing the pattern across feedback reports, with specific numbers]

## Root Cause Analysis

[Developer's diagnosis from Call 2, expanded with evidence from feedback]

## Proposed Changes

### Change 1: [Title]

**Target:** `skills/{phase}/SKILL.md`
**Type:** [prompt_tuning | structural | new_capability]
**Addresses:** [list of feedback tags this change targets, e.g. vague_process_descriptions, missing_content]
**Rationale:** [why this change should fix the pattern]

**What to change:**
[Description of the change at the chosen detail level]

### Change 2: [Title]

...

## User Suggestions Incorporated

[List which user suggestions were included, mapped to which change]

- "{suggestion text}" → Change 1
- "{suggestion text}" → Change 3

## What NOT to Change

[Explicitly list strong areas from feedback that should be preserved]

- {strong_element}: consistently rated strong, do not restructure
- {positive_phase_aspect}: users praised this, protect it

## Verification

After implementing changes, re-run the plugin on a test model and check:

- [ ] Weak elements ({list}) show improvement
- [ ] Strong elements ({list}) are not degraded
- [ ] Edit severity shifts toward "none" or "minor"
- [ ] Top issue tags ({list}) no longer appear in new feedback

## Next Steps

- [ ] Review this plan
- [ ] Implement changes (manually or with agent assistance)
- [ ] Test on a model
- [ ] Collect new feedback with `/odd-feedback`
- [ ] Run `/odd-integrate-feedback` again to measure improvement
```

### Specific-edits plan

Use the same structure as above, but for each change include a before/after diff:

```markdown
### Change 1: [Title]

**Target:** `skills/{phase}/SKILL.md` lines {N}-{M}
**Addresses:** [feedback tags]

**Before:**

> [exact current text from the skill file]

**After:**

> [proposed replacement text]

**Why:** [one sentence connecting this edit to the feedback pattern]
```

To produce specific edits: Read the relevant skill file(s), identify the exact sections that correspond to the diagnosed issues, and write concrete replacement text.

## Completion

After writing the change plan, summarize for the developer:

- Path to the change plan file
- Number of changes proposed
- Which feedback tags are addressed vs. which remain unaddressed
- Suggested next action: "Review the plan, then implement changes or run `/odd-integrate-feedback` again after the next batch of feedback"
