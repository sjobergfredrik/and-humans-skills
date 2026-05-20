#!/usr/bin/env bash
# One-shot: push committed changes to GitHub, refresh the local marketplace
# clone Claude Desktop reads from, and optionally restart Claude Desktop.
#
# Why this script exists:
#   git push alone is NOT enough. Claude Desktop reads from a local clone at
#   ~/.claude/plugins/marketplaces/and-humans-skills, which doesn't auto-pull
#   from GitHub. Without `refresh-marketplace.sh`, the Update button stays
#   greyed out because Claude Desktop still sees the old commit.
#
# Usage:
#   ./scripts/ship.sh                # push + refresh, you handle Claude restart
#   ./scripts/ship.sh --restart      # also Cmd+Q and relaunch Claude Desktop
#   ./scripts/ship.sh --no-push      # only refresh + (optional) restart
#
# Run after you've already committed locally. This script doesn't commit for
# you on purpose — commit messages deserve thought.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESTART=0
DO_PUSH=1

for arg in "$@"; do
  case "$arg" in
    --restart) RESTART=1 ;;
    --no-push) DO_PUSH=0 ;;
    -h|--help)
      # Print the leading comment block (everything up to the first blank
      # non-comment line), stripped of leading '# '.
      awk 'NR==1{next} /^[^#]/{exit} {sub(/^# ?/,""); print}' "$0"
      exit 0
      ;;
    *) echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

cd "$REPO_ROOT"

# Bail if uncommitted changes — user should commit deliberately first.
if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: uncommitted changes in working tree." >&2
  echo "Commit them first, then re-run ship.sh:" >&2
  echo "  git add -A && git commit -m '...' && ./scripts/ship.sh" >&2
  exit 1
fi

if [[ "$DO_PUSH" == "1" ]]; then
  echo "[ship] pushing to origin..."
  git push
  # Push tags too if any new ones exist locally.
  git push --tags --quiet
fi

echo
"$REPO_ROOT/scripts/refresh-marketplace.sh"

if [[ "$RESTART" == "1" ]]; then
  echo
  echo "[ship] restarting Claude Desktop..."
  osascript -e 'tell application "Claude" to quit' 2>/dev/null || true
  # Wait for it to actually exit before relaunching.
  for _ in {1..20}; do
    if ! pgrep -x "Claude" >/dev/null; then break; fi
    sleep 0.25
  done
  open -a "Claude"
  echo "[ship] Claude Desktop relaunched. Click Update on the and-humans plugin."
else
  echo
  echo "[ship] done. Next:"
  echo "  1. Cmd+Q Claude Desktop (full quit, not just window close)"
  echo "  2. Reopen Claude Desktop"
  echo "  3. Customize → and Humans plugin → Update"
  echo
  echo "Or re-run with --restart to do steps 1–2 automatically."
fi
