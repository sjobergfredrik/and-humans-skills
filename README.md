# and-humans-skills

Version-controlled mirror of Fredrik's Cowork skills. Strategy lenses, venture evaluation, client deliverables, document templates, and the canonical consulting-agent prompt.

## What this repo is (and isn't)

**Cowork handles cross-device sync.** When you log into Claude Desktop / Cowork on a new Mac, your skills appear automatically — they live on Anthropic's servers, not on local files. This repo isn't doing that sync.

**This repo is for versioning.** It gives you:

- **History** — `git log` shows every prompt revision over time
- **Diffs** — review exactly what changed between two versions of a skill
- **Backup** — restore a botched edit by reverting a commit
- **Tags** — pin a known-good state with `v0.1.0`, `v0.2.0`, etc.
- **Visibility** — see all 11 skills as plain markdown files in one place

## Skills mirrored here

Only `creatorType: user` skills from Cowork's manifest are mirrored. Anthropic-authored skills (`docx`, `pdf`, `pptx`, `xlsx`, `skill-creator`, etc.) are theirs and are not copied.

Current set (v0.2.0):

| Skill | Purpose |
|---|---|
| `field-lens` | Strategic field reading (Bourdieu, Wardley, Fligstein, Paine, Abloh) |
| `wardley-strategist` | Wardley mapping sparring partner |
| `venture-stress-test` | Structured business-idea evaluation |
| `synthetic-users` | Research-grounded persona generation |
| `company-analyzer` | Swedish company analysis via allabolag.se |
| `todo-capture` | Capture action items to Notion Tasks DB |
| `todo-connect` | Link tasks to field-kit strategic context |
| `todo-review` | Weekly/daily task review and prioritization |
| `uu-docx` | Uppsala University Word template generator |
| `creative-prompt-matrix` | Batch image prompt generation |
| `agent-architecture-advisor` | Agent framework decision framework |

## Workflow

There are **two paths** depending on whether you're editing inside Cowork's UI or directly in this repo:

```
Path A (Cowork-first):
  Edit in Cowork → snapshot-from-cowork.sh → commit → ship.sh → Update in Claude

Path B (Repo-first):
  Edit files here → commit → ship.sh → Update in Claude → (later) paste back into Cowork
```

Both end at the same place: `ship.sh` pushes to GitHub **and** refreshes the local marketplace clone Claude Desktop reads from. Without that refresh, `git push` alone does nothing visible — see [Why ship.sh exists](#why-shipsh-exists) below.

### Path A — Cowork-first (preferred for prose-only edits)

```bash
cd ~/Development/and-humans-skills

# 1. Edit in Cowork UI or via /anthropic-skills:skill-creator in Claude Desktop.
# 2. Capture the change into this repo:
./scripts/snapshot-from-cowork.sh

# 3. Review and commit:
git status
git diff plugins/and-humans/skills/
git add -A
git commit -m "snapshot: field-lens v2 — added Abloh lens"

# 4. Ship — pushes + refreshes the local marketplace clone:
./scripts/ship.sh              # or ./scripts/ship.sh --restart
```

### Path B — Repo-first (preferred when editing assets, bumping plugin.json, or letting Claude Code edit files directly)

```bash
cd ~/Development/and-humans-skills

# 1. Edit SKILL.md, swap assets, bump plugin.json version, etc.
# 2. Commit:
git add -A
git commit -m "uu-docx: swap to May 2026 mall.docx template"

# 3. Ship:
./scripts/ship.sh --restart

# 4. (Optional) Paste the new SKILL.md back into Cowork's skill-creator UI
#    so the server-side copy matches. Not required for the local plugin to work.
```

### Tag milestones

```bash
git tag -a v0.3.0 -m "v0.3.0 — uu-docx new template"
git push origin v0.3.0
```

Tags become rollback points if a Cowork edit goes wrong. (`ship.sh` already pushes tags for you on subsequent runs.)

---

### Why ship.sh exists

Claude Desktop doesn't read from GitHub. It reads from a local git clone at
`~/.claude/plugins/marketplaces/and-humans-skills`, and that clone stays
frozen until something runs `git pull` on it.

So a bare `git push` looks like it worked — the commit is on GitHub — but
the Update button in Claude Desktop stays greyed out because the local
clone is still on the old commit. The first time this bites you, you'll
restart Claude Desktop, click Update, see nothing happen, and wonder if
the universe is broken. It isn't. Just run `ship.sh`.

`ship.sh` does three things:

1. `git push` (and `git push --tags`)
2. Run `refresh-marketplace.sh` to `git pull` the local clone
3. With `--restart`: `Cmd+Q` + relaunch Claude Desktop via `osascript`

After it runs, click **Customize → and Humans → Update** in Claude Desktop.

## Restoring a previous version

If Cowork loses or corrupts a skill (or you want to undo an edit):

```bash
# Find the version you want
git log --oneline plugins/and-humans/skills/field-lens/SKILL.md

# Check out that version
git checkout <commit-sha> -- plugins/and-humans/skills/field-lens/SKILL.md

# Then paste it back into Cowork's skill-creator UI to restore it server-side
```

(There's no automated push-back to Cowork — it goes through the UI. If we ever build that automation, it lives in `scripts/`.)

## On a new Mac

Cowork's own sync makes your skills available the moment you sign in — no action required.

To also have the versioned repo on the new machine:

```bash
git clone git@github.com:sjobergfredrik/and-humans-skills.git ~/Development/and-humans-skills
```

That's it. The snapshot script will work from any Mac with Cowork installed.

## Repo layout

```
and-humans-skills/
├── .claude-plugin/marketplace.json    # Claude Code marketplace manifest
├── plugins/and-humans/
│   ├── .claude-plugin/plugin.json     # plugin manifest
│   ├── skills/                        # mirrored from Cowork (gitignored re-snapshot)
│   │   ├── field-lens/
│   │   ├── venture-stress-test/
│   │   └── ...
│   ├── prompts/
│   │   └── consulting-agent.md        # canonical, consumed by AskBox + field-kit
│   └── commands/
├── scripts/
│   ├── snapshot-from-cowork.sh        # capture Cowork state into repo
│   ├── refresh-marketplace.sh         # git pull the local marketplace clone
│   └── ship.sh                        # push + refresh (+ optional Claude restart)
└── README.md
```

## Consulting-agent prompt (bonus)

`plugins/and-humans/prompts/consulting-agent.md` is the single source of truth for the field-kit consulting agent persona. Three surfaces consume it:

1. **AskBox** (`fredriksjoberg-eu`) — `prebuild` script fetches it from GitHub before each Vercel build
2. **field-kit** — `scripts/sync_prompt.py` fetches it on demand
3. **Cowork** — not yet wired; the skills themselves carry the prompt-flavor

## Versioning convention

- **Patch** (`v0.1.x`) — wording tweaks, typo fixes, small clarifications
- **Minor** (`v0.x.0`) — new skill added, meaningful behavioral change to an existing skill
- **Major** (`vx.0.0`) — breaking change to skill structure, repo layout, or sync workflow

Bumping is manual — `git tag -a vX.Y.Z -m "..." && git push origin vX.Y.Z`.
