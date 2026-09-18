local M = {}

function M.put(path)
  local result = vim.system({ "gio", "trash", path }, { text = true }):wait()
  return result.code == 0, vim.trim(result.stderr or "")
end

return M
