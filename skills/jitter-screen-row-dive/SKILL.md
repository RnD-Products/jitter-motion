---
name: jitter-screen-row-dive
description: Build a fast Scene-132-style app showcase in Jitter. A row of app screens on a flat background where one screen starts alone, the others pop in from the centre outward, each screen builds its own UI (inside motion), then the camera dives into the middle screen, which grows bigger than the others while the neighbours spread off the edges. Use when the user gives a frame with a row of app/phone screens and asks for "zoom in", "dive", "screens pop", "inside motion", "Scene-132 style", "middle screen scale big", or this workflow on any project.
---

# Screen row zoom-dive (universal workflow)

This comes from SH10. Exact values are in `WORKFLOW.md` section 5d. Read `AGENTS.md` and `WORKFLOW.md` first, and never edit the source frame.

## 1. Read the project
- Screens: their order left to right and which one is the middle (hero) screen.
- Are the screens **editable groups**? Inside motion needs lists, tiles, waveform bars, text, buttons and illustration parts as separate layers. If the screens are images, say so and ask for editable versions.

## 2. Show the layer structure before motion
```
Main (fill = frame bg, clipped)
└─ Screens Row (centred on the artboard)
   └─ Screen 1..n, named left to right; the middle screen on top of the stack
```

## 3. Timeline (about 2.8s)
1. **Start:** `hide` every screen except the middle one at 0.
2. **Pops:** `show` the inner neighbours at about 100ms and the outer ones at about 250ms. Hard cuts.
3. **Zoom:** row `scale` about 0.35 → 0.75, smooth, until about 1.6s.
4. **Inside motion** (about 0.25–1.4s, slowdown, staggered so something always moves):
   - lists slide up row by row;
   - tiles grow in from 0.8;
   - waveform bars `resize` up from the centre line;
   - text by lines;
   - buttons pop from 0.6;
   - illustrations build layer by layer.
5. **Dive (out, accelerate):** row `scale` 0.75 → about 2.2.
   - The **middle screen gets an extra `scale` 1 → 1.3**, so it ends bigger than the others.
   - Neighbours `move` outward: inner about ±300, outer about ±440, enough that they never overlap.

## 4. Rules
- Entries use slowdown, the zoom uses smooth, the dive uses accelerate (the user confirmed this).
- Pops are instant, never fades.
- Keep the user's duration and any values they tune.

## 5. Check
Screenshot: the start (one screen), mid-build, the fully built row, mid-dive (middle screen visibly bigger, no overlap), and the end. Say that playback was not verified.
