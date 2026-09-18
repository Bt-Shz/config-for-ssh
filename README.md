# Class Neovim configuration

C/C++-oriented LazyVim setup with render-only Markdown, OSC 52 clipboard support for SSH, and a small set of UI conveniences. It excludes TeX, Obsidian, Markdown linting/formatting/completion, language extras other than C/C++, and file-manager plugins.

## Install on the class server

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone <your-GitHub-repository-URL> ~/.config/nvim
nvim
```

Lazy.nvim installs plugins on the first launch. The server needs `git`, a recent Neovim, `gcc`, and `g++`. `<leader>cc` saves and runs C or C++ files in a split terminal.
