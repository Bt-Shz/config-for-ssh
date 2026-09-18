pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
local prose_group = vim.api.nvim_create_augroup("user_wrap_without_spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = prose_group,
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})
