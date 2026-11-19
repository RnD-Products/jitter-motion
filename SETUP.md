# Setup on a new Claude account

Follow these steps after switching to a different Claude account (or moving to another computer) so Claude works exactly as before.

Everything Claude needs is in this folder: rules, workflow, skills, tools and the current task. The only things tied to an account are the **connectors**, so set those up again.

## 1. Get the folder

- **Same Mac:** nothing to do. The folder stays at `~/Documents/Jitter folder`.
- **New Mac:**
  ```bash
  git clone https://github.com/RnD-Products/jitter-motion.git "$HOME/Documents/Jitter folder"
  ```
  The GitHub repo is private. Sign in with an account that has access to `RnD-Products` (`gh auth login`).

## 2. Open it in Claude Code

- Desktop app → **Code** tab → open the folder `Jitter folder`.
- Claude reads `CLAUDE.md` → `AGENTS.md` automatically, and loads every skill through `.claude/skills/` (a link to `skills/`).
- Check: ask "list the jitter skills". You should see 11 `jitter-…` skills.

## 3. Connect the Jitter connector (required)

- In the Claude app: **Settings → Connectors → add "Jitter"** and sign in with the **Jitter account that owns the Seative Showreel files**. It doesn't need to be the same email as Claude.
- Check: ask "list my Jitter files". You should see `Seative Showreel_SH01 … SH20`.
- Details: [JITTER-MCP.md](JITTER-MCP.md).

## 4. Optional connectors and tools

- **Claude in Chrome** (browser extension): needed only for editor-only Jitter features (e.g. adding the Card Flip effect the first time).
- **GitHub CLI** (`gh`): to push or pull the repo.
- **Xcode command-line tools**: the video-analysis scripts in `tools/` compile with `swiftc` (`xcode-select --install`).

## 5. Tell Claude to continue

Start the first message in the new account with:

> Read AGENTS.md, WORKFLOW.md and HANDOFF.md, then continue the current task.

[HANDOFF.md](HANDOFF.md) holds the task in progress and the user's working preferences.
