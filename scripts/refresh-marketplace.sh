#!/usr/bin/env bash
# Refresh the local marketplace clone that Cowork / Claude Desktop reads from.
#
# Cowork does NOT auto-pull from GitHub. The marketplace is a local git clone
# at ~/.claude/plugins/marketplaces/and-humans-skills, and it stays frozen
# until something runs `git pull` on it. This script is that something.
#
# Workflow after you push skill/agent changes to the repo:
#   1. ./scripts/refresh-marketplace.sh
#   2. Fully quit Claude Desktop (Cmd+Q) and reopen it
#   3. Customize → the "And humans" plugin → Update
#
# Run from anywhere.

set -euo pipefail

CLONE="$HOME/.claude/plugins/marketplaces/and-humans-skills"

if [[ ! -d "$CLONE/.git" ]]; then
  echo "error: marketplace clone not found at $CLONE" >&2
  echo "Cowork hasn't added the marketplace on this machine yet, or it lives" >&2
  echo "elsewhere. Add the marketplace via Cowork's UI first." >&2
  exit 1
fi

echo "[refresh] before: $(git -C "$CLONE" log --oneline -1)"

git -C "$CLONE" fetch --quiet origin
git -C "$CLONE" reset --hard --quiet origin/main

echo "[refresh] after:  $(git -C "$CLONE" log --oneline -1)"
echo
VERSION=$(grep -o '"version": *"[^"]*"' "$CLONE/plugins/and-humans/.claude-plugin/plugin.json" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
SKILLS=$(ls "$CLONE/plugins/and-humans/skills" 2>/dev/null | wc -l | tr -d ' ')
AGENTS=$(ls "$CLONE/plugins/and-humans/agents" 2>/dev/null | wc -l | tr -d ' ')
echo "[refresh] plugin.json version: $VERSION"
echo "[refresh] skills: $SKILLS   agents: $AGENTS"
echo
echo "Next: fully quit Claude Desktop (Cmd+Q), reopen, then click Update on the plugin."
