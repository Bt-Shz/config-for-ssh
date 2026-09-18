local groups = { "Normal", "NormalFloat", "FloatBorder", "Pmenu", "Terminal", "EndOfBuffer", "FoldColumn", "Folded", "SignColumn", "LineNr", "CursorLineNr", "NormalNC", "WhichKeyFloat" }
for _, name in ipairs(groups) do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok then
    hl.bg = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end
