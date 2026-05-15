# Stack Combinations — Tested Pairings

Concrete stack recommendations for common scenarios. Each includes what you get, what you give up, and when to switch.

---

## Stack 1: Most Balanced, Forward-Leaning

**OpenAI Agents SDK + LangGraph + MCP**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | LangGraph | Production flow control |
| Runtime | OpenAI Agents SDK | Broadest tool ecosystem |
| Model | GPT-4o / o-series | Best all-round capabilities |
| Infra | MCP | Tool standardization |

**You get:** Maximum flexibility, largest community, broadest integration surface.
**You give up:** Reasoning depth (vs Anthropic), cost efficiency (vs open models).
**Switch when:** Your tasks are reasoning-heavy or you need better instruction following → swap runtime to Anthropic.

---

## Stack 2: Deep Reasoning / Coding Agents

**Anthropic Agent SDK (+ LangGraph if needed)**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | LangGraph (optional) | Add if you need complex flows |
| Runtime | Anthropic Agent SDK | Best reasoning, coding, instruction following |
| Model | Claude | Top-tier for complex tasks |
| Infra | MCP | Native fit with Anthropic ecosystem |

**You get:** Best reasoning quality, excellent coding agents, strong safety.
**You give up:** Ecosystem breadth (fewer integrations than OpenAI), multimodal range.
**Switch when:** You need heavy multimodal (image gen, audio) → add OpenAI for those specific tasks.

---

## Stack 3: Enterprise / Google-Native

**Google Vertex AI Agents**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | Vertex AI Agent Builder | Integrated with Google Cloud |
| Runtime | Vertex AI Agents | Built-in, managed |
| Model | Gemini | Native integration |
| Infra | Google Cloud services | Search, Workspace, BigQuery |

**You get:** Deep integration with Google Workspace, enterprise-grade infra, knowledge-heavy agents.
**You give up:** Developer flexibility, iteration speed, community tooling.
**Switch when:** You need more developer control or faster iteration → add LangGraph alongside.

---

## Stack 4: Control / EU / Sovereignty

**Mistral + LangGraph**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | LangGraph | Best open-source orchestration |
| Runtime | Custom or LangGraph-native | Assemble your own |
| Model | Mistral (or other open-weight) | EU, control, cost |
| Infra | Self-hosted / EU cloud | Sovereignty compliance |

**You get:** Full control, data sovereignty, EU regulatory compliance, cost efficiency.
**You give up:** Ecosystem convenience, some model capability vs frontier closed models.
**Switch when:** Frontier reasoning becomes critical → add Anthropic or OpenAI for specific high-stakes tasks, keep Mistral for the bulk.

---

## Stack 5: Rapid Prototyping / PoC

**CrewAI + any model**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | CrewAI | Fastest to prototype multi-agent |
| Runtime | CrewAI built-in | Integrated |
| Model | Whatever's cheapest/fastest | PoC doesn't need frontier |
| Infra | Minimal | Don't over-invest in plumbing |

**You get:** Fastest time to demo, intuitive role-based mental model, good for client presentations.
**You give up:** Production hardening, fine-grained flow control, observability.
**Switch when:** Going to production → migrate orchestration to LangGraph, keep the agent patterns.

---

## Stack 6: Cost-Optimized / Local-First

**Open-weight models + LangGraph + local infra**

| Layer | Choice | Why |
|-------|--------|-----|
| Orchestration | LangGraph | Best open-source option |
| Runtime | Custom | Build around your model |
| Model | Qwen, Llama, DeepSeek, Mistral | Open weights, local or cheap |
| Infra | Docker, pgvector, local MCP | Self-hosted |

**You get:** Lowest running cost, full data control, works offline.
**You give up:** Frontier model capabilities, cloud convenience, some quality.
**Switch when:** Quality gap becomes blocking → add API calls to frontier models for critical paths only.

---

## Anti-Patterns to Avoid

1. **Comparing across layers** — "Should I use LangGraph or the Anthropic SDK?" is the wrong question. They sit at different layers and often work together.

2. **Over-engineering prototypes** — If it's a PoC, use CrewAI or a single SDK. Don't build LangGraph flows for something that might get thrown away.

3. **Under-engineering production** — If real users depend on it, you need observability, error handling, and human-in-the-loop. A bare SDK won't cut it.

4. **Ignoring cost at scale** — Multi-agent = multiplicative model calls. Three agents discussing = 3x the tokens. Budget accordingly.

5. **Choosing models by hype** — Match the model to the task. Frontier models for reasoning, cheaper models for classification/routing, open models for bulk processing.
