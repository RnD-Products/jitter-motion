# Jitter video: rules for any agent

These are the user's rules for Jitter animation work in this folder. Read them before every Jitter edit. Add new rules to this file when the user gives them.

## Rules

1. **Never change easing or duration on your own.**
   - Do not change an artboard's `duration`. Keep it exactly as cloned. If an animation or hold does not fit, tell the user instead of extending or shrinking it.
   - Do not pick, invent or copy your own easing. Use Jitter's native preset easing: in = `slowdown:standard:v1` intensity 50, out = `accelerate:standard:v1` intensity 50, fade and mask reveal = `linear`, text `easing` = `linear`. Do not copy easing from artboards an agent made earlier. If unsure, ask.
   - Only change either one when the user explicitly asks.
2. **Never touch the original artboard.** Clone it, animate the clone, and name the copy clearly.
3. **Native Jitter presets only** for in and out animations. Group operations in `opGrp`s named "Intro" and "Outro". Do not name individual operations.
4. **Animation pattern:** in animation, then a 4 second hold, then out animation. If the artboard duration does not allow the hold, say so; do not change the duration.
5. **Do not guess what the user means.** If a rule or a word is covered by a skill (see below), follow it.
6. **Environment notes:** copy and paste of animation segments does not work in the Claude app's embedded Browser pane (clipboard is denied). Use a normal browser, or copy animations through the Jitter API tools.
7. Keep replies short and honest. Report what was changed and what was not verified.

## Detailed workflow

See [WORKFLOW.md](WORKFLOW.md) for the full process, Jitter API notes, the Card Flip effect, recipes and the reference-video tools in `tools/`.

## Skills (shared by any agent)

- `skills/jitter-motion-styles/SKILL.md`: the words **Bold, Playful, Elegant, Cinematic, Soft** are the user's five motion styles. When the user says one, apply that style to a cloned artboard. The skill holds the in and out recipes.

Claude Code finds the skill through `.claude/skills/` (a link to `skills/`). Other agents should read `skills/<name>/SKILL.md` directly.
