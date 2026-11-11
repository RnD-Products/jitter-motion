---
name: jitter-shared-element-showreel
description: Build a one-scene Jitter showreel where one design element travels through several frames (for example Figma → Webflow → Live site, or design → code → app), using the user's own continuous-scene workflow. Use when the user gives 2+ design frames and a target artboard and wants a story or transition between them, says "frame 1 to frame 2 transition", "go to frame 3", "same transition", "design to live", or asks for this workflow on any project.
---

# Shared-element showreel (universal workflow)

This is the user's own method, taken from their rebuild of SH07. It works for any "frame A → frame B → frame C" story where **one element (usually the website or app screen) carries through every frame** while the surrounding UI changes around it.

Before any edit, read `AGENTS.md` (rules) and `WORKFLOW.md` (Jitter API notes). Never edit the source frames.

## 1. Read the project

1. List the artboards: `id`, `name`, `width`, `height`, `duration`, background colour.
2. For each source frame, read the layer tree three levels deep: names, types, boxes, `clipsContent`, `background`/`fillColor`, corner radius.
3. Screenshot each frame at `timeMs: 0`.
4. Identify the parts of each frame:
   - **Hero element:** the element that appears in every frame, usually "Web". Note its absolute box in each frame (add up the parent x/y values).
   - **Frame chrome:** the editor or tool UI around it, usually a "UI Mockups" group, plus its window background colour.
   - **Extras:** elements unique to one frame, such as Figma's Tablet/Mobile designs or the Live frame's device mockups.
   - **Final background:** the last frame's background colour.

If a frame's structure is unclear, ask the user. Don't guess. The user often organises the layers first; read them again after they say so.

## 2. Build the layer structure (in the target artboard)

```
Artboard (fill = final frame background)
└─ Main (layerGrp, artboard size, clipped)
   └─ Container (layerGrp, editor-window box, clipsContent: true)
      ├─ UI Mockups_<Tool A> (window bg, e.g. #1E1E1E)
      ├─ UI Mockups_<Tool B> (same window bg)
      ├─ <Tool A> extras (e.g. Tablet, Mobile design boards)
      ├─ Hero element (ONE copy, used for the whole story)
      └─ Final-frame extras (e.g. Tablet_mkp, Mobile_mkp, already at final positions)
```

- Copy layers in with `actions.clone(id)` followed by `actions.moveObj(newId, parent)`. All frames should be the same size so the coordinates stay correct.
- Keep **one hero element**. Don't swap it for another frame's copy; transform the same layer.
- Put the final-frame extras at their final positions. Their entries animate them in.

## 3. Choreography

Easing:
- **Entries:** `slowdown:standard:v1`, intensity 50.
- **Everything else** (fades, transforms, transitions): `smooth:standard:v1`, intensity 50.

| Beat | Operations | Notes |
|---|---|---|
| **Frame A entry** | `growIn` scale 0.9 on UI Mockups_A. Hero and extras: `slideIn` up 80px, staggered about 80ms | Slowdown, about 0.5–0.9s |
| **A → B** | `fadeOut` on UI Mockups_A and the A-only extras (about 300ms; the hero's label slightly shorter). **At the same time**, on the hero: `scale` 1 → s₁, `move` → (dx₁, dy₁), and `cornerRadius` to match B's canvas. Group these three in one nested `opGrp`. `fadeIn` on UI Mockups_B starts about 140ms after the hero starts moving | All smooth, overlapping, about 0.5s |
| **Frame B moment** | A short hold (about 0.2–0.3s) | |
| **B → C** | `fadeOut` on UI Mockups_B; its window background fades with it and reveals the final artboard colour. **At the same time**: `resize` the Container to full screen (slightly larger than the artboard) so it stops clipping. On the hero: a second `scale` with **no `fromValue`** (continues from s₁) to s₂, plus a second `move` (moves add up) → (dx₂, dy₂) | Smooth, about 0.5s |
| **Frame C entry** | Final extras: `slideIn` 120px from different sides (e.g. tablet up, mobile from the right), staggered about 100ms, starting just before the hero lands | Slowdown |
| **Hold** | The final frame holds to the end | |

Group the operations in `opGrp`s named "Frame 01 Intro", "Frame 01 Outro", "Frame 02 Intro", "Frame 02 Outro", "Frame 03 Intro". Never name individual operations.

## 4. Maths for the hero's landing

Jitter scales a layer around its centre, so:

```
s  = targetWidth / currentWidth          (use the visible page box, not the label)
c  = absolute centre of the hero group   (groupAbsX + width/2, groupAbsY + height/2)
p  = absolute top-left of the visible page box now
dx = targetX - (c.x + s * (p.x - c.x))
dy = targetY - (c.y + s * (p.y - c.y))
```

- For the second hop, the scale ratio is relative to the original size (`s₂ = targetWidth₂ / originalWidth`), because `scale` is absolute.
- The second `move` is added on top of the first.
- Work it out in `applyConf` from the real layer values, then screenshot the landing.

## 5. Timing

- Use the artboard duration the user gives. Don't change it unless they ask.
- If the final hold is short, say so.
- Typical 3.5s layout: entry 0–0.9s, A→B 1.0–1.5s, B→C 1.7–2.2s, C extras 2.1–2.7s, hold 2.7–3.5s.

## 6. Check

Screenshot these moments and look for jumps, clipping and early-visible elements:
- mid-entry
- mid A→B and the moment the hero lands
- mid B→C and the landing
- final-frame extras coming in
- the last frame

Report what was checked, and that playback wasn't verified.
