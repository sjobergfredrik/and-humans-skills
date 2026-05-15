# Wardley Mapping Frameworks Reference

## Table of Contents
1. [The Map Structure](#the-map-structure)
2. [Evolution Stages](#evolution-stages)
3. [Evolution Characteristics](#evolution-characteristics)
4. [Doctrine Principles](#doctrine-principles)
5. [Climatic Patterns](#climatic-patterns)
6. [Gameplay Moves](#gameplay-moves)

---

## 1. The Map Structure

A Wardley Map has two axes:
- **Y-axis (vertical): Value Chain** — from user need (top) to underlying components (bottom). Each component serves the one above it. Visibility decreases as you move down.
- **X-axis (horizontal): Evolution** — from left (Genesis) to right (Commodity/Utility). Components move left to right over time. This movement is inevitable but the speed varies.

**Anchoring rule**: Every map starts from a user need at the top. If you can't identify the user, you don't have a map — you have a parts list.

**Dependencies**: Arrows point downward from a component to what it depends on. A component can depend on multiple things. Follow the chain to find strategic bottlenecks.

---

## 2. Evolution Stages

| Stage | I: Genesis | II: Custom-Built | III: Product (+Rental) | IV: Commodity (+Utility) |
|-------|-----------|------------------|----------------------|------------------------|
| **Character** | Rare, poorly understood, uncertain, experimental | Emerging understanding, increasing learning, bespoke | Feature-complete, increasingly defined, widespread | Standardized, well-defined, ubiquitous |
| **Supply** | Rare, typically one-off | Emerging market, small number of providers | Growing market, many providers, consolidation | Mass market, highly competitive, often utility |
| **User perception** | Novel, exciting, experimental | Increasingly useful, practical value emerging | Expected, necessary, "table stakes" | Invisible, boring, taken for granted |
| **Market** | Undefined, exploration | Forming, early adopters | Mature, mainstream adoption | Commodity, utility pricing |
| **Knowledge** | Very little known, high uncertainty | Learning, increasing understanding | Well-known, codified, documented | Completely known, accepted |
| **Examples** | Early AI agents (2024), quantum computing | Most enterprise SaaS, custom ML models | Cloud compute (AWS/Azure/GCP), smartphones | Electricity, TCP/IP, standard bolts |

---

## 3. Evolution Characteristics

These are the properties that change as a component evolves. Use them to assess where something sits:

**Ubiquity**: How widespread is it? Genesis = rare. Commodity = everywhere.
**Certainty**: How well understood? Genesis = uncertain. Commodity = completely defined.
**Failure rate**: High in genesis (most experiments fail), low in commodity.
**Market perception**: Changes from "competitive advantage" to "cost of doing business."
**Knowledge management**: Moves from exploration/research to volume operations/Six Sigma.
**Market**: Moves from undefined to undifferentiated.
**User perception**: Moves from "wow this is amazing" to "it just works, why would I think about it."
**Focus of value**: Moves from the component itself to what you build on top of it.

**Key insight**: The transition from Product to Commodity (the "war" phase) is where most strategic disruption happens. Incumbents resist this transition. New entrants exploit it.

---

## 4. Doctrine Principles

Doctrine = universally useful principles regardless of context. These are the "good housekeeping" of strategy. Organized by category:

### Communication
- **Use a common language** — a map, a shared vocabulary. Without it, strategy is just hand-waving.
- **Challenge assumptions** — especially about where components sit on the evolution axis. Most organizations systematically overestimate how novel their stuff is.
- **Be transparent** — about maps, about intentions, about what you don't know.

### Development
- **Use appropriate methods** — Agile for genesis/custom, lean for product, Six Sigma for commodity. Using the wrong method for the evolutionary stage is a classic error.
- **Think small teams** — Cell-based structures. Two-pizza teams. Pioneer/Settler/Town Planner.
- **Focus on user needs** — Anchor every decision to a real user need, not internal org structure.
- **Remove duplication and bias** — Multiple teams building the same thing is a doctrine failure. Bias toward custom-building what should be commodity is the most common strategic error in IT.
- **Think aptitude and attitude** — Different evolutionary stages need different people: Pioneers (genesis), Settlers (product), Town Planners (commodity).

### Learning
- **Use maps** — Obvious, but most organizations don't. They use stories, frameworks without position, or gut feel.
- **Understand what is being considered** — Landscape, climate, doctrine, leadership. Most people skip straight to leadership (action) without understanding the first three.
- **Think fast, inexpensive, elegant, restrained (TIER)** — Don't over-engineer. Especially in genesis/custom stages.
- **Be willing to fail** — In genesis, failure is the point. If you're not failing, you're not exploring.

### Structure
- **Provide purpose, mastery, autonomy** — Standard motivation theory, but applied per evolutionary stage. Pioneer teams need maximum autonomy.
- **Think big, start small** — Strategy is about direction. Execution starts with the smallest useful step.
- **Manage inertia** — Every organization (and person) resists change. The most dangerous inertia is success — "this worked before" is the enemy of adaptation.
- **Design for constant evolution** — Nothing stays in one place. Build for movement, not for stasis.

---

## 5. Climatic Patterns

Climate = forces that act on all players in a market. You can't control these, but you can anticipate them.

### Core patterns
- **Everything evolves** — No component stays in genesis forever. The pressure toward commodity is relentless.
- **Characteristics change as components evolve** — What matters shifts. In genesis: talent, experimentation. In commodity: efficiency, scale, reliability.
- **No single method fits all** — Agile isn't universally correct. Neither is waterfall. The right method depends on evolutionary stage.
- **Efficiency enables innovation** — Commodity components become platforms for the next wave of genesis. Electricity enabled factories. Cloud enabled SaaS. LLM APIs are enabling AI agents.

### Anticipatory patterns
- **Components in the "war" phase create new opportunities** — When something commoditizes, look for what it enables above it in the value chain.
- **Higher-order systems emerge** — Commoditized components get combined into new, higher-order things. This is the genesis of the next cycle.
- **Past success breeds inertia** — The better something worked, the harder it is to let go. Watch for organizations defending their custom-built thing against commoditization.
- **Inertia kills** — Not immediately, but inevitably. If you resist the evolutionary pressure, someone else won't.
- **There is no "core"** — What's "core" to your business changes as components evolve. Clinging to "core competency" in a commoditizing component is a strategic error.

### Warning signs
- **Co-evolution of practice** — When a component evolves, the practices around it must also evolve. If your DevOps practices are still "custom" while your infrastructure is commodity, you have a mismatch.
- **Componentization creates new industries** — Watch for the unbundling.

---

## 6. Gameplay Moves

Gameplay = context-specific actions you can take given your position on the map. Unlike doctrine, these are choices — and they have trade-offs.

### Offensive moves
- **Open source** — Accelerate commoditization of a component to undermine competitors who depend on it being product/custom. Classic example: Google open-sourcing Android to commoditize mobile OS.
- **Exploit buyer/supplier power** — Use your position in the value chain to extract value or set terms.
- **ILC (Innovate-Leverage-Commoditize)** — The Amazon playbook. Innovate internally, turn it into a product, then commoditize as a service. AWS started as internal infrastructure.
- **Create constraints** — Artificial scarcity, standards control, regulatory capture. Powerful but ethically loaded.
- **Signal** — Tell the market a shift is coming (even if you're not sure) to trigger competitors' inertia responses.
- **Talent raid** — Acquire the people, not just the technology.

### Defensive moves
- **Raise barriers** — Patents, switching costs, ecosystem lock-in. Effective short-term, but evolution eventually routes around them.
- **Sweat and dump** — Extract maximum value from a commoditizing asset while investing elsewhere. Dangerous if you misjudge timing.
- **Pig in a poke** — Sell a declining asset to someone who doesn't understand the map. Ethically questionable.

### Ecosystem moves
- **Tower and moat** — Build a valuable component (tower) and make it hard to replace (moat). Then use it as leverage.
- **Co-opt** — Join an ecosystem to influence its direction. Standards bodies, open source governance, etc.
- **Two-factor markets** — Platform plays. One side subsidizes the other. Classic chicken-and-egg problem.

### Positional moves
- **First mover vs. fast follower** — First mover advantage exists in genesis. In product/commodity, fast follower often wins. Know which game you're playing.
- **Weak signal exploitation** — Spot the component that's about to move to the next evolutionary stage before others do. This is where maps give you an edge.
