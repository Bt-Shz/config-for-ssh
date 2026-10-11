local function smart_run()
  local filetype = vim.bo.filetype
  local compiler = ({ c = "gcc", cpp = "g++" })[filetype]
  if not compiler then
    return vim.notify("No runner configured for " .. filetype, vim.log.levels.WARN)
  end
  if vim.fn.executable(compiler) ~= 1 then
    return vim.notify(compiler .. " is not on PATH", vim.log.levels.ERROR)
  end
  local file = vim.fn.expand("%:p")
  if file == "" or vim.bo.buftype ~= "" then
    return vim.notify("Save the source file before running it", vim.log.levels.WARN)
  end
  vim.cmd("w")
  local out = vim.fn.expand("%:p:r") .. ".out"
  local s_file = vim.fn.shellescape(file)
  local s_out = vim.fn.shellescape(out)
  local command = string.format("%s -Wall -Wextra -g %s -o %s && %s", compiler, s_file, s_out, s_out)
  vim.cmd("split")
  vim.cmd("enew")
  vim.fn.jobstart(command, { term = true, cwd = vim.fn.fnamemodify(file, ":h") })
end

vim.keymap.set("n", "<leader>cc", smart_run, { desc = "Run Code" })
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent Current Line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Unindent Current Line" })
vim.keymap.set("x", "<Tab>", ">gv", { desc = "Indent Selection" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Unindent Selection" })

pcall(vim.keymap.del, { "n", "x" }, "j")
pcall(vim.keymap.del, { "n", "x" }, "k")
for _, lhs in ipairs({ "<leader>dpp", "<leader>dph", "<leader>dps" }) do
  pcall(vim.keymap.del, "n", lhs)
end
