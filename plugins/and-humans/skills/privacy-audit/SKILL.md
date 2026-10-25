---
name: privacy-audit
description: >
  Reads a repo's code against its GDPR record (docs/PRIVACY.md) and brings the
  record back in line with what the code actually stores, sends and keeps.
  It works from the code only and never reads personal data. Use when the user
  wants to:
  - audit or review a repo for personal data;
  - check whether PRIVACY.md is still true;
  - write a first privacy record (art. 30) for a repo;
  - act on privacy_drift / privacy_missing / privacy_stale items from the
    repo-hygiene digest;
  - do the yearly review of a record.
  Trigger on: "privacy audit", "GDPR review", "PRIVACY.md", "does the record
  match the code", "integritetsgranskning", "registerförteckning",
  "personuppgifter i repot", "art. 30", "art. 14", "who are our processors".
  Do NOT trigger for a single design-time question about one new field or
  vendor: that is the trigger list in the global CLAUDE.md, answered in the
  change itself.
---

# Privacy Audit

You read code the way a data-protection reviewer would, and you assume the
record is wrong until the code proves it right. The point is not paperwork.
What the code holds drifts away from what people believe it holds. A nightly
sync that "only stores aggregates" turned out to keep 160k consumers' contact
details. A record turned out to be missing whole groups of people three days
after it was written. You find those gaps. You name the legal question each
one raises, and you never settle it: this is not legal advice.

## Ground rules (no exceptions)

1. **Read code, not data.** Never open a production database, an `.env`, a
   backup, an export or a `data/` folder to "see what's in it". Schemas,
   migrations, models, manifests, `.env.example`, and code that reads or writes
   data are enough. If a question can only be answered from data, ask the user
   to run a count, or a field-name-only query, and report back.
2. **Never print values.** Not an email address, a name, a token or a key. If a
   command could print one, redact it inside the command itself (`sed -E
   's/=.*/=<redacted>/'`, `grep -o` on field names, `jq 'keys'`), never
   afterwards. A key that does reach the transcript is burnt. Say so plainly and
   ask the user to rotate it.
3. **Cite `file:line`** for every store, field, flow and processor you claim.
   "Probably" is not a finding. Mark what code alone cannot decide as
   *not determinable from code*, and list it for the user.
4. **Name the question, don't answer it.** "Lawful basis for X?" or "DPA with
   Y?" goes on the list for the user. You don't decide that consent is fine.

## The method

### 1. Find the record and the inputs
- The record is `docs/PRIVACY.md`. Another repo's record may cover this one,
  for example a public site run by the same controller. Check before calling it
  missing.
- Note its `Last reviewed: YYYY-MM-DD` line. If the line is missing, report that
  as a finding.
- If the repo-hygiene digest listed `privacy_drift`, `privacy_missing` or
  `privacy_stale` items for this repo, start from them. They are mechanical
  hints (a new dependency, a new column, a new env variable). Your job is
  everything they can't see.

### 2. Map what the code does
Work through each of these, and fan out to subagents for a large repo:

| Look for | Where |
|---|---|
| **Stores** | DB schemas and migrations, ORM models, CMS schemas, buckets, files written to disk, caches, logs, backups, local exports |
| **Person fields** | names, emails, phones, addresses, IDs, birth dates, photos, IPs, user agents, free text about people, raw API payloads stored as json |
| **Data subjects** | users, customers, contacts, applicants, employees, researchers, visitors, children |
| **Sources** | collected from the person, or from third parties and public sources (art. 14 notice needed) |
| **Processors** | every outbound call that carries person data: LLM APIs (prompts, embeddings, tool results), mail, SMS, analytics, error tracking, auth, hosting, storage, chat or notification bots |
| **Art. 9 and children** | health, ethnic origin, political or religious views, sex life, biometrics, union membership; anything about minors |
| **Cookies and tracking** | consent gating, every cookie and localStorage key, third-party embeds |
| **Retention** | jobs that delete or prune data, and tables nothing ever deletes from |
| **Rights** | export and erase paths (art. 15/17/20); whether they reach every store |
| **Exposure** | public endpoints without auth, open RLS policies, public buckets, data committed to git (fixtures, seeds, dumps) |

### 3. Compare with the record
For every row in the record, ask whether the code still does that. For every
store, field, flow and processor in the code, ask whether the record has it.
The usual gaps:
- a group of data subjects the record never mentions;
- a store the record never mentions, often logs, query logs and mail bodies;
- a processor row that is too narrow ("embeddings only" when prompts carry
  mail text);
- a retention promise that no job enforces;
- an export or erasure path that skips tables;
- a "never" rule the code breaks (contact details in notification cards, say);
- a field the record calls private that is public.

### 4. Deliver
- **A PR against `docs/PRIVACY.md`** on a branch, never straight to main. It
  brings the record in line with the code, with every gap verified in code
  first. If the repo has none, ask before creating one, then follow
  [references/record-template.md](references/record-template.md).
- **Set `Last reviewed:` to today's date only when this was the full yearly
  read** and the user agrees. A partial fix doesn't move it.
- **The decisions only the user can make**, as a numbered list:
  - production values you couldn't see;
  - plan tiers and DPAs;
  - code fixes for retention, export or exposure;
  - whether a field should move or go.

  Don't change application code in the same PR. Propose those fixes separately.
- **A short summary**: what was wrong, what the PR fixes, what still waits on
  the user, what code couldn't tell you.

## When the record is fine

Say so in one line, with what you checked. Don't pad a clean audit with
speculative findings.
