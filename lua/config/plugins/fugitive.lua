return {
  "tpope/vim-fugitive",

  config = function()

    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "open git status window" })

    vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "open git diff" })

    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "blame" })

    vim.keymap.set("n", "<leader>gph", ":Git push<CR>", { desc = "git push" })

    vim.keymap.set("n", "<leader>gpl", ":Git pull<CR>", { desc = "git pulll" })
  end,
}
