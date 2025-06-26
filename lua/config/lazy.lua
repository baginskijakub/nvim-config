-- ~/.config/nvim/lua/config/lazy.lua

-- Set the lazy.nvim installation directory
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Ensure lazy.nvim is installed
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end

-- Add lazy.nvim to rtp
vim.opt.rtp:prepend(lazy_path)

-- Initialize lazy.nvim and define your plugins
require("lazy").setup({
  -- === Plugin List ===

  -- 1. nvim-tree.lua (Minimal Setup for now)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  -- Example of where other plugins would go later:
  -- { "tpope/vim-fugitive" },
  -- { "neovim/nvim-lspconfig" },
  -- { "nvim-telescope/telescope.nvim", tag = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

}, {
  -- Lazy.nvim options
  install = { colorscheme = { "default" } }, -- Keep default colorscheme for installation feedback
  ui = { border = "rounded" }, -- Prettier UI for lazy.nvim messages
})