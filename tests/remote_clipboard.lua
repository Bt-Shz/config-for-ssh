vim.opt.rtp:prepend(vim.fn.getcwd())

local sent = {}
local osc52 = require("vim.ui.clipboard.osc52")
osc52.copy = function(register)
  return function(lines)
    sent[#sent + 1] = { register, vim.deepcopy(lines) }
  end
end
osc52.paste = function()
  error("Remote paste must not query the terminal")
end

vim.env.TMUX = nil
vim.env.SSH_TTY = nil
vim.env.SSH_CONNECTION = nil
vim.g.clipboard = nil
local clipboard = require("config.remote_clipboard")
clipboard.setup()
assert(vim.g.clipboard == nil, "Local clipboard provider must stay unchanged")

vim.env.SSH_CONNECTION = "test"
clipboard.setup()
clipboard.setup()
assert(vim.o.clipboard == "", "Deletes must use Neovim registers")
assert(vim.fn.has("clipboard") == 1, "Custom clipboard provider must initialize")

vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first line", "second line", "third line" })
vim.cmd.normal({ "ggyy", bang = true })
assert(#sent == 1, "Ordinary yank must export once, including after repeated setup")
assert(vim.deep_equal(sent[1], { "+", { "first line" } }))
assert(vim.fn.getreg("+") == "first line\n")
assert(vim.fn.getregtype("+") == "V", "Linewise register type must survive")

vim.cmd.normal({ "dd", bang = true })
assert(#sent == 1, "Delete must not replace the local clipboard")
assert(vim.fn.getreg("+") == "first line\n", "Cached yank must survive a delete")
vim.cmd.normal({ '"+p', bang = true })
assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "second line", "first line", "third line" }))

vim.cmd.normal({ 'gg"+yiw', bang = true })
assert(#sent == 2, "Explicit + yank must export only once")
assert(vim.fn.getreg("+") == "second")
assert(vim.fn.getregtype("+") == "v")

vim.cmd.normal({ 'gg"*yy', bang = true })
assert(#sent == 3, "Explicit * yank must export only once")
assert(sent[3][1] == "+", "Both clipboard registers must target local Ctrl+V clipboard")
assert(vim.fn.getregtype("*") == "V")

vim.cmd.normal({ 'gg"_yy', bang = true })
assert(#sent == 3, "Black-hole yank must not export")
vim.cmd.normal({ 'gg"ayy', bang = true })
assert(#sent == 4, "Named-register yank must export")

local blocktype = string.char(22) .. "3"
vim.fn.setreg("+", { "abc", "def" }, blocktype)
assert(vim.fn.getregtype("+") == blocktype, "Blockwise width must survive")
assert(vim.deep_equal(vim.fn.getreg("+", 1, true), { "abc", "def" }))

print("remote_clipboard: passed")
