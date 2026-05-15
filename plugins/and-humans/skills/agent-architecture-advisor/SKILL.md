---
name: agent-architecture-advisor
description: >
  Interactive decision framework for choosing AI agent architectures.
  Use when someone asks "what agent framework should I use", "how should
  I architect my AI agent system", "LangGraph vs CrewAI", "which SDK
  should I pick", "help me choose an agent stack", or any question about
  comparing agent frameworks, orchestration layers, model selection for
  agents, or production vs prototype agent architecture decisions.
  Routes through a four-layer model (orchestration, runtime, models,
  infrastructure) to produce a concrete, opinionated stack recommendation.
metadata:
  author: uppsalaai
  version: 0.1.0
  tags: agents, architecture, decision-framework
---

# Agent Architecture Advisor

## When to Use This Skill

- User is choosing between agent frameworks or SDKs
- User is architecting a new agent system (production or prototype)
- User is comparing tools from different layers without realizing it
- User asks about production readiness of agent tooling
- User needs a concrete stack recommendation for a specific use case

## Quick Start

Read [prompts/main.md](prompts/main.md) for the full interaction protocol.

## Core Concept: Four-Layer Model

The agent ecosystem has four layers. Most confusion comes from comparing across them.

1. **Orchestration** — flow control, state, branching (LangGraph, CrewAI, AutoGen)
2. **Agent Runtime** — single-agent SDK with tools (OpenAI SDK, Anthropic SDK, Vertex AI)
3. **Models** — the reasoning engine (OpenAI, Anthropic, Google, Mistral, open-weight)
4. **Infrastructure** — plumbing (MCP, A2A, vector DBs, queues)

## Workflow

1. Gather context: what they're building, constraints, existing commitments
2. Route through the decision tree based on primary need
3. Layer model choice on top
4. Deliver: recommended stack, reasoning, tradeoffs, migration path

## References

- [Landscape details](references/landscape.md)
- [Tested stack combinations](references/stacks.md)
- [Full decision tree](prompts/steps/decision-tree.md)
