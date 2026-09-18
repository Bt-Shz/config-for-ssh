local markdown_filetypes = { "markdown", "markdown.mdx" }

return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      for _, ft in ipairs(markdown_filetypes) do
        opts.linters_by_ft[ft] = {}
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      for _, ft in ipairs(markdown_filetypes) do
        local formatters = opts.formatters_by_ft[ft]
        if formatters then
          opts.formatters_by_ft[ft] = vim.tbl_filter(function(name)
            return name ~= "markdownlint-cli2"
          end, formatters)
        end
      end
    end,
  },
}
