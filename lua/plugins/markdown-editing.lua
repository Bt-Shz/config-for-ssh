return {
  "gaoDean/autolist.nvim",
  ft = "markdown",
  opts = { colon = { indent = false, indent_raw = false } },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("MarkdownListEditing", { clear = true }),
      pattern = "markdown",
      callback = function(event)
        vim.bo[event.buf].expandtab = true
        vim.bo[event.buf].shiftwidth = 4
        vim.bo[event.buf].softtabstop = 4
        vim.bo[event.buf].tabstop = 4
        local options = { buffer = event.buf, silent = true }
        vim.keymap.set("i", "<CR>", function()
          local ok, cmp = pcall(require, "blink.cmp")
          if ok and cmp.is_visible() and cmp.get_selected_item() then
            cmp.accept()
            return ""
          end
          return "<CR><Cmd>AutolistNewBullet<CR>"
        end, vim.tbl_extend("force", options, { expr = true, desc = "Continue Markdown list" }))
        vim.keymap.set("n", "o", "o<Cmd>AutolistNewBullet<CR>", vim.tbl_extend("force", options, { desc = "Continue Markdown list" }))
        vim.keymap.set("n", "O", "O<Cmd>AutolistNewBulletBefore<CR>", vim.tbl_extend("force", options, { desc = "Continue Markdown list above" }))
        vim.keymap.set("n", "<leader>mc", "<Cmd>AutolistToggleCheckbox<CR>", vim.tbl_extend("force", options, { desc = "Toggle Markdown checkbox" }))
      end,
    })
  end,
}
