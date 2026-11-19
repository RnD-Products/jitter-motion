---
name: jitter-reel-assembly
description: Assemble several finished Jitter frames (each with its own motion, videos included) into one showreel artboard, playing them in sequence and ending with fast rough cuts between video shots (e.g. 0.5s each). Copies layers and ops, shifts timing, and fixes old frames that can't be cloned. Use when the user says "after frame 1 and 2 motion, 3/4/5 rough cut", "combine these frames", "put the frames in sequence", or this workflow on any project.
---

# Reel assembly with rough cuts (from SH16)

Details are in `WORKFLOW.md` section 5j. Read `AGENTS.md` first, and never edit the source frames.

## Steps
1. Read each frame: its duration, when its last op ends, and any `playVideo` ops.
2. **Ask about length** if the sum doesn't fit the target duration. Offer: end each frame when its motion ends, or keep the full frame lengths.
3. Make `Main` (clipped), then one **scene group per frame** (clipped; give it the frame's background colour if it has one).
4. **Copy layers + ops:**
   - Try `actions.clone`. If it fails, rebuild the tree manually with new ids and strip `duration`, `component`, `componentStatus` and `csvImportInfo` from layers **and** ops.
   - Set a missing `endTime` to `startTime`, and remap `targetId`.
   - Shift every op by the scene start.
   - `playVideo`: start/end = the scene window, `freeze: 'none'`.
   - Put each scene's ops in "Scene N - … Motion".
5. **"Rough Cuts" group:** `hide` later scenes at 0; at each cut, `show` the next scene and `hide` the previous one at the same instant.
6. Screenshot inside every scene window.

## Notes
- Video playback can't be confirmed from screenshots; say so.
- The user often reorders scenes and adds pops (e.g. a logo `growIn` on the first video cut). Read their edits before changing anything.
