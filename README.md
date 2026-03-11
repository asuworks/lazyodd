# lazyodd

Want to automate ODD generation for your models, but want to have control over it?

> Ever been in this situation: want to publish your model, but there is this ODD protocol that needs to be written... oof, so tired of this AI slop... I wish the agent could generate the ODD, but there is too much to explain... and i want to just tell it "make a nice odd for me, please, or I cancel your subscription!"

Your prayers have been answered. Now you can! ~~Buy our WonderAgent~~.
**Teach your agent to generate the ODD how you like it for you!**

lazyodd is a Claude Code plugin that generates complete ODD+2 protocol documents from agent-based model code and documentation through a 4-phase, human-in-the-loop workflow optimized for preservation of author's intent, scientific precision, and completeness.

## Quick Start

```bash
# From your model's directory:
claude --plugin-dir /path/to/lazyodd

# Then invoke the skills in order:
/interview .          # Phase 1: research + interview
/plan                 # Phase 2: generation plan
/draft                # Phase 3: ODD document
/check                # Phase 4: verification
/feedback             # Tell us how it went
```

Review artifacts in `lazyodd/` between each phase.

## Skills

The plugin has two audiences: **model developers** who generate ODDs, and **plugin developers** who improve lazyodd itself.

### For model developers

5 skills that run in order. Each is a separate agent session with human checkpoints between phases:

| Phase | Skill | What happens | Output |
|-------|-------|-------------|--------|
| **Research** | `/interview` | Agent reviews files, interviews modeler | `lazyodd/research/findings.md` |
| **Plan** | `/plan` | Agent creates standalone generation instructions | `lazyodd/plan/odd-generation-plan.md` |
| **Draft** | `/draft` | Fresh agent executes the plan | `lazyodd/draft/odd.md` + `lazyodd/draft/traceability-matrix.md` |
| **Verify** | `/check` | Independent agent checks the ODD | `lazyodd/checked/verification-report.md` |
| **Feedback** | `/feedback` | Interactive questionnaire about your experience | `lazyodd/feedback/{datetime}.md` |

Human checkpoints between phases are intentional. You *want* to review the research findings before the agent plans, and review the plan before the agent drafts.

`/feedback` is optional but valuable. It takes ~2 minutes: mostly multiple-choice questions about what worked and what didn't, with a couple of optional free-text fields. Your feedback drives plugin improvements.

### For plugin developers

| Skill | What happens | Output |
|-------|-------------|--------|
| `/integrate-feedback` | Aggregates feedback reports, interviews the developer about priorities, generates a change plan | `lazyodd/suggested-changes/{datetime}.md` |

`/integrate-feedback` reads all files in `lazyodd/feedback/`, counts patterns across them (weakest phases, most common issues, consistently weak ODD elements), presents the findings, then walks you through a structured interview to diagnose root causes and choose an improvement strategy. The output is a change plan with specific edits to skill files.

The improvement loop: scientists run `/feedback` → developer runs `/integrate-feedback` → implement changes → repeat.

### Improving your local installation

You don't need to wait for upstream updates. After a few ODD generations, you can improve your own copy of the plugin:

```bash
# 1. You already have feedback from your ODD runs:
ls my-model/lazyodd/feedback/
# 2026-03-11T14-30-00.md
# 2026-03-15T09-22-00.md

# 2. Run integrate-feedback from your model directory:
cd my-model
claude --plugin-dir /path/to/lazyodd
/integrate-feedback

# 3. Review the suggested changes:
cat lazyodd/suggested-changes/2026-03-16T10-00-00.md

# 4. Apply the changes to your local plugin copy:
#    The change plan targets specific skill files (e.g. skills/draft/SKILL.md)
#    with before/after diffs you can apply manually or with agent help.
```

If you have multiple models, copy their `lazyodd/feedback/` files into one directory before running `/integrate-feedback` to get improvements based on all your experience.

### Why separate phases?

Don't generate in one shot. Each phase builds on the previous one's artifacts, and human review catches problems early:

- **Interview** gathers everything the agent needs — from code, docs, AND you
- **Plan** encodes all gathered knowledge into a self-contained mega-prompt that a fresh agent can execute
- **Draft** follows the plan precisely, producing an ODD with inline citations and confidence annotations
- **Check** independently verifies the ODD against sources (it never sees the generation plan)
- **Feedback** captures what worked and what didn't, so the plugin improves over time

## Key Design Decisions

### Source-based confidence categories

Every claim in the generated ODD is annotated with how it was verified:

| Category | Meaning |
|----------|---------|
| `CODE_VERIFIED` | Verified by reading actual code at specific file:line |
| `DOC_STATED` | Explicitly stated in documentation |
| `MODELER_CONFIRMED` | Confirmed by modeler during interview |
| `INFERRED` | Reasonably inferred, inference chain documented |
| `UNVERIFIABLE` | Cannot be verified from available sources, reason stated |

This solves the hallucination problem: if a claim is marked `INFERRED`, the reader knows to scrutinize it. If it's `CODE_VERIFIED`, they can check the reference.

### Dual traceability

Both inline citations in the ODD text (`[source: model.py:42]`) AND a companion traceability matrix document mapping every claim to its source.

### Reimplementability as the quality bar

The single most useful verification question: "Could someone rebuild this model from this ODD alone?" This standard catches vague prose, missing parameters, hand-wavy process descriptions, and implicit assumptions.

### Adaptive interview strategy

The research phase adapts based on what's available:

| Input quality | Strategy |
|---------------|----------|
| Code + comprehensive docs | Gap-driven — only ask about what's unclear |
| Code + minimal docs | Conceptual-first — establish purpose, then verify against code |
| Docs only | Deep interrogation — probe for precise process logic |
| Code only | Reverse-engineer — present code understanding for confirmation |

### Independent verification

The verification agent does NOT see the generation plan — only the ODD and the original source materials. This ensures truly independent verification against the sources, not just checking whether the plan was followed.

## Building Your Own

This plugin was itself built through an interview process. You can use the same approach to create a fully customized ODD generation pipeline for any agent platform.

### The interview approach

1. `mkdir lazyodd && cd lazyodd && git init .`
2. `mkdir .devcontext`
3. Place these reference files into `.devcontext/`:
   - [ODD Guidance and Checklists.md](https://github.com/user-attachments/files/25887943/ODD.Guidance.and.Checklists.md)
   - [ODD_Protocol_Second_Update_Grimm_et_al_2020.md](https://github.com/user-attachments/files/25887942/ODD_Protocol_Second_Update_Grimm_et_al_2020.md)
   - [prompt_hierarchy_framework.md](https://github.com/user-attachments/files/25887941/prompt_hierarchy_framework.md)

4. **Research your agent's actual capabilities** and save the docs to `.devcontext/`. This is the step most people skip — and it's the most important one.

   Before you interview the agent about ODD generation, you need to know what your agent can actually *do*. Can it create plugins? Skills? Hooks? Multi-file projects? What's the file format? What frontmatter fields exist? You don't want to design a solution the agent can't build, or miss a capability that would make the solution better.

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

5. Launch your agent with:
   ```
   read all files in .devcontext/

   I want to design a process of generating a full ODD protocol given a model's
   documentation (some text files) and model's code.

   Ultrathink: let's design a process for full ODD generation optimized for
   preservation of author's intent and scientific precision and completeness.

   We should also design a post-generation verification procedure.
   Conduct an interview with me until you fully understand how to achieve this task.
   ```

### What the interview produces

After 20-30 minutes of Q&A, the agent generates:

- A **full specification** — detailed process design covering all phases, handoff formats, quality standards, and verification procedures
- A **generation pipeline** — multi-phase workflow tailored to your model complexity and input quality
- A **verification procedure** — specific checks with scoring rubrics
- A **file structure** — where inputs, intermediary artifacts, and outputs live

The interview forces the agent to build deep context before generating anything. Without it, you get a generic ODD template. With it, you get a process that understands your domain, your inputs, and your quality standards.

## Caveats

This guide uses Claude Code and creates a Claude Code plugin, but the same interview approach can be used to create a solution for any agent platform. The key is the interview process that generates a custom solution based on your needs and the agent's capabilities.

## Tips

- **Research your agent's capabilities BEFORE the interview.** This was our biggest lesson. We designed a solution during the interview, then discovered the agent's plugin system worked differently than we assumed. Save capability docs to `.devcontext/` so the agent has full context from the start.
- **Commit your interview transcript.** It documents why your process looks the way it does.
- **Start with a known model** (Schelling, Wolf-Sheep) before tackling your research model.
- **Don't skip verification.** The reimplementability check catches subtle omissions that look fine on first read.
- **Run `/feedback` after every generation.** It takes 2 minutes and drives plugin improvements. When the ODD gets something wrong, the structured feedback tells maintainers *what* and *where*.

## Agents Tested

| Agent | Notes |
|-------|-------|
| Claude Code (Opus) | Strong code analysis, good at structured interviews, handles large context |
| *More coming* | PRs welcome with your experience reports |

## Related Links

- [ODD+2 Protocol (Grimm et al. 2020)](https://www.jasss.org/23/2/7.html)
- Railsback & Grimm (2019), *Agent-Based and Individual-Based Modeling* — comprehensive ODD guidance
