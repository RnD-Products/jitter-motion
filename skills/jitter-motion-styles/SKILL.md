---
name: jitter-motion-styles
description: Apply one of the user's five Jitter motion styles (Bold, Playful, Elegant, Cinematic, Soft) to a UI artboard. Use when the user says Bold, Playful, Elegant, Cinematic or Soft in a Jitter / animation context, e.g. "make it Cinematic", "do the Soft style", "create Bold and Elegant versions".
---

# Jitter motion styles

The user's five named styles come from Jitter's own motion-tone brainstorm. When they name one (or several), clone the target artboard once per style, name each copy `<Artboard> - <Style>`, and animate it with the recipe below. Do not ask what the word means.

## Hard rules (the user was upset when these were broken)

1. Never change artboard `duration`. Keep it exactly as cloned. If an out animation or a hold would not fit, say so and ask; do not extend or shrink.
2. Never invent easing. Use Jitter's native preset easing only: in = `slowdown:standard:v1` intensity 50, out = `accelerate:standard:v1` intensity 50, text `easing` = `linear`, `maskReveal*` = `linear`. The only exceptions are the style-specific easings listed below (these are the ones Jitter itself uses for that style).
3. Use native presets (slideIn, growIn, shrinkIn, blurSlideIn, blurIn, fadeIn, maskSlideIn, maskRevealIn, textIn and their Out versions). Group operations in `opGrp`s named "Intro" and "Outro". Never name individual operations.
4. Before every Jitter edit, re-read this file and AGENTS.md (project rules).

## Order of the build (in), and reverse for the out

photo, logo, title, subtitle, form fields top to bottom, button block, testimonial card.
Out plays the reverse: card, buttons, fields bottom to top, subtitle, title, logo, photo.
Per-element start offset in the in is the "stagger" below.

## In recipes (from the existing style artboards)

| Style | Length | Stagger | Preset and values |
|---|---|---|---|
| Bold | 3s | 70ms | slideIn up 40px (card 80px) with `noFade: true`; photo growIn scale 0.85 `noFade`; text `slideAndFade` up 50px by words. Fast, punchy, ends early. |
| Playful | 3s | 60ms | `overshoot:standard:v1` easing (intensity 50, fields 40); growIn scale 0.6-0.7 for logo, photo, button, card; fields shrinkIn scale 1.2; title text effect `scale` 1.25 with `overshoot` intensity 65 as nodeEasing; subtitle `fade`. |
| Elegant | 4.5s | 100ms | maskSlideIn up (padding 0, 900ms) on logo, fields, buttons; photo maskRevealIn direction down with `natural:standard:v1` intensity 80, zoomContent true; card slideIn up 40px; text `slideAndMask` up 120px. Slow and clean. |
| Cinematic | 6s | 150ms | blurSlideIn up with blur 16-30px (distance 30-60px) on everything; photo blurIn blur 60px over 2.2s; text `blurSlideIn` blur 20px. Slowest, most dramatic. |
| Soft | 4s | 120ms | tiny slideIn up 15-20px (700ms); logo and photo fadeIn linear; text `fade` by lines/words. Gentlest. |

## Out recipes

Mirror each in preset with its Out counterpart, same direction, distance, scale and blur, native out easing, fade on (`noFade: false`). maskRevealOut direction `up`. Text uses `textOut` with the matching effect (`slideAndFadeOut`, `fadeOut`, `scaleOut`, `slideAndMaskOut`, `blurSlideOut`) and `accelerate` nodeEasing.

Timing: start the out after the last in ends. Prefer a 4 second hold (in, hold 4s, out) when the artboard duration allows it. If it does not, fit the out inside the remaining time, start it roughly 12% of the remaining time after the in ends, stagger ops by about 4% of the window, and tell the user there is no room for a hold; offer to lengthen the artboard only if they say yes.

## Procedure

1. Read artboards with `searchConf`; clone the source artboard once per style with `actions.clone`, placed in a free row slot (never overlapping).
2. Find the layers (photo image, logo, title, subtitle text, field groups, button block, testimonial card) and build the Intro and Outro `opGrp`s.
3. Screenshot mid-in, hold and mid-out; fix collisions.
4. Reply in one or two short sentences, noting any duration limit.
