return {
  "nvim-tree/nvim-tree.lua",

  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("nvim-tree").setup({
      filters = {
        dotfiles = false,
        exclude = {},
      },
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if #vim.api.nvim_list_bufs() == 1 and vim.fn.argv(0) == "" then
          vim.cmd("NvimTreeOpen")
        end
      end
    })
  end,
}
