return {
  "mikavilpas/yazi.nvim",
  version = "*",
  lazy = false,
  dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    open_for_directories = true,
    clipboard_register = "+",
    integrations = {
      grep_in_directory = "snacks.picker",
      grep_in_selected_files = "snacks.picker",
    },
  },
  keys = {
    { "<leader>e", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Yazi (Current File)" },
    { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Yazi (Working Dir)" },
    { "<leader>fe", "<cmd>Yazi<cr>", desc = "Yazi (Current File)" },
    { "<leader>fE", "<cmd>Yazi cwd<cr>", desc = "Yazi (Working Dir)" },
    { "<leader>fy", "<cmd>Yazi toggle<cr>", desc = "Resume Yazi" },
  },
}
