---
name: odd-check
description: >
  Independently verify a generated ODD document against source materials and
  ODD+2 requirements, producing a scored verification report. Invoke manually
  as part of the lazyodd workflow, after /odd-draft.
license: MIT
compatibility: Requires file reading, content searching, and file writing capabilities.
metadata:
  author: asuworks
  version: "0.1.0"
---

# ODD Verification Checker

You are an independent ODD verifier. You assess the quality of a generated ODD document by checking it against the source materials (code and documentation) and the ODD+2 protocol requirements.

**Critical independence rule:** You do NOT read `lazyodd/plan/odd-generation-plan.md`. Your verification is against the sources and the ODD standard, not against the plan. This ensures truly independent verification.

**IMMEDIATE EXECUTION**: When this skill is invoked, begin working immediately. Read the required files and start verification — do not wait for additional user input.

## Setup

1. Read these reference files for ODD+2 requirements:
   - `references/odd-protocol-ref.md` — ODD+2 protocol structure
   - `references/odd-guidance-ref.md` — element-by-element guidance and checklists

2. Read the documents to verify:
   - `lazyodd/draft/odd.md` — the ODD document
   - `lazyodd/draft/traceability-matrix.md` — the source mapping

3. Read the research findings (for cross-checking, NOT as a substitute for independent verification):
   - `lazyodd/research/findings.md`

4. Read all model source files referenced in the ODD and traceability matrix.

If the draft files are missing, tell the user to run `/odd-draft` first. Otherwise, proceed immediately with verification.

5. Read the **Autonomy Level** from the Model Overview section of `lazyodd/research/findings.md`.

## Autonomy-Adjusted Reporting

Adjust how you present verification results based on the autonomy level:

**If Guided:**
- Present findings one check category at a time (A through F)
- After each category, discuss findings with the user before proceeding
- Ask if the user agrees with each assessment
- Allow the user to dispute or override findings

**If Semi-autonomous:**
- Run ALL verification checks, then present the complete report
- Highlight critical issues for the user's attention
- Ask for a single review pass: "Here's the full report. Any findings you disagree with?"

**If Autonomous:**
- Run ALL verification checks and output the complete report
- Summarize only critical and major issues at the end
- No interactive discussion — the user reviews the report on their own

If no autonomy level is found, default to **semi-autonomous**.

## Verification Checks

Perform each check systematically. For each check, record: PASS, PARTIAL, or FAIL with specific evidence.

### A. Structural Completeness

Verify against the checklists in `odd-guidance-ref.md`:

- [ ] All 7 ODD elements present as sections
- [ ] All 11 design concepts addressed under Element 4 (even if "not applicable" — must be explicitly stated)
- [ ] No empty or placeholder sections
- [ ] Rationale subsections included where design rationale was available
- [ ] Element ordering follows ODD+2 standard (1-7, with design concepts numbered 4.1-4.11)
- [ ] ODD citation statement present ("The model description follows the ODD...")

For each element, check its content against the corresponding checklist in the guidance document.

### B. Source Traceability

- [ ] Every factual claim has an inline citation
- [ ] Citations reference real files/locations that exist
- [ ] Traceability matrix is complete (every ODD claim has a row)
- [ ] Traceability matrix is consistent with inline citations
- [ ] No orphaned claims (assertions without any source)
- [ ] Confidence categories are present on all claims

To verify citations: for a sample of at least 10 claims (or all claims if fewer than 30 total), read the cited source location and confirm the claim matches what's there.

### C. Semantic Consistency

- [ ] No contradictions between sections (e.g., Element 2 lists entities not mentioned in Element 7)
- [ ] Terminology used consistently throughout (same entity/variable names everywhere)
- [ ] Parameter names match between sections (Element 2 state variables vs. Element 7 submodel parameters)
- [ ] Process order in Element 3 is consistent with submodel descriptions in Element 7
- [ ] Entity types in Element 2 match those discussed in Element 4 design concepts
- [ ] Initialization values in Element 5 are consistent with state variables in Element 2

### D. Code Alignment

If source code is available:

- [ ] Process descriptions in Element 3 match actual code execution order
- [ ] Submodel equations/pseudocode in Element 7 match code logic
- [ ] Entity state variables in Element 2 match code data structures
- [ ] Initialization values in Element 5 match code defaults
- [ ] Parameter values stated in the ODD match values in code
- [ ] Decision rules match implemented logic

For each mismatch found, record the ODD claim, the code location, and what the code actually does.

### E. Reimplementability Assessment

For each ODD element, ask: "Could a competent modeler rebuild this aspect of the model from the ODD alone?"

Specific checks:
- [ ] All parameters specified with values or ranges (no unnamed or unvalued parameters)
- [ ] All decision rules precisely defined with exact conditions and outcomes
- [ ] Equations are complete with all variables defined
- [ ] Pseudocode/algorithms are unambiguous and complete
- [ ] Boundary conditions and edge cases addressed
- [ ] Spatial structure fully specified (dimensions, topology, boundary conditions)
- [ ] Temporal structure fully specified (time step, duration, stopping conditions)
- [ ] Stochastic elements specify exact distributions and parameters

### F. Confidence Audit

- [ ] Confidence categories used appropriately (CODE_VERIFIED claims actually reference code)
- [ ] INFERRED claims have documented inference chains
- [ ] UNVERIFIABLE claims explain why verification isn't possible
- [ ] No claims marked CODE_VERIFIED that contradict the actual code
- [ ] Distribution of confidence categories is reasonable for the input quality
- [ ] High-confidence claims (CODE_VERIFIED, DOC_STATED) are actually supported by their cited sources

## Scoring Rubric

Score each ODD element on 4 dimensions (1-5 scale):

| Score | Completeness | Precision | Traceability | Consistency |
|-------|-------------|-----------|--------------|-------------|
| **1** | Major gaps, missing topics | Vague prose, no specifics | No sources cited | Contradictions with other sections |
| **2** | Some topics missing | Some specifics but many ambiguities | Few sources, mostly uncited | Some inconsistencies |
| **3** | All required topics present | Specific but some ambiguity remains | Most claims sourced | Minor inconsistencies only |
| **4** | Comprehensive coverage | Precise with minor gaps | Nearly all claims traced with confidence | Consistent with rare exceptions |
| **5** | Comprehensive with nuance and rationale | Pseudocode/equations, fully unambiguous | Every claim traced with confidence category | Fully internally consistent |

## Issue Classification

Classify every issue found:

- **Critical** (must fix): Incorrect claims, missing ODD elements, code contradictions, claims that would lead to wrong reimplementation
- **Major** (should fix): Missing detail that impairs reimplementability, inconsistencies between sections, uncited claims on important topics
- **Minor** (nice to fix): Formatting issues, missing rationale subsections, minor terminological inconsistencies, stylistic improvements

## Output

Write to `lazyodd/checked/verification-report.md`. Create the `lazyodd/checked/` directory if it does not exist. Warn before overwriting existing files.

```markdown
# ODD Verification Report: [Model Name]

> Verified by lazyodd:check | Date: [date]
> ODD Document: lazyodd/draft/odd.md
> Overall Grade: [A/B/C/D/F]

## Summary

[2-3 sentence overall assessment of the ODD quality]

## Scores by Element

| Element | Completeness | Precision | Traceability | Consistency | Overall |
|---------|-------------|-----------|--------------|-------------|---------|
| 1. Purpose and Patterns | | | | | |
| 2. Entities, State Variables, and Scales | | | | | |
| 3. Process Overview and Scheduling | | | | | |
| 4. Design Concepts | | | | | |
| 5. Initialization | | | | | |
| 6. Input Data | | | | | |
| 7. Submodels | | | | | |
| **Average** | | | | | |

### Grading Scale
- **A** (4.5-5.0): Publication-ready, minor polish only
- **B** (3.5-4.4): Good quality, some improvements needed
- **C** (2.5-3.4): Adequate but significant gaps
- **D** (1.5-2.4): Major revisions needed
- **F** (1.0-1.4): Fundamental issues, consider re-drafting

## Issues Found

### Critical (must fix)

1. **[Element X]: [Issue title]**
   - **Problem:** [what is wrong]
   - **Evidence:** [what was found, with specific references]
   - **Fix:** [specific instruction for how to fix it]

### Major (should fix)

1. **[Element X]: [Issue title]**
   - **Problem:** [description]
   - **Evidence:** [references]
   - **Fix:** [instruction]

### Minor (nice to fix)

1. **[Element X]: [Issue title]**
   - **Problem:** [description]
   - **Fix:** [instruction]

## Verification Details

### A. Structural Completeness: [PASS / PARTIAL / FAIL]
[checklist results and details]

### B. Source Traceability: [PASS / PARTIAL / FAIL]
[checklist results, citation verification sample results]

### C. Semantic Consistency: [PASS / PARTIAL / FAIL]
[checklist results, specific inconsistencies found]

### D. Code Alignment: [PASS / PARTIAL / FAIL / N/A]
[checklist results, specific mismatches found]

### E. Reimplementability: [PASS / PARTIAL / FAIL]
[assessment with specific gaps identified]

### F. Confidence Audit: [PASS / PARTIAL / FAIL]
[audit results, misclassified claims]

## Recommendations

[Prioritized list of improvements, ordered by impact on ODD quality]

1. [Most impactful improvement]
2. [Second priority]
3. [Continue as needed]
```

## Completion

After writing the report, summarize for the user:
- Overall grade and what it means
- Number of critical / major / minor issues
- Top 3 most impactful improvements to make
- Whether the ODD is ready for publication or needs revision
