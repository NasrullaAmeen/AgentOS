#!/usr/bin/env bash
# setup.sh — provision the AgentOS workspace on a clean machine
# Idempotent: safe to re-run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$SCRIPT_DIR"
AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"

echo "=== AgentOS Setup ==="
echo "Source:  $AGENTS_SRC"
echo "Target:  $AGENTS_HOME"
echo ""

# 1. Kernel doc
echo "[1/6] Kernel doc (AGENTS.md)"
mkdir -p "$AGENTS_HOME"
cp -n "$AGENTS_SRC/AGENTS.md" "$AGENTS_HOME/AGENTS.md" \
  || { echo "  exists — diffing"; diff "$AGENTS_SRC/AGENTS.md" "$AGENTS_HOME/AGENTS.md" >/dev/null 2>&1 || echo "  WARN: differs from source"; }

# 2. Runtime (prompts, commands, agents)
echo "[2/6] Agent OS runtime"
for sub in prompts commands agents; do
  mkdir -p "$AGENTS_HOME/os/$sub"
  cp -rn "$AGENTS_SRC/os/$sub/"* "$AGENTS_HOME/os/$sub/" 2>/dev/null || true
done

# 3. Data dirs (empty, created fresh)
echo "[3/6] Data dirs"
mkdir -p "$AGENTS_HOME/os/memory/human"
mkdir -p "$AGENTS_HOME/os/memory/ai/research"
mkdir -p "$AGENTS_HOME/os/memory/ai/logs"
mkdir -p "$AGENTS_HOME/os/data/logs"
mkdir -p "$AGENTS_HOME/os/data/decisions"
mkdir -p "$AGENTS_HOME/os/data/projects"
mkdir -p "$AGENTS_HOME/os/data/inbox"

# 4. Claude Code symlinks
echo "[4/6] Claude Code symlinks"
mkdir -p "$HOME/.claude"
ln -sfn "$AGENTS_HOME/AGENTS.md"          "$HOME/.claude/CLAUDE.md"
ln -sfn "$AGENTS_HOME/skills"             "$HOME/.claude/skills" 2>/dev/null || true
ln -sfn "$AGENTS_HOME/os/agents"          "$HOME/.claude/agents"
ln -sfn "$AGENTS_HOME/os/commands/os.md"  "$HOME/.claude/commands/os.md"
ln -sfn "$AGENTS_HOME/src/agent-os/commands/agent-os" "$HOME/.claude/commands/agent-os" 2>/dev/null || true

# 5. Clone upstream skills into src/ (agentcanon: symlinks, never copies)
echo "[5/6] Upstream clones (src/)"
clone_if_missing() {
  local dest="$AGENTS_HOME/src/$1"
  local url="$2"
  if [ ! -d "$dest/.git" ]; then
    echo "  cloning $1 ← $url"
    mkdir -p "$AGENTS_HOME/src"
    git clone --depth 1 "$url" "$dest" 2>/dev/null || { echo "  WARN: failed to clone $1"; return 1; }
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
  mkdir -p "$AGENTS_HOME/src"
  git clone --depth 1 https://github.com/tt-a1i/archify "$AGENTS_HOME/src/archify" 2>/dev/null || echo "  WARN: failed to clone archify"
else
  echo "  archify already present"
fi

# 6. Skill symlinks (agentcanon)
echo "[6/6] Skill symlinks"
mkdir -p "$AGENTS_HOME/skills"
ln -sfn "$AGENTS_HOME/src/agent-reach/agent_reach/skill" "$AGENTS_HOME/skills/agent-reach"
ln -sfn "$AGENTS_HOME/src/agent-skill"                  "$AGENTS_HOME/skills/lightpanda"
ln -sfn "$AGENTS_HOME/src/agent-skill/pandascript"      "$AGENTS_HOME/skills/lightpanda-pandascript"
ln -sfn "$AGENTS_HOME/src/archify/archify"              "$AGENTS_HOME/skills/archify"

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
