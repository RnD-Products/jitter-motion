---
name: jitter-vertical-card-carousel
description: Build a Jitter showreel where dashboard scenes push and grow out into a vertical column of cards that scrolls up one card per beat inside fixed focus brackets, while a 3-line headline rolls up in sync (focus line orange, others faded). Use when the user has frames showing the same card column at different scroll positions with rolling text ("All in one / One system / One clear view"), or asks for a "vertical carousel", "rolling text", "focus brackets", "SH13 style", or this workflow on any project.
---

# Vertical card carousel with rolling text (from SH13)

Details are in `WORKFLOW.md` section 5g. Read `AGENTS.md` first, and never edit the source frames. Show the layer structure before adding motion.

## Layers
```
Main (clipped)
├─ Scene 1 (dashboard + headline)
├─ Scene 2 (dashboard + headline)
└─ Scene 3 - Carousel
   ├─ Glow Circle
   ├─ Cards Column     cards in the order the frames show them (duplicates OK)
   ├─ Focus Brackets   separated from the cards, fixed in the centre
   └─ Rolling Text     all lines in one group
```

## Beats
1. **Scene 1 in:** the dashboard `slideIn` up with Card Flip `rotationX` 15 → 0; the headline rises by line.
2. **Push 1 → 2:** Scene 1 `slideOut` left while Scene 2 `slideIn` from the right (smooth).
3. **Scene 2 details:** headline words rise, the last word pops; KPI `counter`s; table rows `slideIn` up, staggered.
4. **Grow out:** Scene 2 `growOut` 1.2 (accelerate). The column rises in; the brackets `shrinkIn` 1.15; the first text line slides in.
5. **Each step:** column `move` up by card height + gap; text `move` up one line; `color`/`opacity` swap on the lines (focus = solid orange 100%, others = faded gradient 30%); bracket pulse 1 → 0.97 → 1.
6. **Card detail** starts as each card enters the brackets: bars up, line draw right, dots wave, tooltip pop.

## Rules
- Slowdown for ins, smooth for moves, accelerate for outs.
- Keep the user's duration (SH13 was 6s at the user's request).
- Check every step against its source frame with a screenshot.
