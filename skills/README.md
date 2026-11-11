# Skills

Each folder here is one skill: a reusable recipe any agent can follow. Claude Code loads them automatically through `.claude/skills/` (a link to this folder). Other agents read `skills/<name>/SKILL.md` directly.

## Current skills

| Skill | Use it when |
|---|---|
| [jitter-motion-styles](jitter-motion-styles/SKILL.md) | The user names a motion style: Bold, Playful, Elegant, Cinematic or Soft |
| [jitter-shared-element-showreel](jitter-shared-element-showreel/SKILL.md) | A multi-frame story where one element travels through every frame (e.g. Figma → Webflow → Live) |

## Adding a new skill

1. Copy the template: `cp -R skills/_template skills/jitter-<short-name>`.
2. Fill in `SKILL.md`:
   - `name` must match the folder name.
   - `description` says what it does **and** when to use it, with the user's trigger words. Agents decide from this line alone whether to load the skill.
   - Keep the body as steps, tables and exact values. Write down only what the user taught or confirmed; don't invent recipes.
3. Add a row to the table above.
4. Add one line under "Skills" in [../AGENTS.md](../AGENTS.md).
5. Commit and push.

Folders starting with `_` (like `_template`) are not skills and are ignored.
