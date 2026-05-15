---
name: creative-prompt-matrix
description: >
  Generates a structured matrix of image generation prompts from a single product/subject input. 
  Use this skill whenever the user wants to: generate multiple image prompts for a product, 
  create ad creatives, build a visual campaign, get prompt variations for Midjourney or Flux, 
  test different visual angles for a subject, produce batch prompts for social media images, 
  or says things like "generate image prompts", "create visuals for", "I need ad images", 
  "make a creative matrix", "FO2-style prompts", or "multiple angles on this product/person/concept". 
  Also trigger when the user wants consistent images with variations, or asks about batch image creation.
  Output is a ready-to-copy prompt set with platform-specific parameters.
---

# Creative Prompt Matrix

A prompt-orchestration skill that turns one product/subject description into a full batch of varied, ready-to-run image generation prompts — structured by perspective dimensions so the outputs feel like a campaign, not random variations.

## Input

Collect before generating (ask in one compact question if missing):

1. **Subject** — What is it? (product, person, concept, service)
2. **Brand direction** — Tone, feeling, target audience. Optional but improves output quality.
3. **Platform** — Midjourney / Flux (Replicate) / fal.ai / all three
4. **Count** — How many prompts? Default: 12 (covers the full matrix once)

## The Perspective Matrix

Each prompt is a combination of one value from each dimension. This is what creates real variation — not just rephrasing the same prompt.

| Dimension | Options |
|-----------|---------|
| **Environment** | studio white, urban street, nature/forest, home interior, industrial, editorial void, golden hour outdoor |
| **Composition** | hero shot (centered), lifestyle context, detail/macro, action/motion, flat lay, environmental portrait |
| **Lighting** | soft diffused, dramatic side-light, backlit/rim, natural golden, harsh direct, low-key dark |
| **Emotion/Energy** | aspirational, intimate/personal, powerful/bold, playful, serene/minimal, raw/authentic |
| **Camera feel** | editorial fashion, documentary/candid, commercial clean, fine art, sports/dynamic |

Generate prompts by selecting combinations that make sense together — not all 5×7 permutations, but curated pairings that produce a coherent campaign set.

## Output Format

Always output in three sections:

### 1. Anchor / Master Prompt
One establishing prompt that defines the subject clearly. All other prompts should feel like they belong to the same campaign as this one.

```
[MASTER] <full prompt text>
```

### 2. Prompt Matrix
Numbered list. Each prompt includes:
- The prompt text
- Dimension tags in brackets: `[env: studio] [comp: hero] [light: soft] [emotion: aspirational]`
- Platform-specific parameters appended (see references/platform-params.md)

Format:
```
01. <prompt text> [env: X] [comp: X] [light: X] [emotion: X]
    → MJ: <prompt> --ar 4:5 --v 7 --cref <note if master ref applies>
    → Flux: <prompt> | negative: <negative prompt>
    → fal: <prompt>
```

### 3. Consistency Notes
Brief guidance on how to maintain visual consistency across the batch:
- Midjourney: `--cref` strategy (use master image URL once generated)
- Flux/fal: seed locking + subject description anchoring

## Prompt Writing Rules

**Always include in the prompt text:**
- Subject description (specific, not generic)
- Key visual adjectives (material, texture, color if relevant)
- Scene/context
- Mood/lighting descriptor
- Camera/lens feel if relevant

**Avoid:**
- Brand names of people or trademarked products unless user explicitly provides
- Overcrowding prompts with conflicting styles
- Generic phrases like "high quality", "beautiful", "stunning" — be specific instead

**For products:** Lead with the product in context. Don't center the product like a catalog shot unless composition = hero.

**For people:** Describe physical appearance specifically (hair, build, clothing) — don't rely on names.

## Consistency Strategy (read this when user asks about consistent images)

Read `references/consistency-guide.md` for full strategy. Short version:

- **Midjourney**: Generate master → use `--cref [URL]` in all follow-up prompts. Use `--cw 0-100` to control how closely it follows (0 = face only, 100 = full character).
- **Flux on Replicate**: Use `flux-dev` with fixed seed. Describe character/product in identical language across all prompts.
- **fal.ai**: Use `fal-ai/flux/dev` with `seed` parameter locked. Works well with IP-Adapter for face/product consistency.

## Quick Examples

**Input:** "Träningsskor, sportig kvinna, 25-35 år, energisk varumärkeskänsla"

**Output excerpt:**
```
[MASTER] Athletic woman, mid-20s, strong build, wearing white performance running shoes, 
dynamic pose on urban street, morning light, editorial sports photography

01. White performance running shoes on feet of athletic woman mid-stride, urban concrete, 
    morning rim light, motion blur background [env: urban] [comp: action] [light: backlit] [emotion: powerful]
    → MJ: Athletic woman mid-stride white running shoes urban street morning rim light --ar 9:16 --v 7 --style raw
    → Flux: Athletic woman mid-stride, white performance sneakers, urban street, morning backlight, motion | negative: blurry face, deformed feet, extra limbs
```

## Platform Quick Reference

See `references/platform-params.md` for full parameter lists per platform.

**Midjourney defaults:** `--ar 4:5 --v 7 --style raw`  
**Flux (Replicate) defaults:** `flux-dev` model, steps: 28, guidance: 3.5  
**fal.ai defaults:** `fal-ai/flux/dev`, num_inference_steps: 28
