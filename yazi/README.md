# Yazi over SSH

Standalone terminal config for Yazi 26.9.1. Required: `yazi`, matching `ya`, `nvim`, and `file` on PATH. Optional: `rg`, `fd`, `fzf`, and `zoxide` for Yazi's search/jump shortcuts; `7z` for archive extraction. No GIO, Python, desktop applications, or Wayland clipboard tools needed.

After copying `nvim-class` to the server, run there:

```bash
mkdir -p ~/.config
if [ -e ~/.config/yazi ]; then
  mv ~/.config/yazi ~/.config/yazi.backup-"$(date +%Y%m%d-%H%M%S)"
fi
cp -a ~/nvim-class/yazi ~/.config/yazi
yazi
```

- `o` / Enter: text/code opens in Neovim; archives offer extraction; other files show `file` information.
- `O` / Shift-Enter: Yazi's normal opener menu.
- `l` / Right: enter a directory; `h` / Left: leave it.
- `e`: jump to a typed path; Ctrl-Enter: shell in the current directory.
- `y` / `x` / `p`: copy / cut / paste files inside Yazi. `d`: Trash; permanent deletion with `D` is disabled.

Theme copied from the desktop config. Desktop-specific paths and clipboard bindings omitted. Inside Neovim's yazi.nvim window, use its Enter and split/tab bindings to open files in the existing editor.

Quick check: open a source file with Enter, quit Neovim back to Yazi, try `O`, and copy/paste a disposable file with `y` / `p`.
