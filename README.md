# odder

Agent skills that generate complete ODD+2 protocol documents from agent-based model code and documentation. 4-phase, human-in-the-loop workflow designed to preserve the author's intent:

1. The agent **interviews** the author about the model, **explores** existing model files, and customizes the generation process through all 4 phases.
2. The agent **plans** the protocol generation. Planning of the generation is intentionally extracted into a separate step such that a human can review the plan before the agent generates nonsense.
3. The agent **generates** a draft ODD protocol based on the plan from the previous step.
4. The agent **verifies** the draft against existing model files and generates a **verification report**. This step is intended to reduce hallucinations.

Compatible with any agent that supports the [Agent Skills](https://agentskills.io) standard: Claude Code, GitHub Copilot, Cursor, Gemini CLI, OpenCode, VS Code, OpenAI Codex, and many more.

## Quick Start

It is recommended to install odder in the folder where you keep your model files.

```bash
cd my/model/files
```

Install odder skills using npx:

[Node.js](https://nodejs.org) is required for the `npx` installer (`npx` runs the [skills CLI](https://github.com/vercel-labs/skills) automatically).

```bash
# Install to your project:
npx skills add comses/odder

# Install to specific agents:
npx skills add comses/odder -a claude-code -a codex

# Install globally:
npx skills add comses/odder -g
```

If you don't have [Node.js](https://nodejs.org) installed, or don't want to use `npx`, install the skills manually:

```bash
cd /tmp
git clone https://github.com/comses/odder

# Go to your model files folder
cd my/model/files

# Copy the contents of this repo's `skills/` directory into the local `.agents/skills/` directory that compatible agents scan for project skills.
mkdir -p .agents/skills
cp -R /tmp/odder/skills/* .agents/skills/
```

### Run

```bash
/odd-interview .   # Phase 1: interview + source files exploration
/odd-plan          # Phase 2: generate instrucstions for ODD protocol generation
/odd-draft         # Phase 3: generate draft ODD protocol
/odd-check         # Phase 4: verify ODD draft and generate a verification report
/odd-feedback      # Optional: tell us how it went
```

Review artifacts in `odder/` between each phase.

## Skills

### For model developers

| Phase        | Skill            | What happens                               | Output                                                      |
| ------------ | ---------------- | ------------------------------------------ | ----------------------------------------------------------- |
| **Research** | `/odd-interview` | Agent reviews files, interviews modeler    | `odder/research/findings.md`                                |
| **Plan**     | `/odd-plan`      | Creates standalone generation instructions | `odder/plan/odd-generation-plan.md`                         |
| **Draft**    | `/odd-draft`     | Fresh agent executes the plan              | `odder/draft/odd.md` + `odder/draft/traceability-matrix.md` |
| **Verify**   | `/odd-check`     | Independent agent checks the ODD           | `odder/checked/verification-report.md`                      |
| **Feedback** | `/odd-feedback`  | Interactive questionnaire (~2 min)         | `odder/feedback/{datetime}.md`                              |

Each phase builds on the previous one's artifacts, and human review between phases catches problems early.

## Design Decisions

### Source-based confidence

Every claim in the generated ODD is annotated:

| Category            | Meaning                                         |
| ------------------- | ----------------------------------------------- |
| `CODE_VERIFIED`     | Verified by reading code at specific file:line  |
| `DOC_STATED`        | Explicitly stated in documentation              |
| `MODELER_CONFIRMED` | Confirmed during interview                      |
| `INFERRED`          | Reasonably inferred, inference chain documented |
| `UNVERIFIABLE`      | Cannot be verified, reason stated               |

### Dual traceability

Inline citations in the ODD text (`[source: model.py:42]`) AND a companion traceability matrix mapping every claim to its source.

### Reimplementability as quality bar

"Could someone rebuild this model from this ODD alone?" This catches vague prose, missing parameters, and implicit assumptions.

### Adaptive interview

| Input quality             | Strategy                                                       |
| ------------------------- | -------------------------------------------------------------- |
| Code + comprehensive docs | Gap-driven — only ask about what's unclear                     |
| Code + minimal docs       | Conceptual-first — establish purpose, then verify against code |
| Docs only                 | Deep interrogation — probe for precise process logic           |
| Code only                 | Reverse-engineer — present understanding for confirmation      |

### Independent verification

The verification agent does NOT see the generation plan — only the ODD and original sources. This ensures verification against sources, not just plan compliance.

---

### For SKILL developers

| Skill                     | What happens                                                     | Output                                  |
| ------------------------- | ---------------------------------------------------------------- | --------------------------------------- |
| `/odd-integrate-feedback` | Aggregates feedback, interviews developer, generates change plan | `odder/suggested-changes/{datetime}.md` |

The improvement loop: scientists run `/odd-feedback` → developer runs `/odd-integrate-feedback` → implement changes → repeat.

You can also edit the SKILL.md files directly — they're plain markdown.

## Creating Your Own SKILL Pack

These skills were built through an agent-driven interview process. You give the agent reference materials and a goal, then it interviews you until it has enough context to design the full workflow.

1. Create a project and a `.devcontext/` directory
2. Place reference materials into `.devcontext/` (domain docs, protocol specs, etc.)
3. **Research your agent's capabilities** and save those docs to `.devcontext/` too — this is the step most people skip
4. Launch your agent:

   ```text
   Read all files in .devcontext/

   I want to design [your process]. Conduct an interview with me
   until you fully understand how to achieve this task.
   ```

After 20-30 minutes of Q&A, the agent generates a full specification, multi-phase workflow, verification procedure, and file structure. The interview forces deep context before generation — without it, you get generic templates.

### Tips

- **Research agent capabilities BEFORE the interview.** We designed a solution then discovered the plugin system worked differently than assumed.
- **Commit your interview transcript.** It documents why your process looks the way it does.
- **Start with a known model** (Schelling, Wolf-Sheep) before tackling your research model.
- **Run `/odd-feedback` after every generation.** It takes 2 minutes and drives improvements.

## Development

This repo uses [qlty](https://qlty.sh) for code quality. Formatting and linting run automatically on commit via git hooks.

```bash
# Set up git hooks (auto-formats on commit):
qlty githooks install

# Manual check:
qlty check --all

# Manual format:
qlty fmt --all
```

**Plugins:** prettier and markdownlint (formatting), trufflehog (secret scanning).

## Agents Tested

| Agent                    | Notes                                               |
| ------------------------ | --------------------------------------------------- |
| Claude Code (Opus)       | Strong code analysis, good at structured interviews |
| GitHub Copilot (VS Code) | Picks up skills automatically                       |
| Gemini CLI               | Works with explicit prompting                       |
| OpenCode                 | Full skill support                                  |
| OpenAI Codex             | Works well                                          |
| pi.dev                   | Full skill support via `.agents/skills/`            |
| _More coming_            | PRs welcome with experience reports                 |

## Related Links

- [ODD+2 Protocol (Grimm et al. 2020)](https://www.jasss.org/23/2/7.html)
- Railsback & Grimm (2019), _Agent-Based and Individual-Based Modeling_
