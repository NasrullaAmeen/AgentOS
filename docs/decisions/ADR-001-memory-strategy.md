# ADR-001: Memory strategy — 2Brains vs ECC unified-memory

## Status

Accepted — keep 2Brains as the primary memory layer, bridge to unified-memory via a thin sync script when cross-harness handoffs are needed.

## Context

AgentOS currently uses **2Brains** for memory:
- `~/.agents/os/memory/human/` (Vault A — human-authored)
- `~/.agents/os/memory/ai/` (Vault B — agent-produced)
- `~/.agents/os/data/` (logs, decisions, projects, inbox)

ECC provides **unified-memory** (`ecc-universal` npm package):
- `<repo>/.ecc/memory/project/` (repo-local)
- `<repo>/.ecc/memory/team/` (shared, version-controlled)
- `~/.ecc/memory/` (user-level, cross-repo)

Both systems solve the same problem: durable, inspectable context across sessions and agents. Running both without a bridge creates divergent memory stores and confusion about which source of truth to read.

## Decision

**Keep 2Brains as the canonical memory layer for AgentOS.** Do not replace it with unified-memory.

Add a **thin sync bridge** for specific handoff scenarios where unified-memory's cross-harness portability is needed (e.g., handing work from Claude Code to Codex).

## Rationale

| Criterion | 2Brains | unified-memory | Winner |
|---|---|---|---|
| **Simplicity** | Plain files, no runtime | Requires `ecc-universal` npm install + MCP server | 2Brains |
| **Inspectability** | `cat`, `git diff`, `grep` | CLI + MCP, Markdown under the hood | 2Brains |
| **Cross-harness** | Via symlinks + shared `~/.agents/` | Native support for Claude, Codex, Hermes, Cursor, OpenCode | unified-memory |
| **Scope model** | human / ai / data | project / team / user | unified-memory (richer) |
| **Maturity** | Custom, small surface | ECC-maintained, wider adoption | unified-memory |
| **AgentOS fit** | Matches our "plain files, no database" principle | Overkill for our single-user setup | 2Brains |

2Brains wins for our current single-user, single-machine setup. unified-memory's cross-harness portability is valuable but premature — we only use two harnesses (opencode + Claude Code) and they already share `~/.agents/` via symlinks.

## Bridge design (future)

When cross-harness handoffs become a real need, add `ops/memory/bridge.sh`:

```bash
# 2Brains → unified-memory (export)
ecc memory write --scope project --id agentos-<slug> < ~/.agents/os/memory/ai/research/<slug>/synthesis.md

# unified-memory → 2Brains (import)
ecc memory read <id> --scope project > ~/.agents/os/memory/ai/research/<slug>/handoff.md
```

Bridge is opt-in, not automatic. Agents continue to read/write 2Brains by default.

## Consequences

- **Positive**: 2Brains stays simple, inspectable, and aligned with the "plain files" principle.
- **Positive**: No new runtime dependency (`ecc-universal`) until there's a proven need.
- **Negative**: Cross-harness handoffs (e.g., Claude → Codex) require manual bridging or a future script.
- **Negative**: unified-memory's richer scope model (project/team/user) is not available.

## Review trigger

Revisit this decision when:
- We add a third harness (e.g., Codex CLI or Cursor) that doesn't share `~/.agents/`.
- 2Brains grows beyond 100 files per vault (performance, search).
- ECC's `ecc-universal` becomes a hard dependency of another skill we want.
