# lazyodd

Want to automate ODD generation for your models, but want to have control over it?

> Ever been in this situation: want to publish your model, but there is this ODD protocol that needs to be written... oof, so tired of this AI slop... I wish the agent could generate the ODD, but there is too much to explain... and i want to just tell it "make a nice odd for me, please, or I cancel your subscription!"

Your prayers have been answered. Now you can! ~~Buy our WonderAgent~~.
**Teach your agent to generate the ODD how you like it for you!**

lazyodd is a set of [Agent Skills](https://agentskills.io) that generate complete ODD+2 protocol documents from agent-based model code and documentation through a 4-phase, human-in-the-loop workflow optimized for preservation of author's intent, scientific precision, and completeness.

Compatible with any agent that supports the [Agent Skills](https://agentskills.io) standard: Claude Code, GitHub Copilot, Cursor, Gemini CLI, OpenCode, VS Code, OpenAI Codex, and [many more](https://agentskills.io/home).

## Quick Start

### Install

```bash
# Install to your project (all detected agents):
npx skills add asuworks/lazyodd

# Install to specific agents:
npx skills add asuworks/lazyodd -a claude-code -a codex

# Install globally (available across all projects):
npx skills add asuworks/lazyodd -g
```

Requires [skills CLI](https://github.com/vercel-labs/skills). Works with Claude Code, Codex, Cursor, GitHub Copilot, OpenCode, Gemini CLI, and [many more](https://github.com/vercel-labs/skills#available-agents).

### Run

```bash
# Invoke skills in order:
/odd-interview .   # Phase 1: research + interview
/odd-plan          # Phase 2: generation plan
/odd-draft         # Phase 3: ODD document
/odd-check         # Phase 4: verification
/odd-feedback      # Tell us how it went
```

Review artifacts in `lazyodd/` between each phase.

#### Claude Code (plugin install)

Claude Code also supports direct plugin loading without the skills CLI:

```bash
claude --plugin-dir /path/to/lazyodd

# Skills are then namespaced:
/lazyodd:odd-interview .
/lazyodd:odd-plan
# etc.
```

#### Gemini CLI note

Gemini CLI loads skills as passive context. After installation, tell Gemini to execute the skill explicitly (e.g., "run the odd-interview skill on the current directory").

### Why the `odd-` prefix?

Skill names like `plan`, `check`, and `draft` collide with built-in commands in many agents (e.g., Gemini CLI has its own `/plan`). The `odd-` prefix avoids collisions while keeping names short and domain-meaningful.

## Skills

The plugin has two audiences: **model developers** who generate ODDs, and **plugin developers** who improve lazyodd itself.

### For model developers

5 skills that run in order. Each is a separate agent session with human checkpoints between phases:

| Phase | Skill | What happens | Output |
|-------|-------|-------------|--------|
| **Research** | `/odd-interview` | Agent reviews files, interviews modeler | `lazyodd/research/findings.md` |
| **Plan** | `/odd-plan` | Agent creates standalone generation instructions | `lazyodd/plan/odd-generation-plan.md` |
| **Draft** | `/odd-draft` | Fresh agent executes the plan | `lazyodd/draft/odd.md` + `lazyodd/draft/traceability-matrix.md` |
| **Verify** | `/odd-check` | Independent agent checks the ODD | `lazyodd/checked/verification-report.md` |
| **Feedback** | `/odd-feedback` | Interactive questionnaire about your experience | `lazyodd/feedback/{datetime}.md` |

Human checkpoints between phases are intentional. You *want* to review the research findings before the agent plans, and review the plan before the agent drafts.

`/odd-feedback` is optional but valuable. It takes ~2 minutes: mostly multiple-choice questions about what worked and what didn't, with a couple of optional free-text fields. Your feedback drives plugin improvements.

### For plugin developers

| Skill | What happens | Output |
|-------|-------------|--------|
| `/odd-integrate-feedback` | Aggregates feedback reports, interviews the developer about priorities, generates a change plan | `lazyodd/suggested-changes/{datetime}.md` |

`/odd-integrate-feedback` reads all files in `lazyodd/feedback/`, counts patterns across them (weakest phases, most common issues, consistently weak ODD elements), presents the findings, then walks you through a structured interview to diagnose root causes and choose an improvement strategy. The output is a change plan with specific edits to skill files.

The improvement loop: scientists run `/odd-feedback` → developer runs `/odd-integrate-feedback` → implement changes → repeat.

### Improving your local installation

Read through the SKILL.md files and adjust them to your liking — they're plain markdown, so you can tweak prompts, add domain-specific instructions, or change the interview questions directly.

For a more structured approach, use the feedback → integrate-feedback mechanism:

```bash
# 1. After each ODD generation, run feedback:
/odd-feedback

# 2. Once you have a few feedback reports:
ls my-model/lazyodd/feedback/

# 3. Run integrate-feedback to analyze patterns and generate a change plan:
/odd-integrate-feedback

# 4. Review and apply the suggested changes:
cat lazyodd/suggested-changes/2026-03-16T10-00-00.md
```

If you have multiple models, copy their `lazyodd/feedback/` files into one directory before running `/odd-integrate-feedback` to get improvements based on all your experience.

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

---

## Creating Your Own Skill Pack

> Everything above is about **using** lazyodd. Everything below is about how lazyodd was **made** — and how you can use the same approach to create skill packs for any domain.

These skills were built through an agent-driven interview process. You give the agent reference materials and a goal, then it interviews you until it has enough context to design the full workflow.

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

The example above uses Claude Code, but the same interview approach works with any agent. The key is the interview process that generates a custom solution based on your needs and the agent's capabilities.

## Tips

- **Research your agent's capabilities BEFORE the interview.** This was our biggest lesson. We designed a solution during the interview, then discovered the agent's plugin system worked differently than we assumed. Save capability docs to `.devcontext/` so the agent has full context from the start.
- **Commit your interview transcript.** It documents why your process looks the way it does.
- **Start with a known model** (Schelling, Wolf-Sheep) before tackling your research model.
- **Don't skip verification.** The reimplementability check catches subtle omissions that look fine on first read.
- **Run `/odd-feedback` after every generation.** It takes 2 minutes and drives plugin improvements. When the ODD gets something wrong, the structured feedback tells maintainers *what* and *where*.

## Agents Tested

| Agent | Notes |
|-------|-------|
| Claude Code (Opus) | Strong code analysis, good at structured interviews, handles large context |
| GitHub Copilot (VS Code) | Picks up skills automatically |
| Gemini CLI | Works with explicit prompting; loads skills as passive context |
| OpenCode | Full skill support |
| OpenAI Codex | Works well; presents multi-choice as flat numbered lists |
| pi.dev | Full skill support via `.agents/skills/` |
| *More coming* | PRs welcome with your experience reports |

## Related Links

- [ODD+2 Protocol (Grimm et al. 2020)](https://www.jasss.org/23/2/7.html)
- Railsback & Grimm (2019), *Agent-Based and Individual-Based Modeling* — comprehensive ODD guidance
