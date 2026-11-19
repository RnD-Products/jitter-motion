# Handoff: current work and working style

Read this at the start of a new session or account, after AGENTS.md and WORKFLOW.md. Update it whenever a task is finished or paused.

## How the user works (learned preferences)

1. **Analyse first.** For a reference video: read it frame by frame (`tools/contact-sheet.swift`, 17–50ms around key moments, full-resolution crops for text). Report the **motion, transitions, text animation and objects** separately. The user checks the analysis carefully, so do not summarise loosely.
2. **"See frame artboard and tell how implement"** = read every frame artboard, list its contents and give a plan. **Do not build yet.** Point out duration problems (the target artboard length vs the reference).
3. **"Build layers"** = build only the layer structure in the target artboard (copy layers from the frames, group into scenes, name clearly) and **show the tree before any motion**.
4. **"Start motion"** = add motion in named `opGrp`s, then screenshot the key moments and report. Say that playback was not verified.
5. **Match the reference exactly.** When the user says "not match" or "same to same", re-measure the reference frame by frame (positions, scale, timing) before changing anything. Common misses: alternating row directions, real loop orbits, letter-spacing animation, separate word and collage scale.
6. **Read the user's edits** when they say "check my edit". List what changed (times, values, easing) and keep their values.
7. **"Save this as workflow"** = WORKFLOW.md section first, then a skill only if reusable (AGENTS rule 8). **Don't push to GitHub unless the user says "push".**
8. Short replies with tables. Honest about what was not verified.

## Current task (paused here)

- **Jitter file:** `Ttk6OujVMGNKkShQns-p6` (https://jitter.video/file/?id=Ttk6OujVMGNKkShQns-p6)
- **Target artboard:** `Seative Showreel_SH20` (id `4SZjlvy3tFBS4OKLxoCtX`), **6.4s** (extended from 2.32s at the user's request).
- **Reference video:** `~/Downloads/Scene-142.mp4` (6.42s). See the Scene-142 analysis summary below.
- **Done:** layers built (no motion yet). The user approved the plan, and the next step is **"start motion"**.
  ```
  Main (#0c0b0b, clipped)
  ├─ Scene A - Headline: Labels(6), Client Tiles(8), Headline[70+, Word Drum A(mask band): successful, partnerships]
  ├─ Scene B - Social:   Tiles(17), Icons(heart/comment/send + counts), Word Drum B(mask band): Social Media, Behance, LinkedIn, Dribbble (all y 513)
  ├─ Scene C - Split:    5 tiles, Word - Drib, Word - bbble, Split line
  └─ Scene D - Stats:    Stats Set 1 Dribbble (26/624/387), Set 2 Fiverr (4.8/198/96%), Set 3 Seative (70+/$2.85B+/40%)
  ```
- **Motion plan (to build next):**
  - **A:** "successful" types in by letters while the gap closes; the labels type in; drum roll "successful" → "partnerships"; then "partnerships" wipes out letter by letter from the left.
  - **B:** tiles burst from the centre (growIn 0.3, 20ms stagger); "Social Media" → Behance → LinkedIn → Dribbble drum rolls, getting faster (slot machine); icons float with counters; tiles rotate and drift out.
  - **C:** "Dribbble" big, then "Drib" moves left and "bbble" right.
  - **D:** the phone panel grows from the gap; stats count up; the 3 sets swap with a drum roll.
  - **Drum roll recipe:** incoming word Card Flip `rotationX` 80 → 0 plus `move` up (+70 → 0); outgoing word `rotationX` 0 → −80 plus `move` up; about 250ms, smooth easing, overlapping 50–100ms. The outgoing word is faded (#f2f2f2 at 55%).

### Scene-142 key timings (for matching)
| Time | Beat |
|---|---|
| 0–0.45s | "successful" types in, gap closes |
| 0.48–0.75s | Roll successful → Kickstarters |
| 1.45–1.75s | Letters wipe from the left; light page slides in; the dark scene pulls back |
| 1.8–2.2s | Photo burst around "Social Media" |
| 2.25 / 2.65 / 2.85s | Rolls → Facebook → Instagram → TikTok (speeding up) |
| 3.4–3.75s | TikTok splits, phone card grows from the gap |
| 3.7–6.2s | Stats count up nonstop, photo cards swap around |
| 6.15–6.4s | Nested image zoom-through |

## Recent artboards (all built; WORKFLOW sections 5–5k)
SH07–SH19 are finished and saved as workflows and skills. SH18 (logo wall, Scene-134) and SH19 (moodboard, Scene-139) were tuned to the user's feedback but are **not yet saved as workflow**.
