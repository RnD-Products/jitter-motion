# Skills

Each folder here is one skill: a reusable recipe any agent can follow. Claude Code loads them automatically through `.claude/skills/` (a link to this folder). Other agents read `skills/<name>/SKILL.md` directly.

## Current skills

| Skill | Use it when |
|---|---|
| [jitter-motion-styles](jitter-motion-styles/SKILL.md) | The user names a motion style: Bold, Playful, Elegant, Cinematic or Soft |
| [jitter-shared-element-showreel](jitter-shared-element-showreel/SKILL.md) | A multi-frame story where one element travels through every frame (e.g. Figma → Webflow → Live) |
| [jitter-3d-carousel-showreel](jitter-3d-carousel-showreel/SKILL.md) | Two frames of phones/cards with different screens: band reveal, old devices tilt and blur out, new ones sweep in with a 3D turn, row glides into place (SH08, Scene-143 style) |
| [jitter-gradient-reveal-dashboard](jitter-gradient-reveal-dashboard/SKILL.md) | A UI/dashboard product shot: UI rises in, vertical gradient mask sweep reveals a photo and a second UI copy together, then counters and graph motion (SH09, Scene-123 style) |
| [jitter-screen-row-dive](jitter-screen-row-dive/SKILL.md) | A row of app screens: one starts alone, others pop in, each screen builds its UI, then the camera dives into the middle screen, which grows bigger (SH10, Scene-132 style) |
| [jitter-box-portal-showreel](jitter-box-portal-showreel/SKILL.md) | Phone on title → small box portal → phone in box (breaks out) → box fills screen → dashboard card frames grow in/out with chart detail motion (SH11, Scene-152 style) |

## Adding a new skill

1. Copy the template: `mkdir skills/jitter-<short-name> && cp skills/_template/SKILL.template.md skills/jitter-<short-name>/SKILL.md`.
2. Fill in `SKILL.md`:
   - `name` must match the folder name.
   - `description` says what it does **and** when to use it, with the user's trigger words. Agents decide from this line alone whether to load the skill.
   - Keep the body as steps, tables and exact values. Write down only what the user taught or confirmed; don't invent recipes.
3. Add a row to the table above.
4. Add one line under "Skills" in [../AGENTS.md](../AGENTS.md).
5. Commit and push.

`_template` is not a skill: its file is named `SKILL.template.md` so agents never load it.
