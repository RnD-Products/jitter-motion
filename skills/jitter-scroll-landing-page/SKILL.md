---
name: jitter-scroll-landing-page
description: Build a scrollable landing page animation in Jitter, in the style of the user's "Sereen" files. A full website page scrolls inside a fixed screen, one section per beat (two overlapping moves per beat), each section reveals after it lands, the navbar hides and returns, a cursor moves and triggers hovers, and the video loops back to the hero. One "Sereen" component artboard feeds the Dribbble, Reels and Pinterest formats. Use when the user gives a long landing page or website design and asks for a "scrollable landing page", "website scroll", "page scroll animation", "landing page video", "Sereen", or this workflow on any project.
---

# Scrollable landing page (from the user's Sereen files)

Details are in `WORKFLOW.md` section 5l. Read `AGENTS.md` first, and never edit the source frames.

## Artboards
- **"Sereen"**: the master, set as a component, sized to one screen of the page (1170×823 or 1600×980 in the references), 30–40s.
- **Format artboards** (Dribbble 1600×1200, Reels 1080×1920, Pinterest 1080×1500): a coloured background plus an instance of Sereen with its `playInstance`. Do all motion in Sereen only.

## Layers (back to front)
`Main` (clipped) → `Screen` mask group (`Screen Mask`, `Screen`) → `Hero_End` (copy of the hero) → `Scroll` (the whole page, one tall group) → `Navber` → `Mouse`.

## One scroll beat
| Op | Start | Length | Distance |
|---|---|---|---|
| `move` main | t | about 1300ms | most of it, e.g. −641 |
| `move` settle, same target | t + 410ms | about 1240ms | the rest, e.g. −182 |

- The deltas add up. Together they are about one screen height; adjust per section so it lands framed.
- Then hold 2–4s while the section animates. 6–10 beats per video.

## Easing
The reference files use **custom curves** for scroll, cursor and navbar. This breaks the native-presets rule, so **ask the user before using them**:

| Use | `custom:path:v1` control points |
|---|---|
| Scroll main | start `upper: 0.68`, end `lower: 0.8` |
| Scroll settle | start `upper: 0`, end `lower: {x: 0.58, y: 0.18}` |
| Cursor | `upper: 0.57`, `lower: 0.57` |
| Navbar hide | `upper: 0.7`, `lower: 0.5` |

## Steps
1. Clone or build the Sereen artboard with the layer order above. Put the full page in `Scroll`.
2. Choose the build:
   - **Simple:** move the single `Scroll` group every beat.
   - **Pinned sections:** nest the page (`Scroll_P.01` → `hero` + `Scroll_P01_1`, then `Scroll_ P02` …). Put the same pair of moves on every group that travels in that beat. Lower groups move first while the upper one stays, so the next section slides over a pinned one.
3. Add the scroll beats, one section each.
4. After each beat, reveal what is now in view with native presets (`slideIn`, `growIn` with `noFade`, `maskSlideIn`, `maskRevealIn`, `maskResizeIn` with `zoomContent`, `textIn` by lines, `blurSlideIn`), slowdown 50 or smooth 50. Start them while the settle move is finishing.
5. Navbar: `move` y −115 with the first scroll, +115 (slowdown 50) at the end.
6. Cursor: move the `Mouse` SVG between beats (0.8–1.6s each) to whatever reacts next, then play that hover (gallery slide, image swap, button).
7. Loop ending: in the last 2–5s play the hero video again in `Hero_End` and bring the hero text back in, so the last frame matches the first. In the simple build, also move `Scroll` back down.
8. Make the format artboards from instances of Sereen.

## Notes
- Group ops per section in `opGrp`s; do not name single operations.
- Screenshot each beat's end frame to check the section is framed.
- The recipe comes from reading the file data; playback of the references was not watched.
