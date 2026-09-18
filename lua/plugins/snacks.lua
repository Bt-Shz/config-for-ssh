local uv = vim.uv

local function trash_selected_files(picker)
  local items = picker:selected({ fallback = true })
  if #items == 0 then
    return
  end
  local paths = {}
  for _, item in ipairs(items) do
    local path = Snacks.picker.util.path(item)
    local stat = path and uv.fs_stat(path)
    if not stat or stat.type == "directory" then
      return Snacks.notify.warn("Only existing files can be trashed", { title = "Snacks Picker" })
    end
    paths[#paths + 1] = path
  end
  if vim.fn.confirm("Trash selected files?", "&Yes\n&No", 2) ~= 1 then
    return
  end
  for _, path in ipairs(paths) do
    local ok, err = require("config.trash").put(path)
    if not ok then
      return Snacks.notify.error("Failed to trash " .. path .. ": " .. err, { title = "Snacks Picker" })
    end
    Snacks.bufdelete({ file = path, force = true })
  end
  picker:refresh()
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = { trash_selected_files = trash_selected_files },
      sources = {
        files = { hidden = true, win = { input = { keys = { ["<C-d>"] = { "trash_selected_files", mode = { "n", "i" } } } } } },
        smart = { win = { input = { keys = { ["<C-d>"] = { "trash_selected_files", mode = { "n", "i" } } } } } },
      },
    },
    scroll = { enabled = false },
    explorer = { enabled = false, replace_netrw = false },
  },
  keys = { { "<leader>e", false }, { "<leader>E", false }, { "<leader>fe", false }, { "<leader>fE", false } },
}
