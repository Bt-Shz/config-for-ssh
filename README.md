# Class Neovim configuration

LazyVim configuration for C/C++ programming over SSH. Includes completion, LSP navigation and diagnostics, Tree-sitter, formatting, Git tools, search/replace, incremental symbol rename, symbol outline, surround editing, and JSON/TOML/shell support. No custom Markdown or Obsidian integrations.

## Requirements and installation

- Neovim 0.11.2+ with LuaJIT, Git, curl, unzip, a C compiler, and tree-sitter-cli. See [LazyVim requirements](https://www.lazyvim.org/).
- `yazi` and `ya` on PATH. Your matching 26.9.1 binaries under `~/.local/bin` work with the current stable [yazi.nvim](https://github.com/mikavilpas/yazi.nvim/releases/tag/v14.0.2).
- `rg` for project search; `fd` for fast file finding. `lazygit` is optional.
- GCC/G++ for the single-file runner. Node.js/npm for Bash and JSON language servers installed through Mason.

Keep `~/.local/bin` on the server's PATH. No system-wide installation or sudo is needed. Mason installs language servers and tools under Neovim's user data directory; it still needs the relevant runtimes and compatible binaries on the server.

To deploy from this checkout, first stage the complete config from your local machine:

```bash
scp -r /home/shz/nvim-class ap:~/nvim-class
ssh ap
```

If `~/nvim-class` already exists on the server, choose a fresh staging directory and adjust the commands below. On the server, back up the existing config, then copy the staged version:

```bash
mkdir -p ~/.config
if [ -e ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.backup-"$(date +%Y%m%d-%H%M%S)"
fi
cp -a ~/nvim-class ~/.config/nvim
nvim
```

Run `:Lazy sync`, wait for installation to finish, and restart Neovim. Run `:Mason` and verify `clangd`, `clang-format`, `lua-language-server`, `stylua`, `bash-language-server`, `shellcheck`, `shfmt`, `json-lsp`, and `taplo` installed successfully. Use `:Lazy update` deliberately to update plugins later.

## Coding and file management

`<leader>` is Space. Language support and editor features use maintained LazyVim Extras.

| Keys | Action |
| --- | --- |
| `<leader>e` / `<leader>fe` | Open Yazi at the current file |
| `<leader>E` / `<leader>fE` | Open Yazi at Neovim's working directory |
| `<leader>fy` | Resume the last Yazi session |
| `<leader><space>` | Find project files |
| `<leader>sg` | Search project text |
| `gd` / `gr` / `K` | Definition / references / documentation |
| `<leader>cr` | Rename symbol with preview |
| `<leader>cs` | Toggle symbol outline |
| `<leader>ch` | Switch C/C++ source/header |
| `<leader>cf` | Format buffer or selection |
| `<leader>cc` | Compile and run the current C/C++ file |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surrounding delimiters |
| Tab / Shift-Tab | Indent / unindent line or selection |

Inside Yazi: Enter opens a file, `q` closes the window, F1 shows integration help, Ctrl-V/Ctrl-X/Ctrl-T open splits or tabs, Ctrl-S searches with Snacks, Ctrl-G opens search/replace, and Ctrl-Y copies relative paths using Neovim's clipboard provider. Opening a directory with `nvim .` also opens Yazi. File operations use Yazi's own behavior; the old `gio trash` mappings were removed because they assumed desktop utilities on the server. See [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) for the integration keys.

Formatting runs on save using LazyVim's defaults and the project's `.clang-format`, if present. The runner compiles with `-Wall -Wextra -g`, creates a neighboring `.out` executable, and runs it from the source directory only after successful compilation. Compiler defaults determine the language standard. For multi-file assignments, use the course's Makefile/build commands in a terminal; the runner compiles only the current file. A `compile_commands.json` or `compile_flags.txt` gives Clangd the project's include paths and compiler flags.

## SSH clipboard

SSH/tmux sessions use Neovim's built-in OSC 52 writer. Ordinary yanks (`yy`, `yw`, visual `y`, and named-register yanks) copy to your local computer's clipboard. Explicit `"+y` and `"*y` work too. Deletes and changes keep their usual Neovim registers without replacing the local clipboard; `"_y` does not copy.

`p`/`P` retain normal Neovim behavior. `"+p` and `"*p` paste their last cached copy from this Neovim session. To paste text copied in a local application into SSH Neovim, enter Insert mode and use your terminal's paste shortcut (usually Ctrl-Shift-V). The config does not query the local clipboard, avoiding unsupported OSC 52 reads and paste timeouts. See [Neovim clipboard documentation](https://neovim.io/doc/user/provider.html#clipboard-osc52).

Your local terminal must permit OSC 52 clipboard writes. Kitty's default `clipboard_control` includes `write-clipboard`; no terminal edit is needed with that default. See [Kitty clipboard settings](https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.clipboard_control). This setup needs no SSH forwarding, remote `xclip`, or extra clipboard plugin.

Test after deployment:

1. Run `:checkhealth yazi` and `:checkhealth vim.provider`.
2. Open a C/C++ file and run `:LspInfo` and `:ConformInfo` to verify Clangd and ClangFormat.
3. Yank a line with `yy`, then paste into a local application. It should match the line.
4. Delete a different line with `dd`; the local clipboard should still contain the yanked line.
5. Copy text in a local application, enter Insert mode in SSH Neovim, and use the terminal paste shortcut.
6. Open Yazi with Space-e and select a file with Enter.

If clipboard copying fails, test OSC 52 directly in the SSH shell:

```bash
printf '\033]52;c;%s\007' "$(printf 'SSH clipboard test' | base64 | tr -d '\n')"
```

Paste into a local application. If `SSH clipboard test` does not appear, clipboard writes are being blocked by the terminal or a terminal wrapper; changing Neovim alone cannot fix that. If the shell test works, check `:lua =vim.g.clipboard.name` in SSH Neovim; it should report `OSC 52 (copy only)`.

## Local checks

```bash
nvim --headless -u NONE -l tests/remote_clipboard.lua
nvim --headless -u NONE -l tests/runner.lua
```

The clipboard regression test checks provider registration, ordinary/explicit/named/black-hole yanks, delete isolation, cached paste, and linewise/blockwise register types. It intercepts the OSC 52 writer; the actual SSH-to-local clipboard still needs the interactive test above. The runner test uses GCC/G++ to check quoted paths, the working directory, and failed-compilation behavior.
