local debugger_tools = {
  "codelldb",
  "debugpy",
  "delve",
  "haskell-debug-adapter",
  "java-debug-adapter",
  "js-debug-adapter",
  "kotlin-debug-adapter",
  "netcoredbg",
  "php-debug-adapter",
}

local blocked_plugins = {
  "jay-babu/mason-nvim-dap.nvim",
  "jbyuki/one-small-step-for-vimkind",
  "leoluz/nvim-dap-go",
  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",
  "rcarriga/nvim-dap-ui",
  "suketa/nvim-dap-ruby",
  "theHamsta/nvim-dap-virtual-text",
}

local specs = {
  { import = "lazyvim.plugins.extras.dap.core", enabled = false },
  { import = "lazyvim.plugins.extras.dap.nlua", enabled = false },
  { "folke/snacks.nvim", keys = { { "<leader>dps", false } } },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local blocked = {}
      for _, tool in ipairs(debugger_tools) do
        blocked[tool] = true
      end
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not blocked[tool]
      end, opts.ensure_installed or {})
    end,
  },
}

for _, plugin in ipairs(blocked_plugins) do
  specs[#specs + 1] = { plugin, enabled = false }
end

return specs
