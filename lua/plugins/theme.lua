return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { on_highlights = function(highlights) highlights.SnacksImageMath = { fg = "#ffffff" } end },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
}
