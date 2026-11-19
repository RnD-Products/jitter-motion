---
name: jitter-orbit-ring
description: Build a Scene-153-style orbit in Jitter. Logos or app icons sit on an elliptical ring around a title and travel continuously clockwise around the loop (fast, slow, then fast again), pop in one by one from a spawn point so the ring unrolls, scale with depth (bigger at the front), and the ring tightens into the title at the end. Use when the user asks for an "orbit", "loop rotation", "icons around text", "logo ring", "trusted by logos", "Scene-153 style", or this workflow on any project.
---

# Logo orbit ring (from SH17)

Details are in `WORKFLOW.md` section 5k. Read `AGENTS.md` first, and never edit the source frames.

## Layers
```
Main (bg, clipped)
├─ Logo Ring
│  └─ Orbit - Logo NN (wrapper sized to the logo) → Logo NN   × N, numbered clockwise
└─ Title
```
Stack the wrappers small-to-big (back to front).

## Orbit maths
- Slot centres S[k] and sizes w[k] come from the layout.
- Phase p(t) in slots: 0–500ms ease-out to 4; 500–1650ms linear to 5.5; 1650–end ease-in to 8. Solve the crossing times T[1..8].
- For each logo k and step j: wrapper `move` delta S[k+j+1] − S[k+j] over T[j] → T[j+1] (linear).
- Wrapper `scale` chain toward (w[k+j+1] / w[k])^1.15. Only the first op has `fromValue`. Exit segments get ×up to 1.25.

## Reveal and exit
- The first 3 logos are visible at 0 at the spawn point (the right end of the title). The others `growIn` 0.2 (slowdown), 45ms apart, on the inner logo.
- Exit: Logo Ring `scale` → 0.35 (accelerate) over the last ~300ms. **Never rotate the ring group**, because it tilts the ellipse.

## Notes
- It must be a real loop (travelling through the slots), not a small drift; the user asked for this explicitly.
- z-order can't change mid-animation, so travelling logos keep their stacking.
- Watch the front-logo sizes so they don't overlap; reduce the exponent if they do.
