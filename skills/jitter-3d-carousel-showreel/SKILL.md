---
name: jitter-3d-carousel-showreel
description: Build a premium 3D carousel transition in Jitter between two frames of device mockups (phones, cards, screens): band reveal from the centre, old devices tilting and blurring out to one side, new devices sweeping in with a 3D turn and blur, the row gliding into the final layout, a title that leaves and returns with letter spacing, and a living blurred-ellipse background. Use when the user gives two frames with a row of phones or cards and wants a "carousel", "3D", "Scene-143 style", "phones sweep in" or "not flat" transition, or asks for this workflow on any project.
---

# 3D carousel showreel (universal workflow)

This comes from SH08 (Scene-143 style), built with the user and refined by their own edits. Use it when **frame A has a few devices and frame B has a row of devices with different screens**. The screens change, so it is not a shared-element move (for that, see `jitter-shared-element-showreel`).

Before any edit, read `AGENTS.md` and `WORKFLOW.md`. Never edit the source frames. Build in the target artboard the user names, or in a clone if the user wants to keep an existing version.

## Avoid
- **Flat edge-on flips (Card Flip 0°→90° then -90°→0° in place).** The user called them "flat and cheap". Use the carousel sweep below instead.
- Starting background loops late. Every background op starts at **0ms**.

## 1. Read the project
- For each frame: device layers and their absolute x/y (add the parent offsets), the title text (position, `letterSpacing`), and the background blur group (ellipses).
- Compare the device image URLs between the frames. Different URLs mean new screens, so the carousel sweep applies.
- Note frame B's exact device x positions. The final layout must land there.

## 2. Layer structure (show it to the user before adding motion)
```
Main (layerGrp, artboard size, white fill, clipped)       ← band reveal target
├─ Background Blur (blurred gradient ellipses)            ← drifts the whole time
├─ Phones Row (layerGrp)                                  ← final glide + outro
│  ├─ Slot 1..n - Phone (Frame B)                         ← new devices
│  └─ Slot k - Cube: Face B - Frame B, Face A - Frame A   ← the old device and the new device in the same slot
└─ Title (one text layer, shared across both frames)
```
The user may rest the new devices further right (by an offset) and let the row glide them into frame B's positions. Read their layout before setting distances.

## 3. Timeline (about 3.2–3.5s)
Easing: **slowdown** for entries and landings, **smooth** for travel and transitions, **accelerate** for the final outro. All intensity 50.

| Time (ms) | Beat | Operations |
|---|---|---|
| 0–350 | Band reveal | `maskCenterIn` on Main, `angle: 0`, `zoomContent: true`, slowdown |
| 0–3500 | Background alive | Background Blur group: `move` (about -48, +48). Each ellipse: its own `move` (90–210px, varied directions), `rotate` (±10–20°), `scale` (0.88–1.18). All **start at 0**, smooth |
| 100–800 | Title in | `slideIn` left 200 plus `letterSpacing` from base+40 → base, slowdown |
| 150–850 | Frame A devices in | `slideIn` up 100, staggered 100ms, slowdown |
| 1350–2020 | Frame A devices out | For each device: `slideOut` left (distance = x + width + about 100, so fully off-screen; 1900 for a 1940 artboard), Card Flip `rotationY` 0→40, `blurRadius` 0→14. Smooth, staggered about 70ms |
| 1400–1800 | Title out | `move` x -2200 (far enough that the widened text leaves fully) plus `letterSpacing` base → base+40, smooth |
| 1500–2490 | Frame B devices sweep in | For each device, left to right, staggered 80ms, 750ms each: `slideIn` left (the **same distance for all**, enough to start the first one off-screen right; 1600 here), Card Flip `rotationY` -40→0, `blurRadius` 14→0. Slowdown |
| 1700–2730 | Row glide | `move` on Phones Row from the resting offset to frame B's exact positions (here -556px), slowdown |
| 1900–2500 | Title back | `move` from off-screen right to frame B's title position, plus `letterSpacing` base+40 → base, slowdown |
| ~2860–3240 | Outro (user's edit) | `slideOut` up 80, `noFade: true`, accelerate, on the Title (2860–3210) and the Phones Row (2890–3240) |

The artboard ended at **3240ms** after the user's edit. Keep the user's duration.

### Card Flip (3D tilt) op
```js
{ type: 'customShader', presetId: 'card-flip', fingerprint: 'preset:card-flip', rootFingerprint: 'preset:card-flip',
  shaderUrl: 'https://assets.jitter.video/card-flip.json', freeze: 'both',
  fromValue: { rotationY: -40 }, toValue: { rotationY: 0, pivotX: 0 }, easing, startTime, endTime, targetId }
```
Use it for **tilt while moving** (±40°), never for a full 90° flip in place.

## 4. Maths
- **Exit distance:** at least `deviceX + deviceWidth + margin` (the device's absolute x plus its width plus about 100).
- **Entry distance:** at least `artboardWidth + margin - finalX` for the leftmost new device. Use that same value for all devices so the row spacing stays even.
- **Row glide:** `frameB_x - restingX` of any device (the same for all).
- **Title move:** two `move` ops add up. Exit `-2200`, then a second move from `(exitOffscreenRight, dy)` to `(finalX - startX + 2200, dy)`.

## 5. Check
Screenshot: mid band reveal, the frame A hold, about 1.55s (old devices leaving, blurred), about 2.0s (old devices fully gone, new row sweeping), mid-glide, the final frame (it must match frame B), and mid-outro. Say that playback was not verified.
