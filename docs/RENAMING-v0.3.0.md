# Skill renaming plan — v0.3.0

Status: **proposed, not executed.** Each rename happens in Cowork's skill-creator UI, with a snapshot+commit between.

## Probe outcome (2026-05-15)

Cowork **rejects `:` in skill names.** Both the directory layer and the YAML `name` frontmatter enforce kebab-case. Decision: **no namespacing, all names use `-`.**

Also: descriptions below ~50 chars risk not loading reliably. Keep descriptions at ≥80 chars with explicit trigger phrases.

## Why rename

The current 11 skills mix three conventions (method-named, subject-named, action-named). Spontaneous invocation suffers. Aligning the strategic-lens cluster to short, sayable names lowers cognitive load.

The `todo-*` trio is already coherent and verb-correct — those stay.

## The convention

- **Layer 1 — Field skills** (strategic lenses, eventual ingredients of Field Station's `Investigation` module): short single-noun-or-verb names. Goal: matches how you'd say it out loud.
- **Layer 2 — Operational skills**: `family-verb` form when there's a family, otherwise descriptive kebab-case.

## Renames

### Layer 1 — Field skills (5)

| Old | New | Said as |
|---|---|---|
| `field-lens` | `field-read` | "do a field reading" |
| `wardley-strategist` | `wardley` | "map this with Wardley" |
| `venture-stress-test` | `stress-test` | "stress-test this idea" |
| `synthetic-users` | `personas` | "give me personas" |
| `agent-architecture-advisor` | `agent-stack` | "what agent stack?" |

### Layer 2 — Operational (3)

| Old | New | Said as |
|---|---|---|
| `company-analyzer` | `company-check` | "check this company" |
| `uu-docx` | `doc-uu` | "make a UU doc" |
| `creative-prompt-matrix` | `image-matrix` | "image prompts for…" |

### Keep as-is

- `todo-capture`, `todo-connect`, `todo-review` — already a coherent family, verbs are correct.

**Total renames: 8.**

## Cross-references that need updating in renamed skills' bodies

Each renamed skill is referenced by name inside other skills' SKILL.md descriptions and bodies. References must update alongside the rename, or you get phantom skills.

### Inside `field-read` (was `field-lens`)
- frontmatter `name: field-lens` → `name: field-read`
- description: `"field-lens"` trigger string (line ~10) → `"field-read"`
- body line ~15: `wardley-strategist` → `wardley`, `venture-stress-test` → `stress-test`
- body line ~16: `field-lens feeds into both` → `field-read feeds into both`
- body line ~186: `field-lens → venture-stress-test` → `field-read → stress-test`
- body line ~190: `field-lens → synthetic-users` → `field-read → personas`
- body lines ~194–195: `field-lens → wardley-strategist` → `field-read → wardley`
- Swedish trigger `"fältläsning"` stays — still a valid trigger

### Inside `personas` (was `synthetic-users`)
- frontmatter `name: synthetic-users` → `name: personas`
- body line ~84: `venture-stress-test` → `stress-test`
- body line ~176: `venture-stress-test → synthetic-users` → `stress-test → personas`
- body line ~179: `synthetic-users → venture-stress-test` → `personas → stress-test`
- body line ~182: `wardley-strategist` → `wardley`

### Inside `stress-test` (was `venture-stress-test`)
- frontmatter `name: venture-stress-test` → `name: stress-test`
- body line ~99: `company-analyzer` → `company-check`
- body line ~116: `wardley-strategist` → `wardley`
- body line ~228: `todo-capture` stays (not renamed)

### Inside `doc-uu` (was `uu-docx`)
- frontmatter `name: uu-docx` → `name: doc-uu`
- body line ~54: `/mnt/skills/user/uu-docx/assets/uu_template.dotx` → `/mnt/skills/user/doc-uu/assets/uu_template.dotx`
- body line ~211: same path swap

### Inside `wardley`, `agent-stack`, `company-check`, `image-matrix`
- Only frontmatter `name` changes. No internal cross-references.

### Outside the rename set — also needs touching

- `todo-capture` SKILL.md (line ~134) references `todo-connect` — **no change needed** (todo-connect stays).
- `todo-connect` SKILL.md (line ~113-114) references `todo-capture` and `todo-review` — **no change**.
- `todo-review` SKILL.md (lines ~115-116) references `todo-capture` and `todo-connect` — **no change**.

The todo trio insulates itself from this rename pass. Nice.

## Execution order

Leaves first (skills nothing references), roots last (skills lots of things reference). This keeps the cross-reference graph consistent at every step.

1. **`agent-architecture-advisor` → `agent-stack`** — no incoming references. Safest first.
2. **`creative-prompt-matrix` → `image-matrix`** — no incoming references.
3. **`uu-docx` → `doc-uu`** — only self-references (the assets mount path). Verify the path still resolves at runtime after the rename.
4. **`company-analyzer` → `company-check`** — only `venture-stress-test` references it; we'll update that in step 8.
5. **`wardley-strategist` → `wardley`** — referenced by field-lens, synthetic-users, venture-stress-test.
6. **`synthetic-users` → `personas`** — referenced by field-lens, venture-stress-test.
7. **`venture-stress-test` → `stress-test`** — referenced by field-lens, synthetic-users.
8. **`field-lens` → `field-read`** — last. Only outgoing references; updating its body cleans up the trail of the previous renames.

### Per-rename procedure

For each skill, in this order:

1. In Cowork's skill-creator: rename the skill. Update the `name:` frontmatter. Update any internal cross-references in the body (see section above for exact lines).
2. Save.
3. Locally:
   ```bash
   cd ~/Development/and-humans-skills
   ./scripts/snapshot-from-cowork.sh
   git status                            # confirm old folder gone, new folder appeared
   git diff plugins/and-humans/skills/   # eyeball the diff
   git add -A
   git commit -m "rename: <old> → <new>"
   ```
4. Spot-check the skill works in Chat ("hey, do a quick field-read on…").

After all 8:

```bash
git tag -a v0.3.0 -m "v0.3.0 — naming convention pass (kebab-case, two-layer)"
git push origin main v0.3.0
```

## Watch-fors

- **Cowork rename behavior.** Renaming via skill-creator might create a new skill and orphan the old one. If two folders appear after snapshot, delete the old skill in Cowork before committing.
- **Slash-command muscle memory.** You may type `/anthropic-skills:field-lens` for a week. Trigger phrases in descriptions still match.
- **The Notion integration on `todo-*`.** Unaffected — those names don't change.
- **`doc-uu` mount path.** First time you use the renamed skill, confirm the asset copy step (`cp /mnt/skills/user/doc-uu/assets/uu_template.dotx ...`) actually finds the file. If Cowork's mount doesn't auto-rename the directory, you may need to manually move the asset in Cowork's UI.

## Rollback

Every prior version of every SKILL.md is in git history. To revert:

```bash
git log --oneline plugins/and-humans/skills/field-lens/SKILL.md  # find the SHA
git show <sha>:plugins/and-humans/skills/field-lens/SKILL.md     # view old body
# Paste into Cowork's skill-creator to restore.
```

Or revert the commit and re-snapshot — but that only undoes the *repo* state; Cowork keeps the rename until you reverse it in the UI.
