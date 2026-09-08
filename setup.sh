#!/usr/bin/env bash
# setup.sh — provision the AgentOS workspace on a clean machine
# Idempotent: safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$SCRIPT_DIR"
AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"

DRY_RUN=false
SKIP_CLONES=false
UNINSTALL=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Provision the AgentOS workspace (~/.agents/) from this repo.

Options:
  --dry-run      Show what would be done, do not write anything
  --skip-clones  Skip cloning upstream repos into src/
  --uninstall    Remove ~/.agents symlinks and data dirs created by setup.sh
  -h, --help     Show this help
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)    DRY_RUN=true ;;
    --skip-clones) SKIP_CLONES=true ;;
    --uninstall)  UNINSTALL=true ;;
    -h|--help)    usage ;;
    *) echo "Unknown option: $arg"; usage ;;
  esac
done

if [ "$UNINSTALL" = true ]; then
  echo "=== AgentOS Uninstall ==="
  rm -f "$HOME/.claude/CLAUDE.md"
  rm -f "$HOME/.claude/agents"
  rm -f "$HOME/.claude/commands/os.md"
  rm -f "$HOME/.claude/commands/agent-os" 2>/dev/null || true
  rm -rf "$AGENTS_HOME/os/memory"
  rm -rf "$AGENTS_HOME/os/data"
  echo "Removed runtime data and Claude Code symlinks."
  echo "To fully remove, also delete:"
  echo "  rm -rf $AGENTS_HOME"
  echo "  rm -rf $HOME/.claude/skills"
  exit 0
fi

echo "=== AgentOS Setup ==="
echo "Source:  $AGENTS_SRC"
echo "Target:  $AGENTS_HOME"
[ "$DRY_RUN" = true ] && echo "*** DRY RUN — no changes will be made ***"
[ "$SKIP_CLONES" = true ] && echo "*** SKIP CLONES ***"
echo ""

run() {
  if [ "$DRY_RUN" = true ]; then
    echo "[dry-run] $*"
  else
    eval "$@"
  fi
}

# 1. Kernel doc
echo "[1/6] Kernel doc (AGENTS.md)"
run mkdir -p "$AGENTS_HOME"
if [ ! -f "$AGENTS_HOME/AGENTS.md" ]; then
  run cp "$AGENTS_SRC/AGENTS.md" "$AGENTS_HOME/AGENTS.md"
else
  echo "  exists — diffing against source"
  diff "$AGENTS_SRC/AGENTS.md" "$AGENTS_HOME/AGENTS.md" >/dev/null 2>&1 || echo "  WARN: differs from source (left in place)"
fi

# 2. Runtime (prompts, commands, agents)
echo "[2/6] Agent OS runtime"
for sub in prompts commands agents; do
  run mkdir -p "$AGENTS_HOME/os/$sub"
  run cp -rn "$AGENTS_SRC/os/$sub/"* "$AGENTS_HOME/os/$sub/" 2>/dev/null || true
done

# 3. Data dirs (empty, created fresh)
echo "[3/6] Data dirs"
run mkdir -p "$AGENTS_HOME/os/memory/human"
run mkdir -p "$AGENTS_HOME/os/memory/ai/research"
run mkdir -p "$AGENTS_HOME/os/memory/ai/logs"
run mkdir -p "$AGENTS_HOME/os/data/logs"
run mkdir -p "$AGENTS_HOME/os/data/decisions"
run mkdir -p "$AGENTS_HOME/os/data/projects"
run mkdir -p "$AGENTS_HOME/os/data/inbox"

# 4. Claude Code symlinks
echo "[4/6] Claude Code symlinks"
run mkdir -p "$HOME/.claude"
run ln -sfn "$AGENTS_HOME/AGENTS.md"          "$HOME/.claude/CLAUDE.md"
run ln -sfn "$AGENTS_HOME/skills"             "$HOME/.claude/skills" 2>/dev/null || true
run ln -sfn "$AGENTS_HOME/os/agents"          "$HOME/.claude/agents"
run ln -sfn "$AGENTS_HOME/os/commands/os.md"  "$HOME/.claude/commands/os.md"
run ln -sfn "$AGENTS_HOME/src/agent-os/commands/agent-os" "$HOME/.claude/commands/agent-os" 2>/dev/null || true

# 5. Clone upstream skills into src/ (agentcanon: symlinks, never copies)
if [ "$SKIP_CLONES" = false ]; then
  echo "[5/6] Upstream clones (src/)"
  clone_if_missing() {
    local dest="$AGENTS_HOME/src/$1"
    local url="$2"
    if [ ! -d "$dest/.git" ]; then
      echo "  cloning $1 ← $url"
      run mkdir -p "$AGENTS_HOME/src"
      run git clone --depth 1 "$url" "$dest" 2>/dev/null || { echo "  WARN: failed to clone $1"; return 1; }
    else
      echo "  $1 already present"
    fi
  }

  clone_if_missing "agent-os"    "https://github.com/buildermethods/agent-os" || true
  clone_if_missing "bm-skills"   "https://github.com/buildermethods/bm-skills" || true
  clone_if_missing "agentcanon"  "https://github.com/buildermethods/agentcanon" || true
  clone_if_missing "agent-reach" "https://github.com/Panniantong/agent-reach" || true
  clone_if_missing "agent-skill" "https://github.com/lightpanda-io/agent-skill" || true

  # archify is inside a subdir
  if [ ! -d "$AGENTS_HOME/src/archify/archify/.git" ]; then
    echo "  cloning archify ← https://github.com/tt-a1i/archify"
    run mkdir -p "$AGENTS_HOME/src"
    run git clone --depth 1 https://github.com/tt-a1i/archify "$AGENTS_HOME/src/archify" 2>/dev/null || echo "  WARN: failed to clone archify"
  else
    echo "  archify already present"
  fi
else
  echo "[5/6] Upstream clones (skipped)"
fi

# 6. Skill symlinks (agentcanon)
echo "[6/6] Skill symlinks"
run mkdir -p "$AGENTS_HOME/skills"
run ln -sfn "$AGENTS_HOME/src/agent-reach/agent_reach/skill" "$AGENTS_HOME/skills/agent-reach"
run ln -sfn "$AGENTS_HOME/src/agent-skill"                  "$AGENTS_HOME/skills/lightpanda"
run ln -sfn "$AGENTS_HOME/src/agent-skill/pandascript"      "$AGENTS_HOME/skills/lightpanda-pandascript"
run ln -sfn "$AGENTS_HOME/src/archify/archify"              "$AGENTS_HOME/skills/archify"

# Summary
echo ""
echo "=== Setup complete ==="
echo "Kernel:   $AGENTS_HOME/AGENTS.md"
echo "Runtime:  $AGENTS_HOME/os/{prompts,commands,agents}"
echo "Skills:   $AGENTS_HOME/skills/ (symlinks → src/)"
echo "Data:     $AGENTS_HOME/os/data/{logs,decisions,projects,inbox}"
echo ""
echo "Next:"
echo "  1. Restart opencode + Claude Code to load agents/commands"
echo "  2. Install tools: agent-reach (uv), lightpanda (install.sh), archify (node bin/), rdt-cli (pipx)"
echo "  3. Register MCP + config additions per docs/installation.md"
