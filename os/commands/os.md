# /os — run the Agent OS pipeline

Run the full Agent OS research → synthesis → action pipeline for the given task.

Arg: the task (e.g. `/os reverse engineer Apify and assess whether we can compete`).

## Pipeline

1. **Plan.** Invoke the `research-planner` subagent with the task. It picks research questions, chooses channels (GitHub/Reddit/web; add reverse-engineering and/or competitive-analysis when the target is code or a competitor), and writes `~/.agents/os/memory/ai/research/<slug>/plan.md`. From its reply take: the slug, the agent list, the parallel batches, and the triage order.

2. **Dispatch.** Run the required analyst subagents (github-research, reddit-research, web-research, reverse-engineering, competitive-analysis). Run independent ones in parallel. Each reads the plan and writes only its own file under `research/<slug>/`. If a channel backend is unavailable, the agent must report that and continue — never fabricate sources.

3. **Synthesize.** Invoke the `analysis` subagent. It reads the whole `research/<slug>/` folder and returns a verdict:
   - `ready-for-coding` → continue to step 4
   - `need-more-research` → dispatch only the missing questions, then re-run analysis
   - `answer-only` → present `synthesis.md` to the user and go to step 5

4. **Route to ECC.** When coding is indicated, hand off to the matching ECC gated pipeline in the target project:
   - new capability → `orch-add-feature`
   - fix a bug → `orch-fix-defect`
   - change existing behavior → `orch-change-feature`
   - refactor, same behavior → `orch-refine-code`
   - spec → running MVP → `orch-build-mvp`
   Run the orchestration inside the target project directory, with the synthesis file as the input brief.

5. **Log.** Append a run summary + short reflection to `~/.agents/os/memory/ai/logs/<date>-os.md`:
   - task, slug, agents used, verdict
   - what worked / what didn't / what to change

6. **Cost tracking.** After each agent completes, log its cost entry:
   ```bash
   ./ops/cost/logger.sh <agent> "<task>" <model> <tokens_in> <tokens_out> <wall_clock_sec> <slug> <verdict>
   ```
   This writes to `ops/cost/runs/<date>.jsonl`. If the harness does not expose token counts, skip this step and note it in the log. Future: integrate automatically when harness token reporting is available.

## Discipline
- The 2Brains vault: only agents write to `memory/ai/`; `memory/human/` is read-only for agents.
- Vault B files are append-only where they record history.
- Every claim a researcher makes must carry a source and be labeled A/B/C confidence — carry this forward into the synthesis and handoff.
- Keep the final answer concise: bottom line first, evidence-linked details below.