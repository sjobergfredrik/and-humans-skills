# and-humans-skills

Internal Claude Code plugin for and Humans. Strategy lenses, venture evaluation, client deliverables, document templates.

## Install

On any Mac with Claude Code:

```bash
git clone git@github.com:andhumans/and-humans-skills.git ~/Development/and-humans-skills
```

Then in Claude Code:

```
/plugin install ~/Development/and-humans-skills
```

Or, for the whole team, add the repo as a marketplace and let people pick.

## Structure

```
and-humans-skills/
├── .claude-plugin/
│   └── plugin.json        # plugin manifest
├── skills/                # one folder per skill, each with SKILL.md
│   └── <skill-name>/
│       └── SKILL.md
├── commands/              # optional slash commands (markdown files)
└── README.md
```

## Adding a skill

Use the skill-creator skill:

```
/anthropic-skills:skill-creator
```

Point it at `~/Development/and-humans-skills/skills/<skill-name>/` and it will scaffold the SKILL.md with proper frontmatter.

## Sync across machines

```bash
# After making changes
cd ~/Development/and-humans-skills
git add -A && git commit -m "add: <skill-name>" && git push

# On the other Mac
cd ~/Development/and-humans-skills
git pull
```

Claude Code re-reads plugins on session start, so a restart picks up new skills.

## Conventions

- One skill per folder under `skills/`.
- SKILL.md frontmatter must include `name` and a `description` that contains explicit trigger phrases ("Use when…", "Trigger on…").
- Keep skills under ~200 lines. If a skill grows past that, split it.
- Skills should be opinionated — generic skills belong in `anthropic-skills`, not here.
