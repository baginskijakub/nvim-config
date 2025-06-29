return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim", 
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        -- To ignore some files and folders
        file_ignore_patterns = { "node_modules", ".git", "%.next" },
      },
    })

    local keymap = vim.keymap.set

    keymap("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    keymap("n", "<leader>bb", builtin.buffers, { desc = "Search Buffers" })
    keymap("n", "<leader>lg", builtin.live_grep, { desc = "Live Grep" })
  end,
}
