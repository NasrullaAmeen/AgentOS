---
name: agentos-cost
description: Track and report AgentOS run costs (tokens, wall-clock, USD estimates). Use when the user wants to measure cost per /os run, compare agent efficiency, or log token usage for an AgentOS session.
license: MIT
metadata:
  version: "1.0.0"
  author: AgentOS
  source: "https://github.com/NasrullaAmeen/AgentOS"
---

# AgentOS Cost

Track per-agent token usage, wall-clock time, and estimated cost for every `/os` run.

## Files

| File | Purpose |
|---|---|
| `ops/cost/schema.json` | JSON Schema for cost log entries |
| `ops/cost/logger.sh` | Append a cost entry to `ops/cost/runs/<date>.jsonl` |
| `ops/cost/runs/` | Daily JSONL files (one JSON object per line) |

## Usage

```bash
# After an agent run completes:
./ops/cost/logger.sh github-research "Research Apify" claude-sonnet-4-20250514 12000 4500 42 apify answer-only
```

Output: `ops/cost/runs/2026-09-08.jsonl`

## Pricing assumptions (update as needed)

| Model | Input $/1M | Output $/1M |
|---|---|---|
| claude-sonnet-4 | $3 | $15 |
| claude-opus-4 | $15 | $75 |
| gpt-4o | $2.5 | $10 |
| gemini-2.5-pro | $1.25 | $10 |

## Analysis

```bash
# Total cost per agent
jq -r '.agent' ops/cost/runs/*.jsonl | sort | uniq -c | sort -rn

# Average tokens per agent
jq -rs 'group_by(.agent)[] | {agent: .[0].agent, avg_in: (map(.tokens_in) | add / length), avg_out: (map(.tokens_out) | add / length)}' ops/cost/runs/*.jsonl

# Total daily spend
jq -rs 'map(.usd_estimate) | add' ops/cost/runs/*.jsonl
```

## Integration with /os

To auto-log costs, add a post-step in `os/commands/os.md` that calls `ops/cost/logger.sh` after each agent completes. This requires the harness to expose token counts — implement when the harness supports it.
