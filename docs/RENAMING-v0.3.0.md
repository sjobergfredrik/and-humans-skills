# Skill renaming plan — v0.3.0

Status: **proposed, not executed.** This is the design doc; execution happens via Cowork's skill-creator UI, one skill at a time, with snapshots between.

## Why rename

The current 11 skills use three competing naming conventions (method-named, subject-named, action-named) with no rhythm. Spontaneous invocation suffers because your brain has to remember which convention each skill uses. Aligning naming to one model lowers that load.

## The chosen convention (two-layer flat)

**Field skills** (strategic lenses, eventual ingredients of Field Station's `Investigation` module) get **bare single-noun-or-verb names.**

**Operational skills** (everyday workflow, document templates, family-grouped capabilities) get **`namespace:verb` form** to cluster naturally — *if* Cowork and the path layer accept `:` (see probe below).

## Open question — does `:` survive?

Two things need to work for `:` namespacing:

1. **Cowork's skill name validator.** When you go to skill-creator and try to save a skill named `todo:add`, does it accept the colon, normalize it, or reject?
2. **The mount path `/mnt/skills/user/<name>/`.** Several skills (notably `uu-docx`) reference their own assets by path. If the skill name becomes part of a filesystem path and contains `:`, downstream tooling could choke.

### Probe — do this once before anything else

1. Open Cowork's skill-creator and create a throwaway test skill named **`test:probe`** with one-line content.
2. After save, run `./scripts/snapshot-from-cowork.sh` and check `plugins/and-humans/skills/` — did Cowork accept `test:probe` as a folder name? Or did it normalize to `test-probe` / `test_probe`?
3. Also check `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/.../manifest.json` for the `name` field as Cowork stored it.
4. Delete the test skill.

**Decision rule:**
- If Cowork stores `test:probe` as `test:probe` everywhere → use `:` namespace.
- If Cowork rejects or normalizes → fall back to `-`. The model becomes `todo-add` / `doc-uu` / `image-matrix` instead. Functionally equivalent, slightly less elegant.

This doc assumes `:` works. Search-and-replace `:` → `-` if the probe says otherwise.

## Old → new mapping

### Layer 1 — Field skills

| Old name | New name | Said as |
|---|---|---|
| `field-lens` | `field-read` | "do a field reading" |
| `wardley-strategist` | `wardley` | "map this with Wardley" |
| `venture-stress-test` | `stress-test` | "stress-test this idea" |
| `synthetic-users` | `personas` | "give me personas" |
| `agent-architecture-advisor` | `agent-stack` | "what agent stack?" |

### Layer 2 — Operational skills

| Old name | New name | Said as |
|---|---|---|
| `todo-capture` | `todo:add` | "todo: add" / "capture this" |
| `todo-connect` | `todo:link` | "link to context" |
| `todo-review` | `todo:review` | "review my todos" |
| `company-analyzer` | `company:check` | "check this company" |
| `uu-docx` | `doc:uu` | "make a UU doc" |
| `creative-prompt-matrix` | `image:matrix` | "image prompts for…" |

## Cross-references that need updating

Each renamed skill is referenced *by name* inside other skills' SKILL.md descriptions and bodies. Those references must update at the same time, or you get phantom skills.

### Inside `field-read` (formerly `field-lens`)
- `field-lens` → `field-read` (frontmatter `name`, and any self-reference in description)
- `wardley-strategist` → `wardley` (lines ~15, ~194, ~195)
- `venture-stress-test` → `stress-test` (lines ~15, ~186)
- `synthetic-users` → `personas` (line ~190)
- Swedish trigger `"fältläsning"` stays as-is — still a valid trigger phrase

### Inside `personas` (formerly `synthetic-users`)
- `synthetic-users` → `personas` (frontmatter `name`)
- `venture-stress-test` → `stress-test` (lines ~84, ~176, ~179)
- `wardley-strategist` → `wardley` (line ~182)

### Inside `stress-test` (formerly `venture-stress-test`)
- `venture-stress-test` → `stress-test` (frontmatter `name`)
- `company-analyzer` → `company:check` (line ~99)
- `wardley-strategist` → `wardley` (line ~116)
- `todo-capture` → `todo:add` (line ~228)

### Inside `todo:add` (formerly `todo-capture`)
- `todo-capture` → `todo:add` (frontmatter `name`)
- `todo-review` → `todo:review` (description + line ~134-ish)
- `todo-connect` → `todo:link` (description + line ~134-ish)

### Inside `todo:link` (formerly `todo-connect`)
- `todo-connect` → `todo:link` (frontmatter `name`)
- `todo-capture` → `todo:add` (description + lines ~113-114)
- `todo-review` → `todo:review` (description + line ~114)

### Inside `todo:review` (formerly `todo-review`)
- `todo-review` → `todo:review` (frontmatter `name`)
- `todo-capture` → `todo:add` (description + line ~115)
- `todo-connect` → `todo:link` (description + line ~116)

### Inside `doc:uu` (formerly `uu-docx`)
- `uu-docx` → `doc:uu` (frontmatter `name`)
- `/mnt/skills/user/uu-docx/assets/uu_template.dotx` → `/mnt/skills/user/doc:uu/assets/uu_template.dotx` (lines ~54, ~211)
- **Verify** the `:` in the mount path works at runtime. If not, this skill keeps the `-` form: `doc-uu`.

### Inside `wardley`, `agent-stack`, `company:check`, `image:matrix`
- Only the frontmatter `name` field changes. No external references in their bodies.

## Execution order

Do them in **dependency order — leaves first, roots last** — so you never have a half-renamed cross-reference graph.

1. **`agent-architecture-advisor` → `agent-stack`** (no incoming references; safest first)
2. **`creative-prompt-matrix` → `image:matrix`** (no incoming references)
3. **`company-analyzer` → `company:check`** (referenced only by `venture-stress-test`)
4. **`uu-docx` → `doc:uu`** (only self-referential assets path) — *and verify the mount path works.*
5. **`todo-review` → `todo:review`**
6. **`todo-connect` → `todo:link`**
7. **`todo-capture` → `todo:add`** (now updates the other two `todo:*` skills' cross-references)
8. **`wardley-strategist` → `wardley`** (referenced by `field-lens`, `synthetic-users`, `venture-stress-test`)
9. **`synthetic-users` → `personas`** (referenced by `field-lens`, `venture-stress-test`)
10. **`venture-stress-test` → `stress-test`** (referenced by `field-lens`, `synthetic-users`)
11. **`field-lens` → `field-read`** (last — only references outgoing)

After each rename in Cowork:

```bash
cd ~/Development/and-humans-skills
./scripts/snapshot-from-cowork.sh
git diff plugins/and-humans/skills/   # confirm the rename landed
git add -A
git commit -m "rename: <old> → <new>"
```

After all 11 land:

```bash
git tag -a v0.3.0 -m "v0.3.0 — naming convention pass"
git push origin main v0.3.0
```

## What I'd watch for

- **Cowork's behavior on rename.** Does renaming a skill via skill-creator preserve history, or does it create a new skill and orphan the old one? If orphaned, you'd see two folders post-snapshot — manually delete the old via Cowork.
- **Slash-command muscle memory.** You may still type `/and-humans:wardley-strategist` for a week. That's normal. The trigger phrases in the description do the actual work for description-match invocations.
- **Notion / external integrations.** `todo:*` skills write to Notion. Confirm the skill rename doesn't break any keyed-by-skill-name lookup. (Spot-check the first `todo:*` rename before doing the other two.)

## Rollback

If something breaks mid-pass, every skill's previous version is still in git history. Pick the SHA from `git log` and use Cowork's skill-creator to restore the old SKILL.md body. Or revert the commit and snapshot back.
