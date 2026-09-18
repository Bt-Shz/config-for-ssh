return {
  { "nvim-mini/mini.files", enabled = false },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = { open_for_directories = true },
    keys = {
      { "<leader>e", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Open Yazi (Current File)" },
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open Yazi (Working Dir)" },
    },
  },
}
