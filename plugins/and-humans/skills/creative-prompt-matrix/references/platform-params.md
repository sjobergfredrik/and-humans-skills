# Platform Parameters Reference

## Midjourney (via Discord)

### Core Parameters
| Parameter | Values | Notes |
|-----------|--------|-------|
| `--v` | 7 (default), 6.1 | v7 = latest, best photorealism |
| `--ar` | 1:1, 4:5, 9:16, 16:9, 3:2 | 4:5 for Instagram, 9:16 for Stories/Reels |
| `--style` | raw, (none) | raw = less AI-processed, more photographic |
| `--q` | .5, 1, 2 | Quality. 1 = default. 2 = slower, more detail |
| `--chaos` | 0-100 | Variation between outputs. 0 = consistent |

### Consistency Parameters
| Parameter | Usage |
|-----------|-------|
| `--cref [URL]` | Character reference — paste image URL to lock appearance |
| `--cw [0-100]` | Character weight: 0 = face only, 100 = full character/outfit |
| `--sref [URL]` | Style reference — locks visual style/color grade |

### Recommended Presets by Use Case
- **Product hero:** `--ar 4:5 --v 7 --style raw --chaos 0`
- **Lifestyle/campaign:** `--ar 4:5 --v 7 --style raw --chaos 10`
- **Stories/vertical:** `--ar 9:16 --v 7 --style raw`
- **Landscape/banner:** `--ar 16:9 --v 7 --style raw`

### Workflow for Batch Consistency
1. Generate master image with no `--cref`
2. Upscale the best result
3. Copy image URL (right-click → copy image address)
4. Add `--cref [URL] --cw 75` to all subsequent prompts
5. Adjust `--cw` up/down based on how much variation you want

---

## Flux on Replicate

**API endpoint:** `black-forest-labs/flux-dev`  
**API URL:** `https://api.replicate.com/v1/models/black-forest-labs/flux-dev/predictions`

### Key Parameters
```json
{
  "prompt": "your prompt here",
  "negative_prompt": "blurry, deformed, extra limbs, low quality",
  "width": 1024,
  "height": 1280,
  "num_inference_steps": 28,
  "guidance_scale": 3.5,
  "seed": 42
}
```

### Aspect Ratios (width × height)
| Format | Dimensions |
|--------|-----------|
| Square | 1024 × 1024 |
| Portrait (4:5) | 1024 × 1280 |
| Vertical (9:16) | 768 × 1360 |
| Landscape (16:9) | 1360 × 768 |

### Consistency Strategy
- Lock `seed` across all prompts in a batch — same seed = same "starting noise"
- Keep subject description identical word-for-word across prompts
- Vary only the environmental/compositional elements
- For face consistency: Flux Redux or IP-Adapter (see fal.ai section)

### Negative Prompt Defaults
```
blurry, deformed, extra limbs, bad anatomy, watermark, text, low quality, disfigured, ugly, duplicate
```
Add specifics as needed: `extra fingers`, `bad hands`, `distorted face`

---

## fal.ai

**Primary model:** `fal-ai/flux/dev`  
**Docs:** https://fal.ai/models/fal-ai/flux/dev

### Key Parameters
```json
{
  "prompt": "your prompt here",
  "image_size": "portrait_4_3",
  "num_inference_steps": 28,
  "guidance_scale": 3.5,
  "num_images": 4,
  "seed": 42,
  "enable_safety_checker": true
}
```

### Image Size Options
`square_hd`, `square`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, `landscape_16_9`

### Consistency Tools on fal.ai
- **IP-Adapter (face):** `fal-ai/ip-adapter-face-id` — best for consistent faces across prompts
- **Flux Redux:** `fal-ai/flux/dev/redux` — image-guided generation (like `--cref` in MJ)
- **ControlNet:** `fal-ai/controlnet-union-sdxl` — for pose consistency

### Batch Generation
fal.ai supports `num_images: 1-4` per call. For 20+ images, loop with same seed base + increment.

---

## Platform Comparison

| Feature | Midjourney | Flux/Replicate | fal.ai |
|---------|-----------|----------------|--------|
| Photorealism | ★★★★★ | ★★★★☆ | ★★★★☆ |
| Consistency tools | `--cref` (excellent) | Seed locking (good) | IP-Adapter (good) |
| API access | Via unofficial API / Piapi | Native REST API | Native REST API |
| Speed | Medium | Medium | Fast |
| Cost | Subscription | Pay per run | Pay per run |
| Best for | Campaign quality | Batch automation | Face/product consistency |
