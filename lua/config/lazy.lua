local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" 

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
  -- === Plugin List ==k

  require("config.plugins.nvimtree"), 

  -- { "tpope/vim-fugitive" },
  -- { "neovim/nvim-lspconfig" },
  -- { "nvim-telescope/telescope.nvim", tag = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
}, {
  -- Lazy.nvim options
  install = { colorscheme = { "default" } },
  ui = { border = "rounded" },
})
