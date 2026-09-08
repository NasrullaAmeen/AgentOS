# roadmap.md — milestones and next steps

## Milestone timeline

```mermaid
gantt
    title AgentOS Milestones
    dateFormat  YYYY-MM-DD
    section M0 Foundation
    Global workspace + agentcanon       :done,    m0a, 2026-09-01, 1d
    buildermethods tools wired          :done,    m0b, 2026-09-01, 1d
    2Brains scaffold                    :done,    m0c, 2026-09-01, 1d
    Docs set                            :done,    m0d, 2026-09-01, 1d
    section M1 Wire agents + orchestrator
    7 agents registered                :done,    m1a, 2026-09-08, 1d
    /os command wired                  :done,    m1b, 2026-09-08, 1d
    Kernel routing in AGENTS.md         :done,    m1c, 2026-09-08, 1d
    Validate + restart                  :done,    m1d, 2026-09-08, 1d
    section M2 Prove the loop (pilot)
    /os reverse engineer Apify         :done,    m2a, 2026-09-08, 1d
    Reddit channel unblocked            :done,    m2b, 2026-09-08, 1d
    ECC handoff (future task)           :crit,    m2c, after m2b, 1d
    Reflection logged                   :done,    m2d, 2026-09-08, 1d
    section M3 Make it autonomous
    Scheduled /os runs                  :         m3a, after m2c, 2d
    Agent eval + cost measurement       :         m3b, after m3a, 2d
    More specialists                    :         m3c, after m3b, 2d
    unified-memory bridge decision      :         m3d, after m3c, 1d
    continuous-learning-v2              :         m3e, after m3d, 2d
    section M4 Harden and share
    Cost tracking per run               :         m4a, after m3e, 1d
    Template research runs              :         m4b, after m4a, 2d
    Extract reusable skills             :         m4c, after m4b, 2d
    Reproduce-on-clean-machine doc       :         m4d, after m4c, 1d
```

## Progress

| Milestone | Name | Status | Notes |
|---|---|---|---|
| M0 | Foundation | ✅ Done | Global workspace, buildermethods, 2Brains, docs |
| M1 | Wire agents + orchestrator | ✅ Done | 7 agents, `/os`, kernel routing, validated |
| M2 | Prove the loop (pilot) | ✅ Done | `/os reverse engineer Apify` → `answer-only`; ECC handoff unproven |
| M3 | Make it autonomous and reliable | ⏳ Next | Scheduled runs, eval, more specialists, memory bridge |
| M4 | Harden and share | 🔜 Planned | Cost tracking, templates, extract skills, repro doc |

## M0 — Foundation ✅
- [x] Global agent workspace (`~/.agents/`) with the agentcanon convention
- [x] buildermethods ecosystem installed into both harnesses
- [x] agent-os standards commands live (`/discover-standards`, `/inject-standards`, `/index-standards`, `/plan-product`, `/shape-spec`)
- [x] 2Brains scaffold in place
- [x] This documentation set

## M1 — Wire the agents and orchestrator ✅
- [x] Register the 7 specialist agents in `shared/opencode.json` (`{file:agents/<name>.md}`)
- [x] Claude Code agent wrappers + `~/.claude/agents` symlink
- [x] Write + register `/os` command in both harnesses
- [x] Agent OS routing table + memory conventions into `AGENTS.md` kernel
- [x] Validate (JSON + symlinks) — all green
- [x] Restart opencode to load the new agents and commands (loaded in the 2026-09-08 session; agents live)

## M2 — Prove the loop with one real task (pilot) ✅
- [x] Run `/os <task>` on a real R&D task ("reverse engineer Apify")
- [x] Verify: plan → parallel dispatch → vault writes → synthesis → verdict (`answer-only`)
- [ ] Verify the ECC handoff on a coding follow-up (`orch-add-feature` / `orch-fix-defect`)

  *Not exercised: verdict was `answer-only` (research task, no coding). The ECC handoff entry point is wired in `os.md` step 4; prove it on a future task whose verdict is `ready-for-coding`.*

- [x] Check 2Brains discipline: human vault untouched, AI vault append-only, receipts present throughout
- [x] Fix whatever the pilot reveals; record the reflection in `memory/ai/logs/`
  - Full pilot log + reflection: `~/.agents/os/memory/ai/logs/2026-09-08-os.md`
  - Side-quest: unblocked the Reddit channel mid-run (rdt-cli v0.4.2 + Brave cookies) — see reflection

## M3 — Make it autonomous and reliable
- [x] Scheduled `/os` runs via an external scheduler (systemd timer / LaunchAgent / pm2) — templates in `ops/`
- [x] `agent-eval`-style pass rate + cost measurement for the new agents against ECC baselines — framework in `ops/eval/`, cost logger in `ops/cost/`
- [x] Add more specialists as recurring needs appear (scraper-builder, api-integration, market-sizing) — see `os/prompts/`
- [x] Decide usage of ECC `unified-memory` vault vs standalone 2Brains dirs — keep 2Brains, bridge later when cross-harness handoffs are proven necessary (see `docs/decisions/ADR-001-memory-strategy.md`)
- [x] Optional: `continuous-learning-v2` instincts feeding regular improvements into agent prompts — lightweight plain-file instincts in `ops/instincts/` (ECC migration path documented)

## M4 — Harden and share
- [x] Cost tracking per run (`data/logs/<date>-costs.json`) — `ops/cost/logger.sh` writes to both `ops/cost/runs/` and `os/data/logs/`
- [x] Template research runs for the most common tasks (competitor deep-dive, stack evaluation, vulnerability scope) — see `templates/research/`
- [x] Extract reusable pieces into their own skills (agentcanon-repo style) — agentos-research-templates, agentos-ops, agentos-cost, agentos-eval
- [x] Write up the pattern so it can be reproduced on a clean machine — setup.sh, CI workflow, and full documentation

## Guiding principles for every milestone
1. ECC stays the coding engine — never rewritten, always called.
2. Skills are reused before they are created.
3. Symlinks, not copies — one canonical home per artifact.
4. Memory is append-only where it records history, editable where it records plan.
5. Verify output by running it, not by declaring success.
