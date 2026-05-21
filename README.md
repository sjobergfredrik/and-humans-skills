# and-humans-skills

Version-controlled mirror of Fredrik's Cowork skills. Strategy lenses, venture evaluation, client deliverables, document templates, and the canonical consulting-agent prompt.

## What this repo is

**This repo is the single source of truth for the skills, packaged as a Claude plugin.** Both Claude Code and Cowork install it the same way — as a marketplace plugin (`.claude-plugin/marketplace.json` + `plugins/and-humans/plugin.json`). There is **one** distribution system, surfaced in two places in Claude Desktop:

- **Cowork** → sidebar **+ → Create plugin → Add marketplace** (lands under *Personal plugins*; its skills appear in the top-level *Skills* list)
- **Claude Code** → `/plugin marketplace add` + `/plugin install`

Both read from the same local clone at `~/.claude/plugins/marketplaces/and-humans-skills`. Installing or updating in one surface affects the other.

On top of being the plugin, the repo gives you:

- **History** — `git log` shows every prompt revision over time
- **Diffs** — review exactly what changed between two versions of a skill
- **Backup / disaster recovery** — if skills get deleted, reinstall the plugin (see [Restoring](#restoring-after-deletion))
- **Tags** — pin a known-good state with `v0.1.0`, `v0.2.0`, etc.
- **Visibility** — all 11 skills as plain markdown files in one place

## Skills in this plugin

These are the `and-humans` skills — and Humans' own *methodology* IP. Client-specific delivery tooling (document templates that embed a client's brand/logo) lives in a separate **private** repo, [`and-humans-delivery`](https://github.com/sjobergfredrik/and-humans-delivery), so this public repo stays a clean showcase of method, not client assets. Anthropic-authored skills (`docx`, `pdf`, `pptx`, `xlsx`, `skill-creator`, etc.) are theirs and live elsewhere.

Current set:

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
| `creative-prompt-matrix` | Batch image prompt generation |
| `agent-architecture-advisor` | Agent framework decision framework |

## Workflow

The repo is the source of truth. Edit files here, commit, ship, click Update. There's no "paste back into Cowork" step — Cowork installs the plugin from this repo like any other.

```
Edit files here → commit → ship.sh → click Update on the and-humans plugin
```

`ship.sh` pushes to GitHub **and** refreshes the local marketplace clone Claude Desktop reads from. Without that refresh, `git push` alone does nothing visible — see [Why ship.sh exists](#why-shipsh-exists) below.

```bash
cd ~/Development/and-humans-skills

# 1. Edit SKILL.md, swap assets, add a skill, bump plugin.json version, etc.
# 2. Commit:
git add -A
git commit -m "field-lens: add new lens to the reference"

# 3. Ship — pushes + refreshes the local marketplace clone:
./scripts/ship.sh --restart    # --restart also Cmd+Qs and relaunches Claude Desktop

# 4. In Claude Desktop: click Update on the and-humans plugin
#    (Cowork: Personal plugins → and-humans → Update)
#    (Claude Code: /plugin update and-humans)
```

> **Bump `plugin.json` version on every functional change** — Claude Desktop's Update button only lights up when the version is higher than what's installed.

### Editing skills inside Cowork's UI (rare)

If you ever create or edit a skill directly in Cowork's skill-creator UI instead of in the repo, run `./scripts/snapshot-from-cowork.sh` to pull that change back into the repo before committing. But the normal direction is repo → Cowork, not the reverse.

### Tag milestones

```bash
git tag -a v0.4.0 -m "v0.4.0 — short description of the change"
git push origin v0.4.0
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

## Restoring after deletion

**If you delete the skills in Cowork (or Claude Code), they are NOT gone — this repo is the backup.** Deleting *user-created* skills in Cowork's UI is irreversible server-side, but because the skills ship as a plugin, you restore them by reinstalling the plugin:

1. Cowork: **+ → Create plugin → Add marketplace** → enter `sjobergfredrik/and-humans-skills` → install **and-humans**
2. All skills (with reference files and assets) come back intact

This is exactly how the May 2026 accidental-deletion incident was recovered. No manual re-pasting needed.

**To roll back a single skill to an older version** (undo a bad edit):

```bash
git log --oneline plugins/and-humans/skills/field-lens/SKILL.md   # find the good commit
git checkout <commit-sha> -- plugins/and-humans/skills/field-lens/SKILL.md
git commit -am "revert field-lens to <sha>"
./scripts/ship.sh --restart                                       # then click Update
```

> **Safety habit:** before any destructive Cowork edit, tag the repo —
> `git tag -a pre-cleanup -m "before deleting Cowork skills"` — so "undo" is one command.

## On a new Mac (e.g. the Mac mini)

1. Install Claude Desktop, sign in with `fredrik@andhumans.se`
2. **Add the plugin:** Cowork → **+ → Create plugin → Add marketplace** → `sjobergfredrik/and-humans-skills` → install **and-humans**
   - (Headless / Claude Code: `/plugin marketplace add sjobergfredrik/and-humans-skills` then `/plugin install and-humans@and-humans-skills`)
3. The 11 skills appear in the Skills list, ready to use

To also develop on that machine, clone the repo:

```bash
git clone git@github.com:sjobergfredrik/and-humans-skills.git ~/Development/and-humans-skills
```

To pull plugin updates on that machine later, run `./scripts/refresh-marketplace.sh` (or click Update in Claude Desktop if it can fetch — `refresh-marketplace.sh` is the guaranteed path).

## Repo layout

```
and-humans-skills/
├── .claude-plugin/marketplace.json    # Claude Code marketplace manifest
├── plugins/and-humans/
│   ├── .claude-plugin/plugin.json     # plugin manifest
│   ├── skills/                        # the skills — source of truth
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
