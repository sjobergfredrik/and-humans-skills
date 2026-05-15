# Decision Tree — Full Interactive Flow

Use this when walking a user through the complete decision process step by step.

## Entry Point

Ask: **"What kind of agent system are you building?"**

Present four paths:

---

## Path A — "I need reliability, logic, state, and control"

**Primary recommendation: LangGraph**

Follow-up questions:
- Do you need human-in-the-loop approval steps?
- Will this run in production with real users?
- Do you need to persist state across sessions?

If yes to any → LangGraph is the clear choice. It gives you:
- Deterministic execution with retries and branching
- Built-in checkpointing and state persistence
- Human approval gates
- The closest thing to "software engineering" in agent land

**Pair with:**
- Anthropic Agent SDK or OpenAI Agents SDK as the runtime
- MCP for tool standardization
- LangSmith or custom telemetry for observability

**Watch out for:**
- Steeper learning curve than simpler frameworks
- Can feel over-engineered for simple prototypes
- Graph definition requires thinking about your flow upfront

---

## Path B — "I want agents that collaborate like a team"

**Primary recommendation: CrewAI (practical) or AutoGen (experimental)**

Follow-up questions:
- Is this a defined workflow (researcher → writer → reviewer) or emergent/exploratory?
- Production or exploration/research?
- How much do you need to control the interaction between agents?

If defined workflow → **CrewAI**
- Role-based agents (researcher, planner, writer, critic)
- Task delegation patterns
- Good for content generation, research synthesis, analysis pipelines

If emergent/exploratory → **AutoGen**
- More flexible conversation patterns
- Better for research contexts
- Less production-hardened

**Pair with:**
- Any model provider (both are model-agnostic)
- LangGraph underneath if you need flow control on top
- Vector DB for shared agent memory

**Watch out for:**
- Multi-agent adds latency and cost (every agent call = model call)
- Debugging multi-agent conversations is genuinely hard
- Often simpler to have one good agent with tools than three mediocre ones

---

## Path C — "I want one powerful agent"

**Primary recommendation: Pick the native SDK of your preferred model**

Follow-up questions:
- What's your primary use case? (coding, reasoning, search, multimodal)
- Are you locked into a model provider?
- Do you need function calling / tool use?

**Anthropic Agent SDK** — best for:
- Complex reasoning chains
- Coding agents
- Tasks requiring careful instruction following
- When you want the model to "think hard"

**OpenAI Agents SDK** — best for:
- Broadest tool/integration ecosystem
- Multimodal (vision, audio, image gen)
- When you want the most out-of-the-box functionality
- GPT-store / assistant marketplace

**Google Vertex AI Agents** — best for:
- Enterprise already on Google Cloud
- Knowledge-heavy agents (Docs, Drive, Gmail, Workspace)
- Search-augmented generation
- When the data is already in Google

**Watch out for:**
- Single-SDK lock-in makes model switching harder
- Native SDKs evolve fast — today's API may change next quarter
- Consider LangGraph as insurance layer if you might need multi-model later

---

## Path D — "I just need glue between steps"

**Primary recommendation: Infrastructure layer**

Follow-up questions:
- Are you connecting existing agents/services?
- Do you need a standard tool interface?
- Is this agent-to-agent communication?

**MCP (Model Context Protocol)** → standard interface for tool use
- Best for: giving agents consistent tool access
- Growing ecosystem of MCP servers

**A2A (Agent-to-Agent)** → Google's protocol for agent communication
- Best for: agents built on different platforms talking to each other
- Still early

**Vector DBs, queues, storage** → the boring but essential stuff
- Needed regardless of which upper layers you pick
- Don't overthink this layer — pick what your team knows

**Watch out for:**
- MCP is Anthropic-originated but gaining cross-platform adoption
- A2A is Google-originated and very early
- These protocols complement each other, they're not competitors
