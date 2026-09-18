# Class Neovim configuration

Coding-oriented copy of the personal LazyVim setup. It keeps language support, formatting, terminal code runner, Yazi, OSC 52 clipboard support for SSH, and ordinary Markdown editing. It deliberately excludes the Obsidian vault, tags, wiki links, vault completion, Markdown-Oxide, and image-paste logic.

## Install on the class server

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone <your-GitHub-repository-URL> ~/.config/nvim
nvim
```

Lazy.nvim installs plugins on the first launch. The server needs `git`, a recent Neovim, and the language tools you use. `<leader>cc` saves and runs C, C++, Python, JavaScript, TypeScript, Lua, shell, Go, or Rust files in a split terminal.
