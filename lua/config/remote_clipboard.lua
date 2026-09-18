local M = {}

function M.setup()
  if not (vim.env.TMUX or vim.env.SSH_TTY or vim.env.SSH_CONNECTION) then
    return
  end

  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
    cache_enabled = 0,
  }
end

return M
