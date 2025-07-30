vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })

vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit all windows" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>u",
  "ggO'use client'<Esc>o<Esc>",
  {
    noremap = true,
    silent = true,
    desc = "Add 'use client' directive at the top of the file"
  })

vim.keymap.set("n", "<leader>c", "gg0vGy",
  {
    noremap = true,
    silent = true,
    desc = "Copy everything in the file"
  })

vim.keymap.set("n", "<leader>n", ":NvimTreeFocus<CR>", { noremap = true, silent = true, desc = "Focus dirs" })
vim.keymap.set("n", "<leader>m", "<C-w>l", { noremap = true, silent = true, desc = "Focus file" })

local function remove_js_line_comments()
  vim.cmd [[s/\/\/.*\|\/\*\_.\{-}\*\///g]]
end

local function remove_js_all_comments()
  vim.cmd [[%s/\/\/.*\|\/\*\_.\{-}\*\///g]]
end

vim.keymap.set("n", "<leader>rl", remove_js_line_comments, { desc = "Remove JS/TS comment from current line" })
vim.keymap.set("n", "<leader>ra", remove_js_all_comments, { desc = "Remove all JS/TS comments from file" })

vim.keymap.set("n", "P", "ggVGp", { desc = "Replace entire file with pasted content" })
