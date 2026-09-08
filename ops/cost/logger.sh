#!/usr/bin/env bash
# cost-logger.sh — append a cost entry to ops/cost/runs/<date>.jsonl
# Usage: ./cost-logger.sh <agent> <task> <model> <tokens_in> <tokens_out> <wall_clock_sec> [slug] [verdict]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RUNS_DIR="$REPO_ROOT/ops/cost/runs"
mkdir -p "$RUNS_DIR"

if [ $# -lt 6 ]; then
  echo "Usage: $0 <agent> <task> <model> <tokens_in> <tokens_out> <wall_clock_sec> [slug] [verdict]"
  exit 1
fi

AGENT="$1"
TASK="$2"
MODEL="$3"
TOKENS_IN="$4"
TOKENS_OUT="$5"
WALL_CLOCK="$6"
SLUG="${7:-}"
VERDICT="${8:-}"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE=$(date -u +"%Y-%m-%d")
OUTFILE="$RUNS_DIR/$DATE.jsonl"

# Simple pricing (update as needed)
# Example: claude-sonnet-4 ~ $3/1M in, $15/1M out
USD_ESTIMATE=$(python3 -c "
in_m = $TOKENS_IN / 1_000_000
out_m = $TOKENS_OUT / 1_000_000
print(f'{(in_m * 3 + out_m * 15):.4f}')
")

cat <<EOF >> "$OUTFILE"
{"timestamp":"$TIMESTAMP","agent":"$AGENT","task":"$TASK","slug":"$SLUG","model":"$MODEL","tokens_in":$TOKENS_IN,"tokens_out":$TOKENS_OUT,"wall_clock_sec":$WALL_CLOCK,"retries":0,"usd_estimate":$USD_ESTIMATE,"verdict":"$VERDICT"}
EOF

echo "Logged: $OUTFILE"
