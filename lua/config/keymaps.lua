local function smart_run()
  vim.cmd("w")
  local filetype = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  local out = vim.fn.expand("%:p:r") .. ".out"
  local s_file = vim.fn.shellescape(file)
  local s_out = vim.fn.shellescape(out)
  local commands = {
    c = string.format("gcc %s -o %s && %s", s_file, s_out, s_out),
    cpp = string.format("g++ %s -o %s && %s", s_file, s_out, s_out),
    python = "python3 " .. s_file,
    javascript = "node " .. s_file,
    typescript = "ts-node " .. s_file,
    lua = "lua " .. s_file,
    sh = "bash " .. s_file,
    go = "go run " .. s_file,
    rust = "cargo run",
  }
  if commands[filetype] then
    vim.cmd("split | term " .. commands[filetype])
  else
    vim.notify("No runner configured for " .. filetype, vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>cc", smart_run, { desc = "Run Code" })
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent Current Line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Unindent Current Line" })
vim.keymap.set("x", "<Tab>", ">gv", { desc = "Indent Selection" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Unindent Selection" })

vim.keymap.set("n", "<leader>df", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    return vim.notify("No file to delete", vim.log.levels.WARN)
  end
  local ok, err = require("config.trash").put(file)
  if not ok then
    return vim.notify("Failed to trash " .. file .. (err == "" and "" or ": " .. err), vim.log.levels.ERROR)
  end
  vim.cmd("bdelete!")
  vim.notify("Moved to trash: " .. file)
end, { desc = "Trash Current File" })

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")
for _, lhs in ipairs({ "<leader>dpp", "<leader>dph", "<leader>dps" }) do
  pcall(vim.keymap.del, "n", lhs)
end
