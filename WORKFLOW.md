# How we work on Jitter animations

This is the detailed working guide for Jitter (jitter.video) motion work in this folder. It covers the setup, the step-by-step process, the Jitter API details we learned, and the mistakes to avoid. The short rules are in [AGENTS.md](AGENTS.md). Read both before any Jitter edit.

## 1. Setup

- **Jitter MCP connector.** All edits go through the Jitter MCP tools (prefix `mcp__<id>__`):
  - `list_files`: find files.
  - `searchConf`, `searchConfBatch`: read-only JavaScript against the file.
  - `applyConf`: edits.
  - `screenshotNode`: render an artboard at a given `timeMs`.
  - `getEditorApiReference`: the API docs, in three sections: `workflow`, `tools`, `schema`. Load `tools` before writing code and `schema` before adding new layers or operations.
- **File id.** The `id=` value in a Jitter link (`https://jitter.video/file/?id=<fileId>&nodeId=<nodeId>`) is the `fileId`. `nodeId` is usually the artboard.
- **Chrome extension (Claude in Chrome).** Use it when something exists only in the editor UI, for example the Effects tab (Card Flip, 3D Orbit and other shader effects). Add the effect once in the UI, then read and configure it through the API. Close your tab when done.
- **Video analysis tools.** There is no ffmpeg on this Mac. Use the Swift scripts in [tools/](tools/):
  ```bash
  swiftc -O tools/video-info.swift -o /tmp/video-info
  swiftc -O tools/contact-sheet.swift -o /tmp/contact-sheet
  /tmp/video-info ~/Downloads/Scene.mp4
  /tmp/contact-sheet ~/Downloads/Scene.mp4 /tmp/sheet.png 0.15 4.5
  /tmp/contact-sheet ~/Downloads/Scene.mp4 /tmp/dense.png 0.05 2.2 1.4
  ```
  The scratchpad can be wiped between turns, so compile again in the same command each time.

## 2. Process for every request

1. **Read the rules.** Read AGENTS.md and, if the user named a style (Bold, Playful, Elegant, Cinematic, Soft), read `skills/jitter-motion-styles/SKILL.md`.
2. **Inspect the file.** Use small `searchConf` reads:
   - Start with `conf.artboards`: `id`, `name`, `width`, `height`, `duration`, `x`, `y`.
   - Then read the layer tree of the target artboard: ids, names, types and boxes, three levels deep.
   - Take a `screenshotNode` at `timeMs: 0` to see the design.
3. **If there is a reference video:**
   - Run `video-info`, then make one contact sheet of the whole video at a 0.15s step.
   - Make dense sheets at a 0.05s step around each transition.
   - Write down each beat with its time (intro, hold, transition, outro) and how elements move: direction, scale, rotation, stagger order, overlap.
   - Map each beat to native presets. Say honestly what Jitter cannot do (for example a true 3D cube turn).
4. **Clone, never edit the original.**
   - Use `actions.clone(artboardId, { x, y })`, which returns `{ newId, idMap }`.
   - Name the copy clearly, for example `<Artboard> - Logo build` or `<Artboard> - v2`.
   - Place it in a free slot: to the right in the same row, or below. Never overlap another artboard.
   - Exception: if the user points at an empty artboard and says "apply the motion here", build inside it.
5. **Build the animation in one `applyConf`.** Group the operations in `opGrp`s:
   - `Intro` and `Outro` for one scene.
   - `Scene 01 Intro`, `Scene 01 Outro` and so on for multi-scene reels.
   - Never name individual operations.
6. **Check with screenshots.** Shoot mid-intro, the hold, each transition at its midpoint, mid-outro and the last frame. Fix gaps, overlaps and leaks (elements showing too early) before replying.
7. **Reply short:**
   - What changed.
   - What timing.
   - What was checked (which times).
   - What was not checked: playback is never verified by screenshots.

## 3. Hard rules (from the user)

- **Do not change easing or duration on your own.**
  - In: `slowdown:standard:v1`, intensity 50.
  - Out: `accelerate:standard:v1`, intensity 50.
  - Fades and masks: `linear`.
  - Text `easing`: `linear`, with `nodeEasing` slowdown.
  - If something does not fit in the duration, ask: offer to extend, or to squeeze. The user decides.
- **Native presets only** for in and out animations.
- **Pattern:** in, then a 4s hold, then out. If the duration does not allow the hold, say so.
- **Do not guess.** If a word is ambiguous (for example which way a mask center goes), ask one short question with clear options.
- **Never touch the original artboard**, and never touch the design frames used as sources.

## 4. Jitter API notes (learned the hard way)

### Reading
- `conf.artboards` is an array, not a function.
- `conf.layers(id)` and `conf.operations(id)` walk all levels. Filter `o.item.type === 'opGrp'` to get groups.
- `node.children` of a `layersTree` is in stored order: index `a0` is at the back.

### Writing
- `applyConf` code shape: `async (conf, actions) => { ... }`. It is all-or-nothing: on an error nothing is applied.
- After a timeout or a "server busy" error, re-read the file before retrying. The edit may or may not have committed.
- `actions.addObj({ id, item, children }, parentId, index?)`. Passing an artboard id as the parent routes the node to its layers or operations tree.
- `actions.moveObj(id, parentId)` with no index puts the node on top (front).
- `actions.clone(layerId)` clones inside the same parent. Then `moveObj` it into the target. This is how to copy layers from design frames into another artboard: all artboards are the same size, so x and y stay correct.

### Presets and operations
- **slideIn direction** is the direction of travel. `left` means the element moves leftward, so it comes from the right.
- **Mask presets:**
  - `maskCenterIn` / `maskCenterOut` with `angle: 0` open or close a horizontal band from the middle (the band grows vertically).
  - `angle: 90` makes a vertical band.
  - `maskRevealIn` / `maskRevealOut` take a `direction`.
- **Masks plus slides on the same group leave gaps.** The mask moves with the slide. Put the slide on the children and the mask on the group.
- **Absolute and relative transforms:**
  - `rotate` adds to the current angle: `{ fromValue: -35, toValue: 0 }` swings in from -35°.
  - `scale` is absolute: `{ fromValue: 1, toValue: 1.6 }`.
  - `move` uses offsets: `{ fromValue: { moveX, moveY }, toValue: {...} }`. Overlapping moves add up.
- **Scrolling a long page inside a clipped card:** `move` the tall inner group from `moveY: 0` to a negative value.
- **Hiding a layer:** `hide` with `startTime === endTime` hides it from that moment on.
- **Background colour fade:** a `color` op on a `layerGrp` fill works (`colorSpace: 'rgb'`).
- **Full-screen card:** scale = `max(artboardW / cardW, artboardH / cardH)`, plus about 2% extra so no thin edge line shows.
- **Fade an element to white:** put a white `rect` as the top child inside the group and `fadeIn` it (linear).
- **Echo or ghost text:** clone the text layer, set a smaller `scale` and opacity 55, move it with the main text, then `fadeOut`.

### Text
- Use `textIn` / `textOut`, with `split: 'letters' | 'words' | 'lines'`, `offset`, `nodeDuration` and `nodeEasing`.
- Text that is already outlined (shapes) is animated as shapes: one `slideIn` per letter, staggered.

### Morph
- Morph `fromValue` and `toValue` `x` and `y` behave like offsets from the layer's centre.
- What worked: `x: -width/2, y: -height/2`, with the layer's item width set to the final width.

### Card Flip effect (true 3D)
- Card Flip lives in the editor under **New Animation → Effects → Utility → Card Flip**. In the API it is a `customShader` op:
  ```js
  { type: 'customShader', presetId: 'card-flip', fingerprint: 'preset:card-flip', rootFingerprint: 'preset:card-flip',
    shaderUrl: 'https://assets.jitter.video/card-flip.json', freeze: 'both',
    fromValue: { rotationY: 0 }, toValue: { rotationY: 90, pivotX: 0 } }
  ```
- Other fields: `rotationX`, `rotationY`, `rotationZ`, `pivotX`, `pivotY`, `perspective` (default 0.45). There are also front-face and back-face toggles.
- The API cannot create a shader from nothing. Add it once in the UI, read it with `searchConf`, then copy its `item` (without `name`) to other layers with `addObj` and set the times and angles.
- For a card-to-card flip:
  - The old card goes from 0° to 90° (out easing).
  - The new card goes from -90° to 0° (in easing), starting when the first ends.
  - `freeze: 'both'` keeps the new card edge-on, so invisible, until its flip starts.

### Rate limits and timeouts
- "Rate-limiting" or "servers busy" means wait about 30 to 60 seconds, then retry once.
- Use a background `sleep 30` and wait for its notification instead of polling.

## 5. Multi-scene showreel recipe (SH05 - v2)

This is the structure that worked for a 3-frame website showreel.

**Setup**
- Artboard 1940×1220.
- One `layerGrp` per frame ("Scene 01", "Scene 02", "Scene 03"), each with a full-size background fill and `clipsContent: true`.
- Layers are copied in from the design frames 01, 02 and 03.

**Scene 01 intro, 0–0.75s**
- The centre laptop runs `growIn 0.85`.
- Side tiles `slideIn` outward from behind it, inner ones first, then outer.
- Headlines move in from the centre with ghost copies trailing.
- The paragraph slides in from the right.

**Scene 01 to 02, about 1.4–1.85s**
- Scene 02 opens over scene 01 with `maskCenterIn` (angle 0, linear). Scene 02 sits above scene 01.
- The new card swings in with `rotate -35 → 0`, slides up and grows.
- Scene 01 is hidden after the transition.

**Scene 02**
- The page inside the card scrolls with a `move` on the inner page.

**Scene 02 to 03, 2.45–2.85s**
- The cards use Card Flip: out 0°→90°, in -90°→0°.
- Scene 02 texts `slideOut` away from the centre.
- The frame 03 background opens with `maskCenterIn` on a separate background rect placed under scene 02's content.

**Scene 03**
- The labels slide in staggered and drift slowly.

**Outro, 3.8–4.35s** (artboard extended to 4.5s at the user's request)
- The card scales up to full screen over the labels.
- 200ms before it lands, a white rect fades in, so everything fades to white.

## 6. Logo build recipe

- Icon: `shrinkIn` scale 1.6 to 2 (it comes from big). Optionally add `spinIn`.
- Letters (shapes): `slideIn` up 40px, 250–300ms each, staggered 50ms left to right (or in a shuffled order for a playful build).
- Tagline: `maskRevealIn` to the right (linear).
- Outro: the reverse. Tagline `maskRevealOut` up, letters `slideOut` down from right to left, icon `shrinkOut`.

## 7. Reply checklist

- Name the artboard you changed, with times in seconds.
- State the easing only if it differs from the standard.
- Say which moments were screenshot-checked, and that playback was not verified.
- Say any rule you could not follow (duration, hold) and why.
