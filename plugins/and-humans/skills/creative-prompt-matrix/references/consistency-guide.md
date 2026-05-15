# Consistency Guide

The biggest challenge in batch image generation is getting 20 images that feel like they belong together — same person, same product, same visual language — while still having genuine variation.

## The Core Problem

AI image generators are stochastic. Same prompt = different result every time. Consistency requires either:
1. **Locking** the subject via reference image or seed
2. **Describing** the subject so precisely that outputs converge naturally
3. **Compositing** — generate parts separately and combine (advanced)

---

## Strategy 1: Reference-Based (Best Quality)

### Midjourney `--cref`
Best approach for person/character consistency.

**Process:**
1. Write and generate your master prompt — no cref yet
2. Pick the best output, upscale it
3. Right-click → "Copy image address" (the CDN URL)
4. Add `--cref [URL]` to all subsequent prompts
5. Use `--cw 50-80` as starting point — adjust based on how strictly you need the face to match

**`--cw` guidance:**
- `--cw 0` = Only face is locked, body/outfit can vary freely
- `--cw 50` = Face + general build, outfit can change
- `--cw 100` = Full character, outfit, and style locked (less creative freedom)

**Tip:** Lower `--cw` gives more compositional freedom while keeping the person recognizable. Good for lifestyle campaigns.

### fal.ai Flux Redux
Image-to-image guided generation. Like cref but via API.

```json
{
  "model": "fal-ai/flux/dev/redux",
  "image_url": "[URL of your master image]",
  "prompt": "same person running on beach, golden hour",
  "strength": 0.75
}
```
`strength`: 0.6-0.8 = recognizable but not cloned. 0.9+ = very close copy.

---

## Strategy 2: Seed Locking (Batch Automation)

Best for Flux and fal.ai when you don't have a reference image yet.

**Process:**
1. Pick a seed (any number, e.g., `seed: 4242`)
2. Use identical subject description across all prompts
3. Vary only environment, lighting, composition

**Why it works:** Same seed = same initial noise pattern. Same subject description = Claude/Flux interpreting the subject similarly. The combination produces recognizable variation.

**Limitation:** Works better for products than people. People's faces drift even with seed locking.

---

## Strategy 3: Anchor Description

When you can't use reference images (first pass, or text-only workflow):

Write a **subject anchor** — a locked description that goes at the start of every prompt unchanged.

**Product example:**
```
ANCHOR: "Matte black ceramic travel mug, 350ml, brushed metal lid, minimalist logo embossed on side"

Prompt 1: [ANCHOR] on white marble kitchen counter, morning light, editorial flat lay
Prompt 2: [ANCHOR] held by person on train, commuter context, documentary style  
Prompt 3: [ANCHOR] close-up texture shot, macro lens, studio lighting
```

**Person example:**
```
ANCHOR: "Athletic woman, late 20s, Scandinavian features, braided blonde hair, wearing white athletic gear"

Prompt 1: [ANCHOR] running on urban street, morning light, motion blur
Prompt 2: [ANCHOR] stretching in park, golden hour, candid documentary
Prompt 3: [ANCHOR] in gym, dramatic side lighting, powerful energy
```

The anchor creates convergence even without technical reference locking.

---

## Strategy 4: Composite Approach (Advanced)

Generate pieces separately, combine in post. This is how professional AI creative studios work at scale.

**Workflow:**
1. **Background layer:** Generate environment/scene without person/product
2. **Subject layer:** Generate subject isolated (white background / transparent)
3. **Combine:** In Photoshop, Figma, or via inpainting

**For products:**
- Use `white background product photography` prompts for clean cutouts
- Tools: Remove.bg, Photoshop Generative Fill, or fal.ai inpainting

**For people:**
- Generate person with `white background` or `studio void`
- Place in generated backgrounds
- Use Midjourney's `vary (region)` or fal.ai inpainting to blend edges

**When to use:** When you need 50+ variations and reference-based methods become bottlenecks. Good for e-commerce product shots at scale.

---

## Recommended Workflow by Use Case

| Use Case | Recommended Strategy |
|----------|---------------------|
| Person/model campaign | Reference (MJ `--cref` or Flux Redux) |
| Product e-commerce | Seed lock + anchor description |
| Lifestyle + one person | Reference with `--cw 50` |
| Abstract/brand campaign | Seed lock + `--sref` for style |
| Large batch (50+) | Composite approach |
| First pass / exploration | Anchor description, no lock |
