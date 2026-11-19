---
name: jitter-deal-in-fan
description: Build a Scene-112-style "deal-in" in Jitter. A fanned stack of 2–4 screens or cards swings in from the bottom-right corner, each rotating from about -12° to 0°, front card first and the rest trailing 100ms behind, then a slow push-in while the fan opens slightly. Use when the user has a frame with a fanned deck of dashboards/screens or asks for "deal in", "fan", "cards swing in", "ghost copies", "Scene-112 style", or this workflow on any project.
---

# Fanned card deal-in (from SH14)

Details are in `WORKFLOW.md` section 5h. Read `AGENTS.md` first, and never edit the source frames.

## Layers
`Main (bg, clipped)` → `Card 3 - Back`, `Card 2 - Middle`, `Card 1 - Front`, stacked back to front as in the frame.

## Motion
| Time | Op |
|---|---|
| 0–150ms | Empty background |
| Front card 150–750ms | `move` from (+1400, +1200) to 0, plus `rotate` −12 → 0, slowdown |
| Middle and back | The same, +100ms and +200ms |
| 950ms → end | Main `scale` 1 → 1.04; middle drifts (−30, +20), back drifts (−60, +40); smooth |

## Notes
- If the screens are flat images, there are no counters. If the front screen is editable, add `counter`s and a line draw, as in the reference.
- Grey ghost copies (the reference look) are optional: clone the front card, grey it at 40–60% opacity, and give it the same deal-in with a delay.
