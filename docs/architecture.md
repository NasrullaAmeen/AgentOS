# architecture.md — the layered design on this machine

## Stack

```mermaid
flowchart TB
    subgraph Kernel ["Agent OS Kernel (AGENTS.md)"]
        direction TB
        OS_CMD["/os <task>"]
        ROUTE[declarative routing table]
    end

    subgraph Agents ["Agents (~/.agents/os/prompts/)"]
        direction LR
        RP[research-planner]
        GH[github-research]
        RD[reddit-research]
        WEB[web-research]
        RE[reverse-engineering]
        CA[competitive-analysis]
        AN[analysis]
    end

    subgraph Skills ["Skills"]
        direction LR
        ECC_SK[~110 ECC skills]
        GLOBAL_SK[~/.agents/skills/<br/>agent-reach, lightpanda, archify]
    end

    subgraph MCP_Layer ["MCP Tool Layer"]
        direction LR
        GH_MCP[GitHub]
        BR_MCP[Browser]
        FS_MCP[Filesystem]
        SR_MCP[Search]
    end

    subgraph Memory ["Memory (2Brains)"]
        direction TB
        A[("Vault A<br/>~/.agents/os/memory/human/")]
        B[("Vault B<br/>~/.agents/os/memory/ai/")]
    end

    subgraph ECC ["ECC Coding Engine"]
        direction LR
        ORCH_PIPE[orch-* pipeline]
        HOOKS[hooks]
        CMDS[~100 commands]
    end

    subgraph Harnesses ["Harnesses"]
        direction LR
        CC[Claude Code]
        OC[opencode]
    end

    OS_CMD --> ROUTE
    ROUTE --> Agents
    Agents --> Skills
    Skills --> MCP_Layer
    Agents --> Memory
    Agents --> ECC
    ECC --> Harnesses
    Memory <--> Agents
```

## Layer map: vision vs. what exists

| Layer | In the vision | On this machine | Status |
|---|---|---|---|
| ECC / coding engine | Coding agents, skills, commands, hooks, dev workflows | Live in both harnesses; ~110 skills, ~100 commands, 30 agents, `orch-*` pipeline | ✅ Done |
| MCP (tool layer) | GitHub, Browser, Filesystem, Database, Search | ECC MCP + agent-reach (15 platforms, zero-config channels) + orca session layer | ✅ Done |
| Skills (capabilities) | One skill = one job | agent-reach, github-ops, deep-research, exa-search, repo-scan, competitive-* pipeline, documentation-lookup, lightpanda, archify | ✅ Reuse, do not duplicate |
| Specialist agents | github/reddit/web research, reverse-engineering, competitive analysis | 7 agent prompts authored (`~/.agents/os/prompts/`); wired into opencode via `{file:agents/<name>.md}` and Claude Code via wrappers | ✅ Done |
| Orchestrator / kernel | COO that routes tasks across specialists | `/os` command + routing table in `AGENTS.md`; per-task orchestration also available (`plan-orchestrate`, `ralphinho`, `orch-*`) | ✅ Done |
| Memory / 2Brains | Vault A human + Vault B AI underneath everything | Scaffold + conventions + data dirs (`logs/`, `decisions/`, `projects/`, `inbox/`) | ✅ Done |

## Naming note (avoid confusion)

| Name | What it is | Where |
|---|---|---|
| **`agent-os`** (lowercase, buildermethods) | The *standards system* (`/discover-standards`, `/inject-standards`, …) | `~/.agents/src/agent-os/` |
| **Agent OS** (capitalized) | The whole *operating system for agents* described here | Runtime at `~/.agents/os/` |
| **ECC** | The coding engine (skills, commands, hooks, agents, `orch-*` pipeline) | `~/.config/orca/opencode-hooks/shared/` |

## Global layout (`~/.agents/`)

```mermaid
flowchart TB
    subgraph AGENTS [".agents/"]
        direction TB
        A[AGENTS.md]
        SK[skills/]
        SRC[src/]
        OS[os/]
    end

    subgraph Skills [".agents/skills/"]
        direction LR
        BM[bm-*]
        AC[agentcanon-*]
        AR[agent-reach]
        LP[lightpanda]
        AF[archify]
        DC[diagnose-crash]
        DOC[documentation]
        OM[omarchy]
    end

    subgraph SRC [".agents/src/ — upstream clones"]
        direction LR
        SRC_OS[agent-os]
        SRC_BM[bm-skills]
        SRC_AC[agentcanon]
        SRC_AR[agent-reach]
        SRC_LP[agent-skill]
        SRC_AF[archify]
    end

    subgraph OS [".agents/os/ — runtime"]
        direction TB
        PROMPTS[prompts/]
        AGENTS_WRAP[agents/]
        CMDS[commands/]
        MEM[memory/]
        DATA[data/]
    end

    AGENTS --> Skills
    AGENTS --> SRC
    AGENTS --> OS
```

| Dir | Purpose |
|---|---|
| `AGENTS.md` | Workspace doc + Agent OS kernel (routing, conventions) |
| `skills/` | Canonical global skills (symlinks into `src/` clones) |
| `src/` | Persistent upstream clones — `git pull` to update |
| `os/prompts/` | Canonical pure-text agent prompts (opencode `{file:}` source) |
| `os/agents/` | Claude Code agent wrappers (frontmatter + body) |
| `os/commands/` | `/os` + agent-os standards commands |
| `os/memory/human/` | Vault A — human-authored knowledge |
| `os/memory/ai/` | Vault B — agent-produced research, logs, reflections |
| `os/data/logs/` | Append-only session logs |
| `os/data/decisions/` | Decision records (ADR-lite) |
| `os/data/projects/` | Per-project context files |
| `os/data/inbox/` | Tasks and ideas awaiting triage |

## How the layers connect

```mermaid
flowchart LR
    subgraph Input [" "]
        USER[("User")]
    end

    subgraph Kernel ["Agent OS Kernel"]
        OS_CMD["/os <task>"]
        PLAN[research-planner]
        DISP[parallel dispatch]
        SYN[analysis]
    end

    subgraph Memory ["2Brains"]
        A[("Vault A")]
        B[("Vault B")]
    end

    subgraph ECC ["ECC"]
        ORCH[orch-* pipeline]
    end

    subgraph Output [" "]
        CODE[("Coded output")]
    end

    USER --> OS_CMD
    OS_CMD --> PLAN
    PLAN --> DISP
    DISP --> SYN
    SYN --> Memory
    SYN --> ECC
    ECC --> CODE
    Memory <--> Kernel
```

| Layer | Role | Key files |
|---|---|---|
| **Kernel** (`AGENTS.md`) | Declarative routing: user intent → specialist agent → skill → ECC handoff | `AGENTS.md` |
| **Agents** (`os/prompts/`) | Thin prompt files naming skills + declaring memory scope | `~/.agents/os/prompts/<name>.md` |
| **Skills** | Reused from ECC (~110) + `~/.agents/skills/`; never re-implement what a skill covers | `~/.agents/skills/`, `~/.config/orca/opencode-hooks/shared/skills/` |
| **MCP** | Scoped tool surface agents call through; integrations stay out of agent prompts | `shared/opencode.json` `mcp` block |
| **Memory (2Brains)** | Read-before-start / append-after-finish for every agent | `~/.agents/os/memory/{human,ai}/` |
| **ECC** | Coding engine receives routed work through `orch-*` pipeline | `shared/skills/orch-*/` |

**ECC handoff entry points:**

| Task type | ECC entry point |
|---|---|
| New capability | `orch-add-feature` |
| Fix a bug | `orch-fix-defect` |
| Change existing behavior | `orch-change-feature` |
| Refactor, same behavior | `orch-refine-code` |
| From a spec to a running MVP | `orch-build-mvp` |

Each chains: research → plan → TDD → review → gated commit.
