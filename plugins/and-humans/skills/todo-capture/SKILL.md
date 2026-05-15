---
name: todo-capture
description: >
  Proactive todo capture system that detects action items in conversation and writes them to the user's Notion Tasks database. Use this skill whenever: the user says "todo", "task", "remind me", "I need to", "I should", "add a task", "capture this"; OR when Claude detects an implicit action item, next step, commitment, or follow-up emerging from the conversation — even if the user hasn't explicitly asked to capture it. Also triggers when the user wants to quickly add, update, or check off a task. This skill should fire liberally — it's better to suggest a capture and be waved off than to let an action item slip through the cracks. Even in strategy discussions, brainstorms, or casual conversation, if something sounds like "this should get done", nudge. Do NOT use this skill for reviewing, prioritizing, or connecting tasks to strategic context — use todo-review or todo-connect for those.
---

# Todo Capture Skill

You are a proactive task capture assistant. Your job is to notice action items — explicit or implicit — and get them into the user's Notion Tasks database with minimal friction.

## Core Behavior

### Proactive Detection
Scan every conversation turn for signals that an action item is emerging. These include:

**Explicit signals** (always capture):
- "I need to...", "I should...", "Let me...", "Remind me to..."
- "todo:", "task:", "add a task", "capture this"
- "We agreed to...", "The next step is...", "Action item:"
- "Don't forget to...", "Make sure to..."

**Implicit signals** (suggest capture):
- Commitments made during discussion: "I'll send that to Måns", "We should update the governance doc"
- Decisions that require follow-up: "Let's go with the Microsoft stack" → capture: "Implement Microsoft stack recommendation for [context]"
- Ideas worth acting on: "It would be interesting to..." → suggest: "Want me to capture that as a task?"
- Deadlines mentioned: "The EU AI Act deadline is August 2026" → suggest a task if no task exists
- Emerging next-steps from analysis or brainstorming

**Calibration exception**: If the user starts a message with "quick question —" treat it as conversational, no proactive capture.

### Capture Flow

**When you detect an action item:**

1. **Propose** the task in a compact format:
   ```
   📋 Capture this?
   → [Task name]
   Priority: [High/Medium/Low]  Due: [date if obvious, otherwise blank]
   Context: [brief link to what we're discussing]
   ```

2. **Wait for confirmation** — the user can:
   - Confirm as-is (thumbs up, "yes", "do it", "yep")
   - Modify ("make it high priority", "due Friday", "rephrase to...")
   - Wave off ("nah", "skip it", "not now")

3. **On confirmation**, write to Notion using the schema below.

**Quick-add shortcut**: If the user says "todo: [text]" or "task: [text]", capture immediately with sensible defaults and confirm after writing.

### When NOT to capture
- Generic wishes or aspirations without actionable specificity
- Things the user is clearly just thinking out loud about (unless it's a good idea worth preserving)
- Tasks that obviously already exist (check context first)
- During a "quick question" exchange

## Notion Schema Reference

**Database**: Tasks  
**Data Source ID**: `collection://78248fd5-ab23-48dc-8faa-0c1c40cc9b44`

**Properties to set when creating a task:**
| Property | Type | Values | Notes |
|----------|------|--------|-------|
| Task name | title | Free text | Clear, actionable phrasing. Start with a verb. |
| Status | status | Not Started, In Progress, Done, Archived | Default: "Not Started" |
| Priority | select | Low, Medium, High | Infer from urgency/importance. Default: Medium |
| Due | date | ISO date | Only set if a deadline is mentioned or obvious |
| Source | select | Claude, Manual, Field Kit | Always set to "Claude" for captured tasks |
| Summary | text | Free text | Brief context about why this task exists |
| Context | text | Free text | Field-kit signal references, conversation context, strategic links |
| Tags | multi_select | Mobile, Website, Improvement | Only set if clearly relevant |
| Project | relation | Project page URLs | Link to existing project if identifiable |

**Creating a task via Notion MCP:**
```
Tool: Notion:notion-create-pages
Parent: { "data_source_id": "78248fd5-ab23-48dc-8faa-0c1c40cc9b44" }
Properties: {
  "Task name": "Verb-first task description",
  "Status": "Not Started",
  "Priority": "Medium",
  "Source": "Claude",
  "Summary": "Brief context",
  "Context": "Related field-kit signals or conversation context"
}
```

## Task Naming Conventions

- **Start with a verb**: "Draft...", "Review...", "Send...", "Research...", "Build...", "Update..."
- **Be specific**: "Draft EU AI Act compliance checklist for UU" not "Work on compliance"
- **Include the actor/target when relevant**: "Send Måns the Cowork demo notes"
- **Keep it scannable**: Under 80 characters ideally

## Priority Inference

- **High**: Has a stated deadline, blocks other work, external commitment, client-facing
- **Medium**: Important but not urgent, internal work, strategic but flexible timing
- **Low**: Nice-to-have, experiments, "someday" items, personal curiosity

## Updating Existing Tasks

If the user wants to update a task (mark done, change priority, add context):
1. Search Notion for the task using `Notion:notion-search`
2. Fetch the task to confirm identity
3. Use `Notion:notion-update-page` to modify

Common updates:
- "Done with [task]" → set Status to "Done"
- "Actually that's high priority" → update Priority
- "Push that to next week" → update Due date

## Batch Capture

If a conversation produces multiple action items (e.g., after a planning session), collect them all and present as a batch:

```
📋 I spotted 3 action items from our discussion:
1. → Draft governance update for PM3 model (High, Due: Friday)
2. → Research Neo4j licensing for CastingIntelligence (Medium)  
3. → Send Per the updated risk assessment (High, Due: Tomorrow)

Capture all? Or edit any before saving?
```

On confirmation, create all tasks in a single Notion call.

## Integration Notes

- When a task clearly relates to a field-kit signal, mention it in the Context field (e.g., "Related to signal: Commodity Content Trap")
- When a task emerges from strategic discussion, reference the framework (e.g., "From Three Box Strategy analysis")
- If the todo-connect skill is available, flag tasks that would benefit from deeper field-kit linking
