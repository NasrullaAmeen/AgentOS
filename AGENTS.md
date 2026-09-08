# Global Agent Workspace

Canonical agent instructions for this machine (agentcanon convention: `AGENTS.md` is the source of truth).

- Claude Code reads this file via the symlink `~/.claude/CLAUDE.md -> ~/.agents/AGENTS.md`.
- opencode reads it via `instructions` in the ECC config (`~/.config/orca/opencode-hooks/shared/opencode.json`).
- Keep one canonical copy in `~/.agents/` — use symlinks, never copies.

## Layout

```
~/.agents/
├── AGENTS.md            ← this file (canonical)
├── skills/              ← canonical global skills (auto-loaded by opencode & Claude Code)
│   ├── bm-*             ← Builder Methods skills (from buildermethods/bm-skills)
│   ├── agentcanon-*     ← manifest + repo-converter skills (from buildermethods/agentcanon)
│   ├── agent-reach      ← Panniantong/agent-reach      (internet capability router)
│   ├── lightpanda       ← lightpanda-io/agent-skill    (headless browser for AI agents)
│   │   └── lightpanda-pandascript (deterministic replay scripts)
│   ├── archify          ← tt-a1i/archify               (interactive system diagrams)
│   ├── diagnose-crash, documentation, learned, omarchy
├── src/                 ← persistent upstream clones (git pull to update)
│   ├── agent-os/        ← buildermethods/agent-os      (commands + standards system)
│   ├── bm-skills/       ← buildermethods/bm-skills     (skills collection)
│   ├── agentcanon/      ← buildermethods/agentcanon    (symlink convention)
│   ├── agent-reach/     ← Panniantong/agent-reach      (internet capability router)
│   ├── agent-skill/     ← lightpanda-io/agent-skill    (headless browser for AI agents)
│   └── archify/         ← tt-a1i/archify               (interactive system diagrams)
└── os/                  ← Agent OS runtime (orchestration layer)
    ├── prompts/<name>.md ← canonical agent prompt bodies (opencode {file:} source)
    ├── agents/<name>.md  ← Claude Code agent wrappers (generated from prompts/)
    ├── commands/os.md    ← /os orchestrator command
    ├── memory/{human,ai} ← 2Brains vaults (Vault A human, Vault B AI)
    └── data/{logs,decisions,projects,inbox}
```

Symlinks in place:
- `~/.claude/CLAUDE.md` -> `~/.agents/AGENTS.md`
- `~/.claude/skills` -> `~/.agents/skills`
- `~/.agents/skills/agent-reach` -> `~/.agents/src/agent-reach/agent_reach/skill`
- `~/.agents/skills/lightpanda` -> `~/.agents/src/agent-skill`
- `~/.agents/skills/lightpanda-pandascript` -> `~/.agents/src/agent-skill/pandascript`
- `~/.agents/skills/archify` -> `~/.agents/src/archify/archify`
- `~/.claude/commands/agent-os` -> `~/.agents/src/agent-os/commands/agent-os`
- `~/.config/orca/opencode-hooks/shared/commands/agent-os` -> `~/.agents/src/agent-os/commands/agent-os`
- `~/.claude/agents` -> `~/.agents/os/agents`
- `~/.claude/commands/os.md` -> `~/.agents/os/commands/os.md`
- `~/.config/orca/opencode-hooks/shared/agents` -> `~/.agents/os/prompts`
- `~/.config/orca/opencode-hooks/shared/commands/os.md` -> `~/.agents/os/commands/os.md`

## Tools

### Agent OS (standards system)

Five slash commands available in both opencode and Claude Code:

- `/discover-standards` — interview the developer and extract codebase conventions into token-optimized standard files (`agent-os/standards/<folder>/<name>.md`). One standard at a time, ask → draft → confirm.
- `/index-standards` — regenerate the `agent-os/standards/index.yml` matching index (one-line descriptions; used instead of scanning full files).
- `/inject-standards` — inject relevant standards into context. Arg grammar: `/inject-standards`, `/inject-standards <folder>`, `/inject-standards <folder>/<file>`, `root` = top-level standards. Suggest before assuming.
- `/plan-product` — plan a product/feature using your standards + `agent-os/product/*` context.
- `/shape-spec` — run in plan mode; produce `agent-os/specs/{YYYY-MM-DD-HHMM-feature-slug}/{plan,shape,standards,references}.md` (+ `visuals/`) before any implementation.

Per-project install (adds the `agent-os/` standards tree + commands to a repo):

```
cd <project> && bash ~/.agents/src/agent-os/scripts/project-install.sh
```

Note: agent-os commands use Claude's `AskUserQuestion`; in opencode use the native `question` tool with the same recommend-then-confirm style. Apologies in advance: the shipped prompts are Claude-centric — follow their intent, adapt the tool name.

### BM Skills (Builder Methods)

- `bm-prd-creator` — convert an idea into `_build_plan/prd.html|prd.md` + per-milestone `prompt.md` files. Plain language for non-technical users. PRD states WHAT, never HOW.
- `bm-skill-builder` — the meta-skill: design/build/verify new skills per the 17-item conventions canon.
- `bm-design-system` — scaffold a token-driven design system + live reference page + agent guardrails into a React + Tailwind v4 codebase. Marker-fenced (`bm-design-system:start/end`), idempotent re-runs.
- `bm-favicon-creator` — favicon set from a Lucide icon/SVG (uses `rsvg-convert` + `magick`).

### agentcanon skills

- `agentcanon-manifest` — build `~/.agents/skills-manifest.html` (offline skill index + symlink health check).
- `agentcanon-repo` — convert any repo to AGENTS.md + `.agents/skills` + symlinks.

### ECC

ECC plugin (hooks + tools) and its ~110 skills, agents, and commands are already active via `OPENCODE_CONFIG_DIR=/home/darko/.config/orca/opencode-hooks/shared`. Do not duplicate ECC skills into `~/.agents/skills/`.

## Agent OS kernel (orchestration layer)

You are the Coordinator. You never do everything yourself: parse the request, route it to the right specialist agent, delegate, then synthesize.

Available subagents (canonical prompts in `~/.agents/os/prompts/`, registered in both harnesses):

| Agent | Role | Route when |
|---|---|---|
| `research-planner` | Decomposes a request into questions + a dispatch plan | any multi-source task |
| `github-research` | Repos, architecture, activity, ecosystem signals | codebase/tooling questions |
| `reddit-research` | Community sentiment, adoption, pain points | "what do people say" |
| `web-research` | Market context, docs, standards, facts | anything factual |
| `reverse-engineering` | Reconstruct how unknown software works | "reverse engineer X" |
| `competitive-analysis` | Competitor sets, scoring, white space | "compare X vs Y" |
| `analysis` | Merges findings into a verdict | always after research |

Run the full pipeline with `/os <task>` (plan → dispatch → analysis → verdict). When the verdict is `ready-for-coding`, hand off to the ECC gated pipeline in the project: `orch-add-feature` / `orch-fix-defect` / `orch-change-feature` / `orch-refine-code` / `orch-build-mvp`.

### 2Brains memory

- `~/.agents/os/memory/human/` = Vault A — your knowledge. Agents **read**, you **write**.
- `~/.agents/os/memory/ai/` = Vault B — agent output (research, logs, reflections). Agents **read + append**, never overwrite history.
- Research runs live in `memory/ai/research/<slug>/` (`plan.md`, `<channel>.md`, `synthesis.md`). Every claim must carry a source + A/B/C confidence. Conclusion-first, receipts below.

## Conventions to follow

- **Recommend-then-confirm**: never ask open-ended first. Propose a default + rationale + 2–3 alternatives; confirm via a question tool. One decision at a time.
- **Token economy**: standards get injected into context windows. Lead with the rule, prefer code examples over prose, one concept per standard, skip the obvious.
- **Order lives in the orchestrator**: step files are unnumbered and position-agnostic; the numbering lives in SKILL.md / the command doc only.
- **Marker blocks** (`name:start`/`name:end`) for anything a skill owns so re-runs are non-destructive and reconciliable.
- **Symlinks, never copies** — if something must exist in two harness locations, link them. One canonical home.
- **Progressive disclosure**: keep descriptions discoverable (trigger phrases), keep bodies load-on-read, keep reference material one hop away and linked.
- **Verify output**: define what "done" looks like; run the artifact once for real before declaring success.

## Updating

To refresh the upstream clones: `git -C ~/.agents/src/agent-os pull` (same for `bm-skills`, `agentcanon`, `agent-reach`, `agent-skill`, `archify`) — skills/commands are symlinked/copied from these clones. After changes, restart opencode/Claude Code.