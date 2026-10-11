return {
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { c = { "clang_format" }, cpp = { "clang_format" } } },
  },
  { "mason-org/mason.nvim", opts = { ensure_installed = { "clang-format" } } },
}
