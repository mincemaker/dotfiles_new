# dotfiles_new — chezmoi source directory

## Critical constraint

- This repo is a **chezmoi source directory only** on the home-manager managed PC.
- Run `chezmoi status --source <dotfiles-dir>` to inspect — **never run `chezmoi apply`**.
- Reason: home-manager owns the dotfiles on that machine; applying chezmoi would conflict.

## Repo structure

```
dot_config/    → ~/.config/  (fish, nvim, ghostty, bottom, polybar, ranger, starship.toml)
dot_tmux.conf  → ~/.tmux.conf
dot_zshrc      → ~/.zshrc
dot_gitconfig  → ~/.gitconfig
```

- `dot_*` prefix is the chezmoi convention for files in `~/.`.
- `dot_config/` entries map directly (no `dot_` prefix needed for `dot_config` itself → `~/.config`).

## Key config details

- **tmux**: prefix is `C-z` (`C-b` is prefix2), vi copy mode, OSC52 clipboard. `prefix+T` launches sesh session picker (fzf-tmux) when sesh is on PATH.
- **zsh**: starship prompt, fzf integration, emacs key bindings.
- **fish**: CachyOS aliases (`eza`-based listings, pacman helpers), depot_tools PATH.
- **git**: user = mincemaker, editor = vim.

## Hostname exclusions

- `.chezmoiignore.tmpl`: ignores **all files** on hostname `cachyos-x8664`.

## External deps

- `.chezmoiexternal.toml`: pulls `ghostty-shaders` git repo into `.config/ghostty/ghostty-shaders`.

## Tooling

- `mise.toml` manages chezmoi tool version.
