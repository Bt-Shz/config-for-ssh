local M = {}

function M.setup()
  if not (vim.env.TMUX or vim.env.SSH_TTY or vim.env.SSH_CONNECTION) then
    return
  end

  local osc52 = require("vim.ui.clipboard.osc52")
  local cached = { ["+"] = { { "" }, "v" }, ["*"] = { { "" }, "v" } }
  local emit = osc52.copy("+")
  local function copy(register)
    return function(lines, regtype)
      cached[register] = { vim.deepcopy(lines), regtype }
      -- Both registers target the local clipboard, rather than X11 primary selection.
      emit(lines)
    end
  end
  local function paste(register)
    return function()
      -- Clipboard queries are unsupported by many terminals and can block for seconds.
      return vim.deepcopy(cached[register])
    end
  end

  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
    cache_enabled = 0,
  }
  -- Keep deletes and changes in Neovim; export only yanks to the local clipboard.
  vim.opt.clipboard = ""
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("remote_clipboard_yank", { clear = true }),
    callback = function()
      local event = vim.v.event
      if event.operator == "y" and event.regname ~= "_" and event.regname ~= "+" and event.regname ~= "*" then
        vim.g.clipboard.copy["+"](event.regcontents, event.regtype)
      end
    end,
  })
end

return M
