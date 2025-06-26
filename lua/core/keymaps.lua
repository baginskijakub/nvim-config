-- ~/.config/nvim/lua/core/keymaps.lua

vim.g.mapleader = " " -- Set your leader key (spacebar is common)

-- Your existing keymap
vim.keymap.set("n", "<leader>u",
  "ggO'use client'<Esc>o<Esc>",
  { noremap = true, silent = true }
)

-- Example: Quick save keymap
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
-- Example: Quick quit keymap
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit all windows" })