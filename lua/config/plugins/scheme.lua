return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        types = {},
        strings = {},
        numbers = {},
        booleans = {},
        constants = {},
        properties = {},
        operators = {},
        punctuations = {},
      },
      sidebars = { "qf", "help" },
      floats = { "Normal" },
    })

    vim.cmd.colorscheme("tokyonight")
  end,
}
