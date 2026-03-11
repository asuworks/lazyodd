# ODD+2 Protocol Reference (Grimm et al. 2020)

**Citation:** Grimm, V., Railsback, S.F., Vincenot, C.E., et al. (2020). The ODD Protocol for Describing Agent-Based and Other Simulation Models: A Second Update to Improve Clarity, Replication, and Structural Realism. *JASSS* 23(2) 7.

The ODD (Overview, Design concepts, Details) protocol is the standard format for describing agent-based and individual-based models. It provides a seven-element structure that makes model descriptions complete, consistent, and readable, serving both as documentation and as a workflow for model design.

---

## ODD Structure

The protocol consists of seven elements organized into three conceptual categories:

**Overview**
1. Purpose and patterns
2. Entities, state variables, and scales
3. Process overview and scheduling

**Design Concepts**
4. Design concepts (11 specific concepts; omit those that do not apply)

**Details**
5. Initialization
6. Input data
7. Submodels

Each element should be numbered as shown. The categories (O, D, D) are for conceptual orientation only and are not used as headings in the document itself.

---

## Supplement Ecosystem

| Supplement | Content |
|---|---|
| S1: ODD Guidance and checklists | For each element and design concept: rationale, specific guidance, checklists, and examples from existing ODDs. |
| S2: Summary ODD | Template and examples for writing abbreviated ODDs suitable for journal main text. |
| S3: Nested ODD | Guidance and examples for hierarchical ODDs where complex submodels get their own reduced ODD. |
| S4: ODD of modified models | Guidance and examples for writing ODDs of models that build on earlier models and their ODDs. |
| S5: License agreement for ODD | Guidance on declaring conditions under which ODDs can be re-used, with example licenses. |
| S6: Example TRACE documents | Two example TRACE (TRAnsparent and Comprehensive model Evaludation) documents showing full iterative model development documentation. |
| S7: Describing simulation experiments | Guidance on organizing and describing simulation experiments, calibration, and model analysis in publications. |

---

## Including Design Rationale

Each ODD element should include an optional **Rationale** subsection explaining why the model was designed that way. Including rationale:

- Increases model credibility by showing evidence of careful design decisions.
- Encourages developers to search for existing techniques and justify their choices.
- Makes it easier for others to identify which parts of a model are suitable for re-use.

Ways to include rationale:
- State the basis for all parameter values (which literature, what data, calibration method).
- Analyse each major submodel separately to show it produces reasonable results under all conditions that occur in the full model.
- Use pattern-oriented modelling to justify critical design decisions (variable selection, scales, agent behaviour representation).

Rationale may be omitted when the ODD serves purely as user documentation of a widely-used model, or when describing a model developed by someone else.

Note: including rationale can substantially increase ODD length. Use the Summary ODD approach (next section) and/or a TRACE document to manage this.

---

## Summary ODD

A Summary ODD provides a narrative description of the entire model, concise enough for a journal article's main text, while remaining specific enough that the main results can be understood without the full ODD.

**Approach:**

1. Always write a full ODD first, then summarize.
2. Begin with the three Overview elements (Purpose and patterns; Entities, state variables, and scales; Process overview and scheduling) rewritten in narrative, story-like form.
3. Omit section titles. Move long lists of state variables into tables.
4. Entities can be described together with the processes they execute if this improves the narrative flow.
5. Use and italicize ODD keywords to help readers locate details in the full ODD: *purpose, entities, state variables, scales, processes, schedule, design concept, initialization, submodel*.
6. Present only the design concepts and submodels essential to understanding the model's main idea and the specific application.
7. Briefly describe initialization and input data only if essential.
8. If the summary still does not convey the overall narrative, present the narrative first (without ODD terminology), then follow with the Summary ODD and a link to the full ODD.
9. Consider a graphical "visual ODD" showing entities, initialization, processes/scheduling, and key model outputs.

A template and examples are provided in Supplement S2.

---

## Hierarchical ODDs for Complex Models

For models with submodels requiring 10+ pages of description, use **nested ODDs**: describe each complex submodel using its own reduced ODD structure.

**A nested submodel ODD should include:**
- Element 1: Purpose and patterns (of the submodel)
- Element 3: Process overview and scheduling (of the submodel)
- Element 7: Submodels (of the submodel)

**These elements remain at the full-model level only (do not repeat per submodel):**
- Element 2: Entities, state variables, and scales
- Element 4: Design concepts
- Element 5: Initialization
- Element 6: Input data

**Additional guidance for complex models:**
- Group parameters by the submodel in which they are used, rather than providing a single large parameter table.
- When numerous equations are used, summarize them in tables and explain the rationale for each equation in surrounding text. This separation improves readability and provides a better overview.

See Supplement S3 for a nested ODD example.

---

## ODDs for Re-used or Modified Models

When a model builds on or modifies an existing model, three approaches are available:

**1. Delta-ODD (differences only)**
Describe only the changed elements, referencing the original ODD for unchanged parts. Appropriate only when the original ODD is freely and permanently available (e.g., published as a supplement or at a stable URL with a link in the delta-ODD).

**2. New complete ODD with re-used sections**
Copy relevant parts from the previous ODD into a new, standalone document. This is the most common approach because:
- The original ODD is often not freely available.
- Journals may require complete, self-contained model descriptions.
- The new model may include only part of the previous model plus many new parts.

When copying, give full credit to original authors, clearly distinguish re-used from original work, and ensure the new ODD's license does not violate the original's.

**3. Licensing for re-use**
Add a license (e.g., in a footnote) to every ODD, stating terms of use. Include a copyleft provision requiring that future users do not restrict re-use with their own license statements.

See Supplements S4 and S5 for examples.

---

## Linking ODD to Code

Linking the ODD to the model's source code reduces ambiguity and aids replication. Readers who can find the code implementing any ODD element are more likely to fully understand and replicate the model.

**Naming conventions:**
- Use identical names for variables, parameters, and submodels in both the ODD and the code.
- Use code comments to identify where specific ODD elements, algorithms, or numbered equations are implemented.

**Explicit code-location references:**
- Add a table to the ODD mapping each element, submodel, or algorithm to its code location (file, function/procedure name, or line number).
- Alternatively, produce a single combined document with hyperlinks from ODD sections to corresponding code (as done in the BEEHAVE model by Becher et al. 2014).

**Technical context to provide:**
- Revision numbers of external software and libraries used.
- Architecture (e.g., x86, 32/64 bits) and operating system version.
- Compiler/interpreter details and any numerical solution methods.

---

## Pattern-Oriented Modelling in ODD

Element 1 is titled **"Purpose and patterns"** to explicitly integrate pattern-oriented modelling (POM). Patterns are observations (individual- or system-level) believed to be driven by the same processes, variables, and mechanisms important for the model's purpose.

**Where patterns go:** Element 1, stated before entities and state variables because patterns inform the selection of model structure (entities, state variables, scales).

**How patterns are used in model design:**
- Selecting model entities, state variables, and scales so the patterns could be reproduced.
- Testing alternative submodels for agent behaviour by whether they cause the patterns to emerge.
- Using quantitative patterns to identify useful parameter values.

**Important:** Also report patterns the model consistently failed to reproduce. Reporting only successfully reproduced patterns resembles HARKing (Hypothesizing After Results are Known).

---

## Guidance for Element 1: Purpose and Patterns

Every model must start from a clear question, problem, or hypothesis. ODD begins with a concise, specific statement of the model's purpose.

**Purpose guidance:**
- Make the purpose specific, addressing a clear question.
- Include the higher-level purpose (e.g., understanding, prediction, demonstration).
- Tie the purpose to the study's primary results.
- Define your terms.
- Be specific to this version of the model.
- Do not describe the model yet.
- Make this purpose statement independent (self-contained).

**Patterns guidance:**
- Identify observed patterns that characterize the model system with respect to the model purpose.
- Use qualitative but testable patterns.
- Document the patterns (source, level of observation, relevance to purpose).
- For models not based on a specific real system, patterns are often general beliefs about how the system and its agents should behave.

**General purpose types** (useful to identify before stating the specific purpose): prediction, explanation, description, theoretical exposition, illustration, analogy, social learning.

**Checklist:** The text for this element should describe (1) the model's specific purpose(s), and (2) the patterns used as criteria for evaluating the model's suitability for its purpose.

---

## Core Principle

Describe what the program does, not what you think the model does. ODD must capture the structure and processes of the implemented program, not a simplified mental model. Meta-descriptions of mental models are inevitably incomplete. All relevant equations, algorithms, and decision rules must be included.
