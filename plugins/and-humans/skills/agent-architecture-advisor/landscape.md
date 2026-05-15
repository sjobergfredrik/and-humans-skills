# Agent Landscape Reference — 2026

Detailed positioning of key players across the four-layer model.

---

## Orchestration Layer

### LangGraph
- **Position:** The operating system for agent workflows
- **Strength:** Deterministic flows, retries, branches, human approval, state persistence
- **Weakness:** Learning curve, can feel heavy for simple tasks
- **Best for:** Production systems that need reliability and observability
- **Ecosystem:** LangSmith (observability), LangChain (integrations), large community

### CrewAI
- **Position:** Practical multi-agent collaboration
- **Strength:** Role-based agents, task delegation, quick to prototype
- **Weakness:** Less production-hardened than LangGraph, debugging multi-agent is hard
- **Best for:** Content pipelines, research synthesis, defined team workflows

### AutoGen (Microsoft)
- **Position:** Research-oriented multi-agent conversations
- **Strength:** Flexible conversation patterns, Microsoft backing
- **Weakness:** More experimental, less production-ready
- **Best for:** Research, exploration, emergent multi-agent behavior

---

## Agent Runtime Layer

### OpenAI Agents SDK
- **Position:** Broadest ecosystem play
- **Strength:** Tool ecosystem, multimodal, function calling maturity, marketplace
- **Weakness:** Closed ecosystem, pricing, less transparent reasoning
- **Best for:** Teams wanting the most out-of-the-box integrations

### Anthropic Agent SDK
- **Position:** Best-in-class reasoning
- **Strength:** Deep reasoning, coding, instruction following, safety
- **Weakness:** Smaller tool ecosystem than OpenAI, fewer multimodal capabilities
- **Best for:** Complex reasoning tasks, coding agents, high-stakes workflows

### Google Vertex AI Agents
- **Position:** Full-stack enterprise ecosystem
- **Strength:** Deep Google integration (Workspace, Search, Docs), enterprise infra
- **Weakness:** Slower iteration, less developer community love
- **Best for:** Enterprises already inside Google Cloud
- **Blunt take:** Best if you're already "inside Google", otherwise rarely first choice

---

## Model Layer

### OpenAI (GPT-4o, o-series)
- Broadest capabilities, strongest ecosystem
- Best multimodal (vision, audio, image generation)
- Premium pricing, closed weights

### Anthropic (Claude)
- Best reasoning and instruction following
- Strong coding capabilities
- Growing tool ecosystem, safety-focused

### Google (Gemini)
- Long context windows, good multimodal
- Tight Google Cloud integration
- Enterprise pricing, search-native

### Mistral
- Strong open/semi-open models
- EU positioning, sovereignty angle
- Good cost-performance ratio
- **Blunt take:** Great engine, bring your own chassis

### Chinese Models (Qwen, ERNIE, Kimi, DeepSeek)
- Very fast iteration, strong capabilities
- Cost-effective
- Vertically integrated in Chinese ecosystems
- **Blunt take:** Serious locally, niche globally (for now)
- DeepSeek: strong reasoning, open weights, notable cost efficiency

---

## Infrastructure Layer

### MCP (Model Context Protocol)
- **Origin:** Anthropic, now gaining cross-platform adoption
- **Purpose:** Standard interface for giving agents access to tools
- **Status:** Growing ecosystem, supported across multiple agent runtimes
- **Best for:** Tool standardization, portable tool definitions

### A2A (Agent-to-Agent Protocol)
- **Origin:** Google
- **Purpose:** Communication standard between agents on different platforms
- **Status:** Very early, limited adoption
- **Best for:** Cross-platform agent communication (when it matures)

### Vector Databases
- Pinecone, Weaviate, Qdrant, Chroma, pgvector
- Essential for RAG and agent memory
- Pick based on your existing infra (pgvector if you're already on Postgres)

### Queues and State
- Redis, Celery, cloud queues
- Needed for async agent workflows
- Don't overthink — use what your team knows
