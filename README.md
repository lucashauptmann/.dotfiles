# .dotfiles

Personal dotfiles for macOS with WezTerm, Claude Code, Neovim, and AeroSpace.

## Setup

1. Clone the repo
2. Copy `dot-wezterm.env.example` to `~/.wezterm.env` and fill in your paths
3. Symlink dotfiles to `~` (e.g., `dot-zshrc` -> `~/.zshrc`)
4. Create `~/.zshrc.local` for any secrets/API keys (sourced automatically, gitignored)

## What's included

| File | Description |
|------|-------------|
| `dot-zshrc` | Zsh config (Oh My Zsh, git + rbenv plugins) |
| `dot-wezterm.lua` | WezTerm terminal config (split tabs, color-coded workspaces) |
| `dot-wezterm.env.example` | Template for WezTerm workspace paths |
| `dot-aerospace.toml` | AeroSpace tiling window manager config |
| `dot-config/nvim/` | Neovim config |
| `dot-irbrc` | Ruby REPL config (awesome_print) |
| `dot-claude/` | Claude Code skills, hooks, and statusline |

## Claude Code

`dot-claude/` contains reusable Claude Code configuration:

- **`CLAUDE.md`** — global instructions for all projects
- **`skills/`** — reusable skills (code review, planning, diary, etc.)
- **`hooks/save-diary.sh`** — auto-summarizes Claude sessions into a daily engineering diary
- **`statusline-command.sh`** — rich statusline with git branch, context usage, session ID

### Engineering diary hook

The `save-diary.sh` hook writes session summaries to a local git repo. To use it:

1. Create a git repo for your diary (e.g., `~/dev/engineering-notes`)
2. Set `DIARY_REPO` in your environment to the repo folder name (defaults to `engineering-notes`)
3. The hook expects the repo at `~/dev/$DIARY_REPO`

## Environment variables

Set these in `~/.wezterm.env` or your shell profile:

| Variable | Default | Description |
|----------|---------|-------------|
| `WEZTERM_BACKEND_*` | — | Paths for Backend workspace panes |
| `WEZTERM_WEB_*` | — | Paths for Web workspace panes |
| `WEZTERM_PERSONA_*` | — | Paths for Persona/Cortex workspace panes |
| `WEZTERM_SWARM_DIR` | `~/dev/tools/claude-swarm` | Swarm tab working directory |
| `WEZTERM_CLAUDE_DIR` | `~` | Claude tabs working directory |
| `DIARY_REPO` | `engineering-notes` | Folder name for diary repo under `~/dev/` |
