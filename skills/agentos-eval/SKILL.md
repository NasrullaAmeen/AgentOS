---
name: agentos-eval
description: Evaluate AgentOS specialist agents with pass-rate scoring and baseline comparison against ECC subagents. Use when measuring agent reliability, running benchmarks before/after prompt changes, or comparing new specialists to ECC baselines.
license: MIT
metadata:
  version: "1.0.0"
  author: AgentOS
  source: "https://github.com/NasrullaAmeen/AgentOS"
---

# AgentOS Eval

Measure whether specialist agents are reliable enough, and at what cost.

## What we measure

| Metric | Why | How |
|---|---|---|
| **Pass rate** | Does the agent produce usable output on the first attempt? | Human review + automated checks |
| **Retry rate** | How often does the agent need a follow-up? | Count reruns per task |
| **Token usage** | Context window consumption | Harness-level token counts |
| **Wall-clock time** | End-to-end latency | Timestamp at start / end |
| **Cost per run** | $ estimate from token counts | Multiply by model pricing |
| **Verdict accuracy** | Does `analysis` produce the right verdict? | Compare `ready-for-coding` verdicts against actual ECC handoff success |

## Eval protocol

1. **Pick a benchmark set** — 5–10 representative tasks per agent type.
2. **Run blind** — agent runs without human intervention, logged to `ops/eval/runs/<date>-<agent>-<slug>.json`.
3. **Score** — after each run, rate the output on:
   - **Correctness** (1–5): Are the facts right?
   - **Completeness** (1–5): Did it cover the expected sections?
   - **Actionability** (1–5): Can a coding agent act on this without rework?
   - **Conciseness** (1–5): No padding, no scope creep.
4. **Compare to baseline** — ECC's generic subagents as control group on analogous tasks.
5. **Report** — aggregate into `ops/eval/reports/<date>-report.md`.

## Run log schema

```json
{
  "timestamp": "2026-09-08T14:00:00Z",
  "agent": "github-research",
  "task": "Research Apify",
  "slug": "apify",
  "model": "claude-sonnet-4-20250514",
  "tokens_in": 12000,
  "tokens_out": 4500,
  "wall_clock_sec": 42,
  "retries": 0,
  "scores": {
    "correctness": 5,
    "completeness": 4,
    "actionability": 5,
    "conciseness": 4
  },
  "notes": "First pass passed all checks; minor gap in license analysis."
}
```

## Pass / fail criteria

- **Pass**: all four scores ≥ 3, no critical factual errors, output requires ≤1 minor edit.
- **Fail**: any score = 1, critical factual error, or output needs full rewrite.
- **Borderline**: any score = 2, or requires a substantive follow-up query.

## Baseline comparison

Run the same benchmark set against:
- ECC generic subagents (e.g., `web-research` from ECC vs our `web-research` wrapper)
- Plain LLM call without agent scaffolding (same prompt, no tool access)

Report deltas: `Δpass_rate`, `Δcost`, `Δtime`.

## Cadence

- **Per milestone**: run the eval suite before shipping a new specialist.
- **Monthly**: re-run the benchmark set to detect regression after prompt changes.
- **After incidents**: if an agent produces a bad output, add that task to the benchmark set.
