#!/usr/bin/env bash
# Sync the INSTALLED plugin to match the refreshed marketplace clone.
#
# Why this script exists:
#   refresh-marketplace.sh updates the *catalog* clone at
#   ~/.claude/plugins/marketplaces/and-humans-skills. But the skills Claude
#   actually loads come from a separate *install* at
#   ~/.claude/plugins/cache/and-humans-skills/and-humans/<version>/, pinned in
#   installed_plugins.json. Refreshing the catalog alone leaves the install
#   stale until someone clicks "Update" in the UI — and a skipped click means
#   removed skills (e.g. uu-docx) keep showing up.
#
#   This script does what the Update button does: copies the current plugin
#   tree into a version-named cache dir and repoints installed_plugins.json.
#   Idempotent — a no-op when the install already matches the catalog.
#
# Run from anywhere. Safe to run repeatedly.

set -euo pipefail

PLUGINS_DIR="$HOME/.claude/plugins"
CLONE="$PLUGINS_DIR/marketplaces/and-humans-skills"
SRC="$CLONE/plugins/and-humans"
MANIFEST="$PLUGINS_DIR/installed_plugins.json"
PLUGIN_KEY="and-humans@and-humans-skills"

if [[ ! -d "$SRC/.claude-plugin" ]]; then
  echo "error: marketplace clone not found at $CLONE" >&2
  echo "Run refresh-marketplace.sh first." >&2
  exit 1
fi
if [[ ! -f "$MANIFEST" ]]; then
  echo "error: installed_plugins.json not found — plugin isn't installed yet." >&2
  echo "Install it once via the /plugin UI, then this script keeps it in sync." >&2
  exit 1
fi

VERSION=$(python3 -c "import json,sys; print(json.load(open('$SRC/.claude-plugin/plugin.json'))['version'])")
SHA=$(git -C "$CLONE" rev-parse HEAD)
INSTALLED=$(python3 - "$MANIFEST" "$PLUGIN_KEY" <<'PY'
import json, sys
m, key = sys.argv[1], sys.argv[2]
d = json.load(open(m))
e = d.get("plugins", {}).get(key)
print(e[0].get("version", "") if e else "")
PY
)

if [[ "$INSTALLED" == "$VERSION" ]]; then
  echo "[sync] install already at v$VERSION — nothing to do."
  exit 0
fi

echo "[sync] installed v${INSTALLED:-none} -> catalog v$VERSION (sha ${SHA:0:7})"

DEST="$PLUGINS_DIR/cache/and-humans-skills/and-humans/$VERSION"
mkdir -p "$DEST"
# Copy content only — never .git or .in_use (runtime PID locks).
rsync -a --delete \
  --exclude='.git' --exclude='.in_use' \
  "$SRC/.claude-plugin" "$SRC/agents" "$SRC/prompts" "$SRC/skills" "$DEST/"

# Repoint the manifest, keeping a timestamped-free .bak for one-step rollback.
cp "$MANIFEST" "$MANIFEST.bak"
python3 - "$MANIFEST" "$PLUGIN_KEY" "$DEST" "$VERSION" "$SHA" <<'PY'
import json, sys, datetime
manifest, key, dest, version, sha = sys.argv[1:6]
d = json.load(open(manifest))
entry = d["plugins"][key][0]
entry["installPath"] = dest
entry["version"] = version
entry["gitCommitSha"] = sha
entry["lastUpdated"] = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")
json.dump(d, open(manifest, "w"), indent=2)
open(manifest, "a").write("\n")
PY

echo "[sync] install now at v$VERSION ($DEST)"
echo "[sync] manifest backed up to installed_plugins.json.bak"
echo "[sync] restart Claude (Cmd+Q / reopen, or new Code session) to load it."
