# Agent Architecture Advisor Kit

An opinionated, interactive decision framework for choosing the right AI agent stack. Built for developers and teams who are tired of comparing apples to oranges in the agent ecosystem.

## The Problem

People ask "should I use LangGraph or the Anthropic SDK?" — but that's like asking "should I use Linux or Python?" They're at different layers and often work together.

## What This Kit Does

It walks you (or your AI agent) through a structured decision process:

1. **Classifies your need** — reliable system, collaborating agents, single powerful agent, or just glue?
2. **Routes to the right layer** — orchestration, runtime, model, or infrastructure
3. **Recommends a concrete stack** — specific tools per layer, with reasoning
4. **Names the tradeoffs** — what you gain, what you give up, when to switch

## The Four-Layer Model

| Layer | What it does | Key players |
|-------|-------------|-------------|
| Orchestration | Flow control, state, branching | LangGraph, CrewAI, AutoGen |
| Agent Runtime | Single-agent SDK with tools | OpenAI SDK, Anthropic SDK, Vertex AI |
| Models | The reasoning engine | OpenAI, Anthropic, Google, Mistral, Qwen |
| Infrastructure | Plumbing | MCP, A2A, vector DBs, queues |

**Rule:** Never compare items from different layers as if they're alternatives.

## Kit Contents

```
agent-architecture-advisor/
├── journey.json              # Kit manifest
├── README.md                 # You're reading this
├── prompts/
│   ├── main.md               # Core agent prompt — the behavioral heart
│   └── steps/
│       └── decision-tree.md  # Full interactive decision flow
├── references/
│   ├── landscape.md          # Detailed player positioning
│   └── stacks.md             # Tested stack combinations + tradeoffs
└── skills/
    └── SKILL.md              # Agent skill definition (discovery metadata)
```

## Quick Stack Picks (2026)

- **Most balanced:** OpenAI Agents SDK + LangGraph + MCP
- **Best reasoning/coding:** Anthropic Agent SDK (+ LangGraph if needed)
- **Enterprise Google-native:** Vertex AI Agents
- **EU / sovereignty:** Mistral + LangGraph
- **Rapid prototype:** CrewAI + cheapest available model
- **Cost-optimized:** Open-weight models + LangGraph + local infra

## Installation

```bash
# Via Journey CLI
npx journey install uppsalaai/agent-architecture-advisor

# Or paste the prompt from prompts/main.md into your agent's system prompt
```

## Who Made This

Built by a consultant and AI practitioner in Uppsala, Sweden who got tired of seeing the same layer-confusion in every agent architecture discussion.

## License

MIT — use it, fork it, improve it.
