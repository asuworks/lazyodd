# Want to automate ODD generation for your models, but want to have control over it?
Best way is to teach your agent how to generate an ODD.

A working way to kickstart this project (the one that teaches your agent how to generate ODDs) is with an interview with your agent:

1. `mkdir lazyodd && cd lazyodd`
2. `git init .`
3. `mkdir .devcontext`
4. place these 3 files into `lazyodd/.devcontext`:
[ODD Guidance and Checklists.md](https://github.com/user-attachments/files/25887943/ODD.Guidance.and.Checklists.md)
[ODD_Protocol_Second_Update_Grimm_et_al_2020.md](https://github.com/user-attachments/files/25887942/ODD_Protocol_Second_Update_Grimm_et_al_2020.md)
[prompt_hierarchy_framework.md](https://github.com/user-attachments/files/25887941/prompt_hierarchy_framework.md)

5. **Research your agent's actual capabilities** and save the docs to `.devcontext/`. This is the step most people skip — and it's the most important one.

   Before you interview the agent about ODD generation, you need to know what your agent can actually *do*. Can it create plugins? Skills? Hooks? Multi-file projects? What's the file format? What frontmatter fields exist? You don't want to design a solution the agent can't build, or miss a capability that would make the solution better.

   For example, during our interview we decided to package the solution as a Claude Code plugin. But when we later researched the [actual plugin docs](https://code.claude.com/docs/en/plugins), we discovered:
   - Skills support `${CLAUDE_SKILL_DIR}` for portable file references — we could bundle ODD reference files alongside each skill instead of embedding 43k tokens directly
   - Skills support `${CLAUDE_SKILL_DIR}` for portable file references — we could bundle ODD reference files alongside each skill instead of embedding 43k tokens directly
   - `disable-model-invocation: true` prevents auto-triggering — exactly what we needed for deliberate workflow phases
   - `allowed-tools` lets you restrict tools per skill — so the verification phase can be read-only

   **None of this came up during the interview.** We only discovered it by reading the docs afterward, and it changed our implementation plan significantly. If we'd done this research first, the interview would have produced a better design from the start.

   **How to do this:**
   ```bash
   # Ask your agent to fetch and summarize its own capability docs
   # Then save the summaries to .devcontext/ so the interview has full context

   # For Claude Code:
   # - https://code.claude.com/docs/en/plugins
   # - https://code.claude.com/docs/en/plugins-reference
   # - https://code.claude.com/docs/en/skills

   # For other agents: find their extension/plugin/skill documentation
   ```

   Save these as reference files in `.devcontext/` (e.g., `agent-capabilities.md`). When the interview starts, the agent reads them alongside the ODD protocol docs and can make informed suggestions about packaging and architecture.

6. launch your agent (claude, gemini, copilot, pi, opencode, etc...) with something like:

```
read all files in .devcontext/

I want to design a process of generating a full ODD protocol given a model's documentation (some text files) and model's code.

Ultrathink: let's design a process for full ODD generation optimized for preservation of author's intent and scientific precision and completeness.

We should also design a post-generation verification procedure.
Conduct an interview with me until you fully understand how to achieve this task.
```

## Why do this?

During the interview, the agent will ask you many questions and finally generate a solution that is:
1. suitable to your level of understanding (very underrated!)
2. follows a process tailored to your work style
3. will output ODD in your desired format
4. etc...

## Possible questions during the interview

The agent will explore roughly 10 categories. Here are the ones we encountered in our interview session, with examples of how our answers shaped the final design:

1. **How do you want to package your solution?** Claude plugin, CLI tool, prompt library, etc. We chose a Claude Code plugin with 4 skills (`/lazyodd:interview`, `/lazyodd:plan`, `/lazyodd:draft`, `/lazyodd:check`). Your answer here determines the entire delivery format.

2. **What types of models will you process?** The agent needs to know if you're targeting ABMs specifically, system dynamics, hybrid models, or anything. We focused on agent-based models, which told the agent to emphasize entities, scheduling, and interaction patterns.

3. **What input sources will be available?** Sometimes you have code + a full paper. Sometimes just code. Sometimes just a verbal description. We said "variable — must handle all." This led the agent to design an adaptive interview strategy that changes behavior based on input quality.

4. **What does "scientific precision" mean for your use case?** The agent asked us to be specific. We wanted all four: mathematical exactness (equations, units), terminological fidelity (never paraphrase domain terms), behavioral accuracy (process descriptions must match code), AND uncertainty quantification (explicit confidence levels on every claim).

5. **Who will read the generated ODD?** Reimplementers? Reviewers? The original developers? We said "all audiences," which raised the quality bar — the ODD must be precise enough to reimplement from, clear enough for reviewers, and faithful enough that the original author recognizes their model.

6. **What output format?** Markdown was our final output, but the agent suggested machine-readable intermediary versions for validation. This led to a pipeline architecture rather than one-shot generation.

7. **What happens when information is missing or ambiguous?** This is critical. We chose a human-in-the-loop approach: the agent asks the modeler rather than guessing. Never silently skip. Never hallucinate a mechanism that isn't in the source.

8. **How should the workflow be structured?** One-shot? Multi-pass? We arrived at a 4-phase, multi-session workflow: Research → Plan → Draft → Verify. Each phase is a separate session with its own prompt, and the human reviews artifacts between phases.

9. **How should source traceability work?** The agent offered inline citations, footnotes, or a separate matrix. We chose both: inline citations in the ODD text (`[source: model.py:42]`) AND a companion traceability matrix document mapping every claim to its source.

10. **What should verification check?** Structural completeness (all 7 elements present)? Code alignment? Reimplementability? We wanted comprehensive verification: all of the above plus semantic consistency checks between sections and a confidence audit.

## What the interview produces

After 20-30 minutes of Q&A, the agent generates:

- A **full specification** — detailed process design covering all phases, handoff formats, quality standards, and verification procedures
- A **generation pipeline** — multi-phase workflow tailored to your model complexity and input quality
- A **verification procedure** — specific checks with scoring rubrics
- A **file structure** — where inputs, intermediary artifacts, and outputs live

The interview forces the agent to build deep context before generating anything. Without it, you get a generic ODD template. With it, you get a process that understands your domain, your inputs, and your quality standards.

## Recommended approach (key design decisions from our interview)

These are the decisions that had the most impact on output quality. Consider them starting points for your own interview:

### 4-phase workflow with human checkpoints

Don't generate in one shot. Split the work into phases with human review between each:

| Phase | What happens | Output |
|-------|-------------|--------|
| **Interview/Research** | Agent reviews files, interviews modeler | `research/findings.md` — structured by ODD element |
| **Plan** | Agent creates standalone generation instructions | `plan/odd-generation-plan.md` — a "mega-prompt" |
| **Draft** | Fresh agent executes the plan | `draft/odd.md` + `draft/traceability-matrix.md` |
| **Verify** | Independent agent checks the ODD | `checked/verification-report.md` — scored rubric |

Human checkpoints between phases are intentional. You *want* to review the research findings before the agent plans, and review the plan before the agent drafts.

### Source-based confidence categories

Every claim in the generated ODD should be annotated with how it was verified:

| Category | Meaning |
|----------|---------|
| `CODE_VERIFIED` | Verified by reading actual code at specific file:line |
| `DOC_STATED` | Explicitly stated in documentation |
| `MODELER_CONFIRMED` | Confirmed by modeler during interview |
| `INFERRED` | Reasonably inferred, inference chain documented |
| `UNVERIFIABLE` | Cannot be verified from available sources, reason stated |

This solves the hallucination problem: if a claim is marked `INFERRED`, the reader knows to scrutinize it. If it's `CODE_VERIFIED`, they can check the reference.

### Dual traceability

Use both inline citations AND a separate traceability matrix. Inline citations keep the ODD readable. The matrix enables systematic auditing.

### Reimplementability as the quality bar

The single most useful verification question: "Could someone rebuild this model from this ODD alone?" This standard catches vague prose, missing parameters, hand-wavy process descriptions, and implicit assumptions.

### Adaptive interview strategy

The research phase should adapt based on what's available:

| Input quality | Strategy |
|---------------|----------|
| Code + comprehensive docs | Gap-driven — only ask about what's unclear |
| Code + minimal docs | Conceptual-first — establish purpose, then verify against code |
| Docs only | Deep interrogation — probe for precise process logic |
| Code only | Reverse-engineer — present code understanding for confirmation |

### Independent verification

The verification agent should NOT see the generation plan — only the ODD and the original source materials. This ensures truly independent verification against the sources, not just checking whether the plan was followed.

### Full ODD+2 protocol embedded in prompts

Embed the entire ODD+2 protocol specification and guidance checklists directly in your generation prompts. Don't make the agent read reference files at runtime — bake the standard into the instructions so nothing gets skipped.

## Tips

- **Research your agent's capabilities BEFORE the interview.** This was our biggest lesson. We designed a solution during the interview, then discovered the agent's plugin system worked differently than we assumed. Save capability docs to `.devcontext/` so the agent has full context from the start. See step 5 above.
- **Commit your interview transcript.** It documents why your process looks the way it does.
- **Start with a known model** (Schelling, Wolf-Sheep) before tackling your research model.
- **Don't skip verification.** The reimplementability check catches subtle omissions that look fine on first read.
- **Feed failures back.** When the ODD gets something wrong, tell the agent *why* — it improves the process.
- **Name your phases clearly.** We started with `/odd-interview`, `/odd-plan`, etc., then dropped the `odd-` prefix because the plugin namespace already provides context. Small naming choices affect usability.

## Agents tested

| Agent | Notes |
|-------|-------|
| Claude Code (Opus) | Strong code analysis, good at structured interviews, handles large context |
| *More coming* | PRs welcome with your experience reports |

## Related links

- [ODD+2 Protocol (Grimm et al. 2020)](https://www.jasss.org/23/2/7.html)
- [Hierarchical Prompt Generation Framework](prompt_hierarchy_framework.md) — why interview-first works (Level 2+ prompt construction, not Level 0)
- Railsback & Grimm (2019), *Agent-Based and Individual-Based Modeling* — comprehensive ODD guidance
