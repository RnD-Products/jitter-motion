---
name: jitter-gradient-reveal-dashboard
description: Build a Scene-123-style dashboard/app product shot in Jitter. The UI rises in, then a vertical gradient mask sweep reveals a photo background and a second copy of the UI at the same moment; the copy grows in, its numbers count up and its graph draws (bars, line, dots, tooltip). Use when the user gives a UI frame on a plain background plus the same UI over a photo, or asks for a "vertical gradient mask reveal", "gradient sweep", "no flash", "counting numbers", "graph motion", or this workflow on any project.
---

# Gradient-reveal dashboard shot (universal workflow)

This comes from SH09, built with the user and tuned by their edits. The detailed values are in `WORKFLOW.md` section 5c. Read `AGENTS.md` and `WORKFLOW.md` first, and never edit the source frames.

## 1. Read the project
- Frame A has the UI (position, scale) on a plain background. Frame B has the same UI at its final position over a photo.
- Check that the numbers are **text layers** and that the chart has separate parts (bar group, line, dots, tooltip). If they are single SVGs, counters and graph motion are impossible: ask the user for editable layers.

## 2. Show the layer structure before motion
```
Main (fill = frame A bg, clipped)
├─ Photo Reveal (maskGrp): Mask - Vertical Gradient + Background Photo
├─ Dashboard A - Frame 01      (rises in)
└─ Dashboard B Reveal (maskGrp): Mask - Vertical Gradient (Dashboard B) + Dashboard B - Frame 02
```
Mask rect: full width, height 2× the artboard height, starting just below the frame (y = artboard height). Its fill is a linear gradient (angle π/2): `#ffffff00` at 0 → `#ffffff` at 0.3 → `#ffffff` at 1. The mask uses alpha, so the edge is soft.

## 3. Timeline
1. **A rises in:** `scale` (about 0.6 → 0.82) plus `move` up from below the frame, smooth. Then a scroll up (`move`, natural easing).
2. **Switch moment (the same time for all):**
   - Both masks sweep up. `move` by `-(H + maskH × 0.3) - 20`, about 0.7s.
   - Photo: `scale` 1.5 → 1, `blurRadius` 10 → 0, slight drift.
   - B: `growIn` with scale about 2.6 (it settles down into place).
   - A: `scale` up (about 1.4), quick `fadeOut` (about 0.28s) so there is no double text, then `hide` at the sweep end.
3. **Data on B** (starts right after the switch):
   - `counter` per number (step so that `(to - from) / step` is about 100 or fewer, linear, staggered by about 80ms, `effect` appear/disappear with nodeDuration 1).
   - Bars: `maskRevealIn` right.
   - Line: `maskRevealIn` right, about 0.8s, linear.
   - Dots: `growIn` 0.3, timed to the line by their x position.
   - Tooltip: `growIn` 0.6 when the line reaches it.

## 4. Rules
- **No white flash** for scene changes in this style.
- Entries use slowdown, moves smooth, masks and counters linear. Keep the user's custom easings and timings when they have edited them.
- Keep the artboard duration the user sets.

## 5. Check
Screenshot: A rising, just before the switch, mid-sweep (soft edge, no double text), mid-count, mid line draw, and the final frame. Say that playback was not verified.
