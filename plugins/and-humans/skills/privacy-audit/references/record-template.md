# docs/PRIVACY.md: template for a new record

The skeleton of an art. 30 record that a drift check can read. Keep the
section names. Write it in the language the repo's people use (Swedish is fine:
the check also reads `Senast granskad:`). Delete a section only when it truly
doesn't apply, and say why in one line.

```markdown
# Personal data: record of processing (GDPR art. 30)

Last reviewed: YYYY-MM-DD

<Controller> (org. no.) is the controller for <whose data>. <If we are the
processor for a client, say so here, and whose instructions we follow.>
Not legal advice; review yearly and when a new kind of data or processor
arrives. The public privacy policy is <where>; change both together.

## Where the data lives

| Store | What (tables / fields that hold person data) | Who can read it |
|---|---|---|
| <Postgres on Hetzner, EU> | `table` (field, field), `table.column` | <roles, services> |

## Categories, purposes, lawful basis

| Category | Data subjects | Examples | Purpose | Lawful basis |
|---|---|---|---|---|

Art. 9 data, if any: what, why, which art. 9(2) ground, and the short impact
assessment.

## Sources

Collected from the person, or from <third-party / public sources> (art. 14:
how and when people are told).

## Processors

| Processor | What it receives | Data location | DPA | Transfer basis | Todo |
|---|---|---|---|---|---|

Name every vendor the code depends on, with the same name the code would
suggest (Anthropic, OpenAI, Resend, Clerk, Sentry …). One that holds no
personal data still gets a row that says so.

## Cookies and tracking

Every cookie and localStorage key, its purpose and lifetime, and whether it
waits for consent.

## Retention

| Data | Kept until | How (the job or the person that enforces it) |
|---|---|---|

## Requests (access, erasure, rectification, objection)

The commands or steps, and the stores they reach.

## Who has access

People and tokens, and where each token lives.

## Public texts to keep in step

The privacy policy, notices, forms.
```

Conventions the drift check relies on:
- Name tables in backticks, and a person field as `table.column`, or the table
  and its columns on one line.
- Name each vendor by its usual name.
- Write down what is fine and why ("`orders.city` is a delivery depot, not a
  person"). That clears a false positive for good.
