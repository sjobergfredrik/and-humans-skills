#!/usr/bin/env bash
# Snapshot the current Cowork skills cache into this repo for versioning.
#
# Cowork stores your skills server-side and syncs them to a local cache on
# each Mac. This script copies that cache into `plugins/and-humans/skills/`
# so you can `git diff`, commit, tag, and roll back.
#
# Cowork itself handles cross-device sync. This repo is for HISTORY, not
# distribution. Workflow:
#   1. Edit a skill via Cowork's UI (or `/anthropic-skills:skill-creator`)
#   2. Cowork syncs the new version to all your devices automatically
#   3. Run this script to capture the current state on disk
#   4. `git diff` to review what changed since last snapshot
#   5. Commit + push when satisfied
#
# Only `creatorType: user` skills are copied. Anthropic-authored skills
# (docx, pdf, pptx, xlsx, skill-creator, etc.) are theirs, not yours.

set -euo pipefail

# Find Cowork's skills directory. Walks the standard path; the UUIDs are
# stable per Cowork account but vary across machines.
COWORK_BASE="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"

if [[ ! -d "$COWORK_BASE" ]]; then
  echo "error: Cowork skills directory not found at $COWORK_BASE" >&2
  echo "Is Claude Desktop installed and Cowork enabled on this machine?" >&2
  exit 1
fi

# Auto-discover the <session-uuid>/<account-uuid>/skills path.
MANIFEST=$(find "$COWORK_BASE" -mindepth 3 -maxdepth 3 -name manifest.json | head -n 1)
if [[ -z "$MANIFEST" ]]; then
  echo "error: no manifest.json found under $COWORK_BASE" >&2
  exit 1
fi

SRC_DIR=$(dirname "$MANIFEST")/skills
REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
DST_DIR="$REPO_DIR/plugins/and-humans/skills"

echo "[snapshot] source:      $SRC_DIR"
echo "[snapshot] destination: $DST_DIR"
echo

# Extract user-authored skill names from the manifest.
USER_SKILLS=$(python3 -c "
import json
m = json.load(open('$MANIFEST'))
for s in m['skills']:
    if s.get('creatorType') == 'user' and s.get('enabled', True):
        print(s['name'])
")

if [[ -z "$USER_SKILLS" ]]; then
  echo "warning: no user-authored skills found in manifest" >&2
  exit 0
fi

echo "[snapshot] user-authored skills:"
echo "$USER_SKILLS" | sed 's/^/  - /'
echo

# rsync each one. --delete on the destination per skill so renames/removals
# in the source propagate cleanly.
mkdir -p "$DST_DIR"
while IFS= read -r skill; do
  if [[ ! -d "$SRC_DIR/$skill" ]]; then
    echo "  skip $skill (not in cache yet)" >&2
    continue
  fi
  rsync -a --delete "$SRC_DIR/$skill/" "$DST_DIR/$skill/"
  echo "  synced $skill"
done <<< "$USER_SKILLS"

echo
echo "[snapshot] done. Review with: git -C $REPO_DIR diff plugins/and-humans/skills/"
