local function is_lazy_update_component(component, lazy_updates)
  return type(component) == "table" and component[1] == lazy_updates
end

local function is_recording_component(component)
  return type(component) == "table" and type(component[1]) == "function" and component.cond and not component.color
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_y = {}
      opts.sections.lualine_z = {}
      local lazy_updates = require("lazy.status").updates
      opts.sections.lualine_x = vim.tbl_filter(function(component)
        return not is_lazy_update_component(component, lazy_updates)
      end, opts.sections.lualine_x)
      opts.sections.lualine_c = vim.tbl_filter(function(component)
        return not is_recording_component(component)
      end, opts.sections.lualine_c)
    end,
  },
}
