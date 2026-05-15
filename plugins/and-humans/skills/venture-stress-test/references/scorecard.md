# Venture Stress Test — Scorecard Reference

## The 8 Dimensions

Each dimension is scored 1–5:
- **1** = Major red flag / clearly missing
- **2** = Weak / requires significant work
- **3** = Acceptable / average
- **4** = Strong / clear evidence
- **5** = Exceptional / standout strength

---

### 1. Revenue Clarity (Bootstrap weight: 5, Scale weight: 3)

How clear is the path from "this exists" to "someone pays"?

| Score | Meaning |
|-------|---------|
| 5 | Buyer identified, price validated, purchase trigger obvious |
| 4 | Buyer segment clear, price range plausible, path to first sale mapped |
| 3 | Buyer exists but unvalidated; plausible revenue model |
| 2 | Vague buyer; "we'll figure out monetization later" |
| 1 | No idea who pays or why |

**Key questions**: Is the buyer the user? Who authorises the purchase?
What's the switching cost from their current solution?

---

### 2. Speed to First Revenue (Bootstrap weight: 5, Scale weight: 2)

How fast can this get to first paying customer with minimal resources?

| Score | Meaning |
|-------|---------|
| 5 | < 4 weeks to first payment with existing skills/tools |
| 4 | 1–3 months with focused effort, 1–2 people |
| 3 | 3–6 months, requires some new capability or integration |
| 2 | 6–12 months, needs significant build before anyone can pay |
| 1 | > 12 months or requires external dependencies to resolve first |

**Key questions**: What's the absolute minimum to charge for?
Can you sell before you build? Could you do this as a service first?

---

### 3. Problem Severity (Bootstrap weight: 4, Scale weight: 4)

How painful is the problem being solved?

| Score | Meaning |
|-------|---------|
| 5 | Hair-on-fire problem; people are actively searching for solutions |
| 4 | Significant pain; people spend real time/money on workarounds |
| 3 | Annoying but liveable; people cope with status quo |
| 2 | Mild inconvenience; "nice to have" territory |
| 1 | Solution looking for a problem |

**Key questions**: Are people already paying for inferior solutions?
What do they do today? Would they notice if this disappeared?

---

### 4. Founder–Idea Fit (Bootstrap weight: 4, Scale weight: 3)

Does the founder/team have an unfair advantage for THIS specific idea?

| Score | Meaning |
|-------|---------|
| 5 | Deep domain expertise + existing audience/network + can build it |
| 4 | Strong domain knowledge + technical ability; missing one element |
| 3 | Can build it and has some domain familiarity |
| 2 | Can build it but no domain expertise or relevant network |
| 1 | Neither domain expertise nor ability to build the core product |

**Key questions**: Why you and not someone already in this space?
What do you know that others don't? Who do you already have access to?

---

### 5. Market Size (Bootstrap weight: 2, Scale weight: 5)

Is the addressable market big enough to matter?

| Score | Meaning |
|-------|---------|
| 5 | Large, growing market; >€100M addressable; strong secular trends |
| 4 | Solid market; €10–100M addressable; positive trends |
| 3 | Viable niche; €1–10M addressable; stable |
| 2 | Small niche; <€1M addressable; limited growth |
| 1 | Vanishingly small or shrinking market |

**Key questions**: How many potential customers in the first segment?
Is the market growing or contracting? What's the realistic price point?

Note: For bootstrap viability, a score of 2–3 is fine — you don't need a
huge market to build a sustainable small business.

---

### 6. Competitive Defensibility (Bootstrap weight: 2, Scale weight: 5)

Can this build and maintain an advantage over time?

| Score | Meaning |
|-------|---------|
| 5 | Network effects, proprietary data, regulatory moat, or strong brand |
| 4 | Meaningful switching costs, data accumulation, or expertise barrier |
| 3 | First-mover advantage in niche; some execution barrier |
| 2 | Easy to replicate; differentiation is mainly execution speed |
| 1 | Commodity; no meaningful barrier; anyone can build this tomorrow |

**Key questions**: What stops someone from copying this in a weekend?
Does the product get better with more users/data? Is there lock-in?

Note: For bootstrap, low defensibility is survivable if speed to revenue
is high — you can build a good lifestyle business without a moat.

---

### 7. Simplicity of Execution (Bootstrap weight: 3, Scale weight: 1)

How simple is this to build and operate with 1–3 people?

| Score | Meaning |
|-------|---------|
| 5 | Single product, single channel, known tech stack, no dependencies |
| 4 | Straightforward build; 1–2 integrations; manageable scope |
| 3 | Moderate complexity; multiple components but no exotic dependencies |
| 2 | Complex; marketplace dynamics, regulatory approvals, or hardware |
| 1 | Requires multiple hard problems solved simultaneously |

**Key questions**: Can one person build the MVP? Are there chicken-and-egg
problems (marketplace, platform)? How many things need to go right?

---

### 8. Strategic Fit (Bootstrap weight: 0, Scale weight: 2)

Does this connect to the founder's existing portfolio, skills, or strategy?

| Score | Meaning |
|-------|---------|
| 5 | Directly extends existing work; shared audience, tech, or brand |
| 4 | Strong thematic connection; leverages existing expertise |
| 3 | Tangentially related; some shared learning |
| 2 | Disconnected; new domain, new audience, new everything |
| 1 | Actively conflicts with existing commitments or positioning |

**Key questions**: Does this make your existing work more valuable?
Can you cross-sell? Does this distract from something more important?

Note: Not scored in Bootstrap composite because a bootstrapper might
deliberately want to diversify. But still worth flagging.

---

## Calculating Composite Scores

### Bootstrap Score (max 25)

Sum the weighted scores, normalised to a 25-point scale:

| Dimension | Weight | Max contribution |
|-----------|--------|-----------------|
| Revenue Clarity | 5 | 25 |
| Speed to First Revenue | 5 | 25 |
| Problem Severity | 4 | 20 |
| Founder–Idea Fit | 4 | 20 |
| Market Size | 2 | 10 |
| Competitive Defensibility | 2 | 10 |
| Simplicity of Execution | 3 | 15 |
| Strategic Fit | 0 | 0 |

**Formula**: `Bootstrap Score = (Σ weighted scores / 125) × 25`

### Scale Score (max 25)

| Dimension | Weight | Max contribution |
|-----------|--------|-----------------|
| Revenue Clarity | 3 | 15 |
| Speed to First Revenue | 2 | 10 |
| Problem Severity | 4 | 20 |
| Founder–Idea Fit | 3 | 15 |
| Market Size | 5 | 25 |
| Competitive Defensibility | 5 | 25 |
| Simplicity of Execution | 1 | 5 |
| Strategic Fit | 2 | 10 |

**Formula**: `Scale Score = (Σ weighted scores / 125) × 25`

---

## Presenting the Scorecard

Present as a table with all three views visible:

```markdown
| Dimension | Score | Bootstrap (wt) | Scale (wt) | Rationale |
|-----------|-------|----------------|------------|-----------|
| Revenue Clarity | 4 | 4×5=20 | 4×3=12 | [brief justification] |
| Speed to Revenue | 3 | 3×5=15 | 3×2=6 | [brief justification] |
| Problem Severity | 4 | 4×4=16 | 4×4=16 | [brief justification] |
| Founder–Idea Fit | 5 | 5×4=20 | 5×3=15 | [brief justification] |
| Market Size | 3 | 3×2=6 | 3×5=15 | [brief justification] |
| Defensibility | 2 | 2×2=4 | 2×5=10 | [brief justification] |
| Simplicity | 4 | 4×3=12 | 4×1=4 | [brief justification] |
| Strategic Fit | 3 | 0 | 3×2=6 | [brief justification] |
| **TOTAL** | | **93/125** | **84/125** | |
| **Normalised** | | **18.6/25** | **16.8/25** | |
```

Then map to verdict thresholds per the main SKILL.md.

---

## Score Calibration Notes

**Be honest, not generous.** The most common failure mode is scoring 3s
across the board because nothing seems terrible. A 3 should mean "genuinely
acceptable" — not "I don't know enough to score it lower."

**Challenge the Founder–Idea Fit score.** People overestimate their own
advantage. "I'm a developer so I can build it" is a 2, not a 4. "I've
spent 10 years in this industry and know every buyer personally" is a 5.

**Revenue Clarity is the hardest to score honestly.** If the user says
"businesses will pay for this" but can't name a specific person or company
who would buy it tomorrow — that's a 2, not a 3.

**Speed to First Revenue separates ideas from businesses.** If you can't
charge within 3 months, you need to be very honest about why this one is
worth the longer runway.
