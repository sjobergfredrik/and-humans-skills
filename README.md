# and-humans-skills

Internal Claude Code marketplace for and Humans. Hosts the `and-humans` plugin: strategy lenses, venture evaluation, client deliverables, document templates, and the canonical consulting-agent prompt shared by AskBox and field-kit.

## Install (Claude Code)

In any Claude Code session:

```
/plugin marketplace add sjobergfredrik/and-humans-skills
/plugin install and-humans@and-humans-skills
```

To update later:

```
/plugin marketplace update and-humans-skills
```

## Repo layout

```
and-humans-skills/
├── .claude-plugin/
│   └── marketplace.json              # lists plugins in this repo
└── plugins/
    └── and-humans/
        ├── .claude-plugin/
        │   └── plugin.json           # plugin manifest
        ├── skills/                   # one folder per skill, each with SKILL.md
        │   └── <skill-name>/
        │       └── SKILL.md
        ├── prompts/                  # raw prompts (no SKILL.md frontmatter)
        │   └── consulting-agent.md   # canonical, consumed by AskBox + field-kit
        └── commands/                 # optional slash commands
```

## Canonical consulting-agent prompt

`plugins/and-humans/prompts/consulting-agent.md` is the single source of truth for the and Humans agent persona. Three surfaces consume it:

1. **Claude Code** — installed via the plugin, available as a skill.
2. **AskBox** (`fredriksjoberg-eu`) — `predeploy` script curls the raw file from GitHub:
   ```
   https://raw.githubusercontent.com/sjobergfredrik/and-humans-skills/main/plugins/and-humans/prompts/consulting-agent.md
   ```
3. **field-kit** — `prompts/HEAD` points to this same file (symlink or fetch).

Pin to a tag (e.g. `v0.3.0/...` instead of `main/...`) when you want deploy-time version control.

## Adding a skill

```
/anthropic-skills:skill-creator
```

Point it at `plugins/and-humans/skills/<skill-name>/`. The frontmatter must contain a `description` with explicit trigger phrases ("Use when…", "Trigger on…").

## Sync across machines

```bash
# After changes
cd ~/Development/and-humans-skills
git add -A && git commit -m "add: <skill-name>" && git push

# On the other Mac
cd ~/Development/and-humans-skills
git pull
# Then in Claude Code: /plugin marketplace update and-humans-skills
```

## Conventions

- One skill per folder under `plugins/and-humans/skills/`.
- Keep skills under ~200 lines. Split if larger.
- Skills should be opinionated to and Humans — generic skills belong in `anthropic-skills`, not here.
- Version the plugin (`plugin.json` → `version`) when changing the consulting-agent prompt or breaking skill behavior.
