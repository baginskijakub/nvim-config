vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })

vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit all windows" })

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

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
