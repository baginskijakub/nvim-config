return {
  "stevearc/oil.nvim",
  opts = {},
  keys = {
    { "<leader>pv", "<CMD>Oil<CR>",            desc = "Open parent directory" },
    { "-",          "<CMD>Oil --floating<CR>", desc = "Open parent directory in floating window" },
  },
  config = function()
    require("oil").setup({
      columns = {
        "icon",
        "diagnostics",
        -- Add "diagnostics" if you want to see LSP diagnostics for files
      },
      -- This option controls whether the ".." entry is displayed.
      -- By default, it's often implicit or handled by keybindings.
      -- Setting it to true will explicitly show it as an entry.
      show_hidden = true, -- Usually required to show '..' and '.' if they are considered "hidden" by your OS/config
      preview_on_mouseover = true,
      lsp_file_methods = {
        -- For example, to enable LSP diagnostics in Oil
        -- completion.set_context(path, context)
        -- definition.goto_definition(path, line, col)
        -- etc.
      },
      view_options = {
        -- This is the key setting to display the parent directory explicitly.
        -- It adds a special entry for the parent directory at the top.
        -- When this is true, you will see a '..' entry that you can navigate into.
        show_hidden = true, -- Also ensures that '..' is treated as visible
        is_preview_pane = false,
        -- You might also want to explicitly set sort options if not satisfied with default
        -- sort = { "type", "name" },
      },
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if #vim.api.nvim_list_bufs() == 1 and vim.fn.argv(0) == "" then
          vim.cmd("Oil")
        end
      end,
    })
  end,
}
