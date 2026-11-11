---
name: jitter-box-portal-showreel
description: Build a Scene-152-style showreel in Jitter. A phone rises in on a title, exits up while a small coloured box appears as a portal; a second phone rises into the box, the box grows (phone breaks out of its top), a tagline slides in, the box fills the screen, then dashboard card frames grow in and out one after another with detail motion inside the cards. Use when the user has a phone-on-title frame, a phone-in-coloured-box frame and/or card/dashboard frames, or asks for a "box portal", "box mask", "grow out and in", "card details motion", "Scene-152 style", or this workflow on any project.
---

# Box-portal showreel with card frames (universal workflow)

This comes from SH11. Exact values are in `WORKFLOW.md` section 5e. Read `AGENTS.md` and `WORKFLOW.md` first, and never edit the source frames.

## 1. Read the project
- Frame 1: the phone render and title. Frame 2: box rect, phone and tagline. Frames 3+: card groups.
- Check that the charts (lines, bars, donut, dot columns) are **editable groups**. Flat SVGs can only move as a whole; ask for layers if detail motion is wanted.

## 2. Show the layer structure before motion
```
Main (fill = frame bg, clipped)
├─ Title, Phone 1
├─ Box Portal (hidden until the switch)
│  └─ Phone 2 Mask (maskGrp): Mask - Box Shape, Blue Box, Tagline, Phone 2
├─ Background for the card frames (e.g. Blur effects)
Frame_03, Frame_04 … (card groups)
```

## 3. Timeline pattern
1. **Phone 1 + title:** `slideIn` up with Card Flip `rotationX` 25→0; title fade-in with letter spacing tightening. Slowdown.
2. **Switch:** Phone 1 `slideOut` up (accelerate). At the same moment `show` the portal and grow the box (and the mask) from small.
3. **Phone 2** rises into the box. The box and mask grow to full box size **together**.
4. **Breakout at the end:** mask `resize` anchor `s`, about +200 height, starting just before the box finishes.
5. **Tagline:** `maskSlideIn` right.
6. **Box to full screen:** `scale` about 1.55 on the box **and** the mask. Phone and tagline `slideOut` up.
7. **Card frames:** fade in the background, then for each frame: `growIn` 0.7 (slowdown), detail motion, hold, `growOut` 1.3 (accelerate). The next frame starts after the previous one is gone. The last frame ends with `growOut` about 0.85.

## 4. Card detail recipes
- **Line chart:** `maskRevealIn` right (linear), then the marker or dot `growIn`.
- **Bars:** `maskRevealIn` up, staggered about 20ms; value labels `fadeIn` after each bar.
- **Donut or pie:** `spinIn` 90°. Legends `slideIn` up, staggered about 30ms.
- **Dot-matrix columns:** `maskRevealIn` up per column, about 3–4ms stagger (a wave).
- **Titles and buttons:** short `slideIn` up 20 or `fadeIn`.

## 5. Rules
- Mask and box always the same size and timing. Breakout only at the end.
- Use `scale` (not `resize`) for the final full-screen growth.
- Keep the user's durations and their easing tweaks.

## 6. Check
Screenshot: Phone 1 in, the switch (small box), Phone 2 in the box, mid-growth (edges match), breakout, full-screen box, each card frame built, each grow-out/in, and the last frame. Say that playback was not verified.
