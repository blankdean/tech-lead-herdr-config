# tech-lead-herdr-config

Opinionated [Herdr](https://herdr.dev) config: a Ctrl-a prefix, Shift-arrows for tabs, and a one-chord spaces picker.

Mouse still works for everything — click panes, tabs, and the sidebar; right-click to split or rename; drag borders; drag-select to copy. This file only adds keyboard shortcuts on top.

![Herdr](https://img.shields.io/badge/Herdr-0.9%2B-89b4fa)
![License: MIT](https://img.shields.io/badge/License-MIT-blue)

## Keys

Prefix is **Ctrl-a**. Press Ctrl-a, release, then the action key. Press **Ctrl-a then `?`** for the live list.

| Action | Keys |
| --- | --- |
| Prefix | `Ctrl-a` |
| Next / previous tab | `Shift-Right` / `Shift-Left` |
| Rename current tab | `Ctrl-a` then `,` |
| Spaces picker | `Cmd-e` |
| Spaces picker (fallback) | `Ctrl-Alt-w` |
| Spaces picker (prefix) | `Ctrl-a` then `w` |
| In the picker: next / previous space | `j` / `k` |

Herdr defaults still apply for everything else (splits, zoom, detach, sidebar, new workspace, …).

`Cmd-e` only works if the outer terminal forwards Command to Herdr. Many terminals bind Command+e themselves. If the picker does not open, free that chord in the terminal, or use `Ctrl-Alt-w`.

After `Cmd-e`, `j`/`k` move the space list (arrows still work). These keys only apply in the picker; they do not steal typing in a pane.

Rename is `Ctrl-a` then `,`. `Ctrl-a` then `Shift-t` still works too.

## Install

Install [Herdr](https://herdr.dev/docs/install/) first if you do not have it:

```sh
curl -fsSL https://herdr.dev/install.sh | sh
```

Then install this config:

```sh
curl -fsSL https://raw.githubusercontent.com/blankdean/tech-lead-herdr-config/main/install.sh | bash
```

Or clone and run it yourself:

```sh
git clone https://github.com/blankdean/tech-lead-herdr-config
cd tech-lead-herdr-config
./install.sh
```

The script copies `config.toml` to `~/.config/herdr/config.toml`, backs up a file already there, validates with `herdr config check`, and reloads a running server.

To keep a git checkout as the live file (edits stay in the repo):

```sh
./install.sh --link
```

## What this does not do

- It does not install Herdr.
- It does not change your terminal emulator. `Cmd-e` is a Herdr binding; whether Command reaches Herdr is up to the terminal.
- It does not replace `~/.config/herdr/` (sockets, logs, and session state stay there). Only `config.toml` is written.

## Customize

Edit `~/.config/herdr/config.toml`, then:

```sh
herdr config check
herdr server reload-config
```

Theme, prefix, and every binding are documented in [Herdr configuration](https://herdr.dev/docs/configuration/).

## License

MIT
