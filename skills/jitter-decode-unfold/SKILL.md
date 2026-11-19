---
name: jitter-decode-unfold
description: Build a Scene-141-style Jitter shot. Headline words "decode" letter by letter with a scrambling wrong trailing letter (one word can build from its right end), over a drifting photo with a camera push; the scene grows out, then a photo unfolds from a thin tilted strip while rotating and zooming, and surrounding labels drift outward. Use when the user asks for "scramble text", "decode text", "glitch type", "photo unfold", "Scene-141 style", or this workflow on any project.
---

# Decode text → photo unfold (from SH15)

Details are in `WORKFLOW.md` section 5i. Read `AGENTS.md` first, and never edit the source frames.

## Layers
```
Main
├─ Scene 1 - Code: background photo, headline texts (real text)
└─ Scene 2 - Showcase (own bg): maskGrp [Mask - Photo Shape rect, Photo], Labels
```

## Decode text
- Chain `changeText` (1ms each, about 45ms apart; appear/disappear effects): each step adds one correct letter plus one wrong letter, which keeps changing until the word locks.
- **From the right:** set `textAlign: right` and use suffix steps ("s", "ds", "rds", …).
- Don't rely on `textIn` with a large offset; it can show the whole word at once.

## Timeline (2.8s)
| ms | Beat |
|---|---|
| 0–800 | Decode both words; the photo fades in and drifts up; scene `scale` 1 → 1.1 |
| 1350–1600 | Scene 1 `growOut` 1.3 (accelerate) |
| 1600 | Cut: `show` Scene 2, `hide` Scene 1 |
| 1600–2000 | Mask `resize` height 40 → full (anchor centre, slowdown); mask group `rotate` 15 → 3 |
| 2000–2800 | Group `rotate` 0 → −3, `scale` 0.9 → 1.05; photo zooms 1 → 1.15; Scene 2 `scale` 1 → 1.04 |
| 1600–2800 | Labels `move` outward from the centre (±8% → ±8% of their offset), `scale` 0.95 → 1.1 |

## Notes
- The scramble letters are fixed sequences; Jitter has no random text.
- A 3D object turn-in (the reference's poster) can be added with Card Flip if the frame has such an object.
