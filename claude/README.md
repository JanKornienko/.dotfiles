# Claude Code configuration

Tracked so a new machine gets the same appearance and the same tooling.

| File | Linked to | What it carries |
| --- | --- | --- |
| `settings.json` | `~/.claude/settings.json` | statusline, enabled plugins, marketplaces, theme, effort level, TUI mode, attribution |
| `statusline.sh` | `~/.claude/statusline.sh` | the `<<ctx:23%>> :: model :: [5h | wk]` HUD |
| `keybindings.json` | `~/.claude/keybindings.json` | custom key bindings |
| `../agents/skills/` | `~/.agents/skills` | personal skills (see below) |

`statusLine.command` is `~/.claude/statusline.sh`, not an absolute path — it used
to be `/Users/jankornienko/.claude/statusline.sh`, which meant no status line at
all on Linux. The tilde form is what the Claude Code docs specify.

`attribution` is set to empty strings for both `commit` and `pr`, which suppresses
the automatic trailer in commit messages and the footer in pull request bodies.
It was previously set on the workspace only, so commits made from the laptop
carried a trailer and commits made from the workspace did not.

## Plugins are not tracked

`~/.claude/plugins/` is 44 MB of cloned marketplace repositories. Claude Code
re-clones them from `extraKnownMarketplaces` + `enabledPlugins` in
`settings.json`, so tracking the cache would only add weight and merge
conflicts. Installing the settings file is enough.

## Skills live under `~/.agents`

The skills installer keeps the real content in `~/.agents/skills/<name>/` and
puts *relative* symlinks in `~/.claude/skills/<name>` pointing back at it. That
layout is preserved: `install.sh` links `~/.agents` into this repo and recreates
the `~/.claude/skills/*` links for every skill it finds, so installing a new
skill on either machine shows up as a normal change in this repo.

## Not tracked on purpose

- `~/.claude.json` — holds per-project history and MCP auth state alongside
  settings; nothing in it is worth carrying between machines.
- `projects/`, `history.jsonl`, `sessions/`, `shell-snapshots/` — session state.
- `plugins/` — see above.
