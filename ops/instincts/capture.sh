#!/usr/bin/env bash
# capture.sh — create a new instinct file
# Usage: ./capture.sh <id> <trigger> <domain> <scope>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTINCTS_DIR="$HOME/.agents/os/memory/ai/instincts"

if [ $# -lt 4 ]; then
  echo "Usage: $0 <id> <trigger> <domain> <scope>"
  echo "Example: $0 prefer-archify-for-diagrams \"when visualizing architecture\" tooling project"
  exit 1
fi

ID="$1"
TRIGGER="$2"
DOMAIN="$3"
SCOPE="$4"
DATE=$(date -u +"%Y-%m-%d")

TARGET_DIR="$INSTINCTS_DIR/$SCOPE"
mkdir -p "$TARGET_DIR"
OUTFILE="$TARGET_DIR/$ID.md"

if [ -f "$OUTFILE" ]; then
  echo "WARN: $OUTFILE already exists — editing in place"
  # Update last_observed
  sed -i "s/last_observed:.*/last_observed: $DATE/" "$OUTFILE"
  echo "Updated last_observed to $DATE"
else
  cat > "$OUTFILE" <<EOF
---
id: $ID
trigger: "$TRIGGER"
confidence: 0.3
domain: "$DOMAIN"
scope: $SCOPE
created: $DATE
last_observed: $DATE
---

# $ID

## Action
TODO: describe the learned behavior

## Evidence
- TODO: add observations

## Counter-evidence
- TODO: add counter-examples

## Promotion criteria
- Observed in 2+ projects → promote to global
- Confidence > 0.9 → consider evolving into a skill
EOF
  echo "Created: $OUTFILE"
fi
