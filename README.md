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

```
Edit in Cowork ── Cowork syncs across devices ── Run snapshot ── git commit/tag
     ↑                                                                  │
     └─────────────── If needed, restore by reverting ────────────────┘
```

### 1. Edit skills via Cowork

Use the Cowork UI or `/anthropic-skills:skill-creator` in Claude Desktop. Don't edit the local cache files directly — Cowork will overwrite them on next sync.

### 2. Snapshot the current state into the repo

```bash
cd ~/Development/and-humans-skills
./scripts/snapshot-from-cowork.sh
```

This reads Cowork's manifest, finds the `creatorType: user` skills, and rsyncs them into `plugins/and-humans/skills/`. Idempotent — safe to run repeatedly.

### 3. Review and commit

```bash
git status                            # what changed
git diff plugins/and-humans/skills/   # see the diff
git add -A
git commit -m "snapshot: field-lens v2 — added Abloh lens"
git push
```

### 4. Tag milestones

```bash
git tag -a v0.3.0 -m "v0.3.0 — Abloh lens added to field-lens"
git push origin v0.3.0
```

Tags become rollback points if a Cowork edit goes wrong.

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
│   └── snapshot-from-cowork.sh        # capture current state into repo
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
