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

require("lazy").setup({
  require("config.plugins.nvimtree"), 
  require("config.plugins.fugitive"),
  require("config.plugins.lspconfig"),

  -- { "neovim/nvim-lspconfig" },
  -- { "nvim-telescope/telescope.nvim", tag = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
}, {
  install = { colorscheme = { "default" } },
  ui = { border = "rounded" },
  -- lazy 
})
