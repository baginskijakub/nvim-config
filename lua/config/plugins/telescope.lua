return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        file_ignore_patterns = { "node_modules", ".git", "%.next" },
        -- Use fzf_native as the sorter
        sorting_strategy = "ascending",
        layout_config = {
          height = 0.95,
          width = 0.95,
          prompt_position = "top",
          preview_cutoff = 120,
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
    })

    local keymap = vim.keymap.set

    keymap("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    keymap("n", "<leader>bb", builtin.buffers, { desc = "Search Buffers" })
    keymap("n", "<leader>lg", builtin.live_grep, { desc = "Live Grep" })
  end,
}
