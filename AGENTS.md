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
8. **"Save this as workflow" means WORKFLOW.md first.** Add or update a section in WORKFLOW.md in the same style as the existing sections. Then, only if it is needed (the method is reusable on other projects, or it changes a recipe an existing skill holds), also add it to a skill: update the matching skill in `skills/`, or create a new one if none fits. Say which skill was changed and why.

## Detailed workflow

See [WORKFLOW.md](WORKFLOW.md) for the full process, Jitter API notes, the Card Flip effect, recipes and the reference-video tools in `tools/`.

## Skills (shared by any agent)

- `skills/jitter-motion-styles/SKILL.md`: the words **Bold, Playful, Elegant, Cinematic, Soft** are the user's five motion styles. When the user says one, apply that style to a cloned artboard. The skill holds the in and out recipes.

- `skills/jitter-shared-element-showreel/SKILL.md`: the user's universal workflow for multi-frame stories (for example Figma → Webflow → Live). One continuous scene, one hero element that travels through every frame, overlapping UI crossfades, slowdown for entries and smooth for everything else.

- `skills/jitter-3d-carousel-showreel/SKILL.md`: two frames of devices with different screens. Band reveal, old devices tilt and blur out, new ones sweep in with a 3D turn and blur, the row glides into the final layout, the title leaves and returns with letter spacing, and the background ellipses keep moving. Never use flat edge-on flips.

- `skills/jitter-gradient-reveal-dashboard/SKILL.md`: dashboard or app product shot. The UI rises in, then a vertical gradient mask sweep reveals the photo background and a second UI copy at the same moment, followed by counters and graph motion. No white flash.

- `skills/jitter-screen-row-dive/SKILL.md`: fast app showcase. A row of screens pops in from the centre, each screen has inside motion, then the camera dives into the middle screen, which scales bigger than the others while the neighbours spread out.

- `skills/jitter-box-portal-showreel/SKILL.md`: phone on title → small coloured box portal → second phone in the box (breaks out of its top) → box fills the screen → card frames grow in and out with chart detail motion. The mask and box always move together.

### Using the skills from any agent

**Claude Code is the primary agent for this folder.** It does the main Jitter work and keeps the rules, workflow and skills up to date. Other agents are supported as secondary agents and follow the same files.

- **Claude Code (primary)** loads the skills automatically through `.claude/skills/` (a link to `skills/`). When the user teaches a new method, Claude Code writes it into the skills and docs.
- **Every other agent** (Codex, Cursor, Copilot, Gemini, Windsurf and others) does not load skills automatically. **Before each task, open [skills/README.md](skills/README.md), find the skill whose "Use it when" matches the request, read its `SKILL.md`, and follow it step by step.**
- Each agent has a pointer file that sends it here: `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.cursor/rules/jitter.mdc` and `.windsurfrules`. Codex reads this AGENTS.md directly.
- All agents need the Jitter MCP connector to edit Jitter files. See [JITTER-MCP.md](JITTER-MCP.md).

More skills will be added over time. The full list and the steps for adding one are in [skills/README.md](skills/README.md). When the user teaches a new reusable method and asks to save it as a skill, follow those steps.
