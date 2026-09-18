return {
  { "snacks.nvim", opts = { indent = { enabled = false } } },
  {
    "folke/noice.nvim",
    opts = {
      routes = { { filter = { event = "msg_show", find = "%d+L, %d+B" }, opts = { skip = true } } },
    },
  },
  { "lewis6991/gitsigns.nvim", opts = { signcolumn = false } },
}
