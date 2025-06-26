-- ~/.config/nvim/lua/core/options.lua

vim.opt.compatible = false -- Absolutely essential for modern Neovim config
vim.opt.number = true      -- Line numbers
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Basic quality-of-life options (optional, but highly recommended)
vim.opt.termguicolors = true -- Enable true colors (important for themes)
vim.opt.tabstop = 2        -- 1 tab = 2 spaces
vim.opt.shiftwidth = 2     -- Shift operations = 2 spaces
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.textwidth = 80     -- Wrap lines at 80 characters
vim.opt.wrap = true        -- Enable line wrapping
vim.opt.mouse = "a"        -- Enable mouse in all modes
vim.opt.updatetime = 300   -- Faster completion/plugin update cycles
vim.opt.timeoutlen = 500   -- Time to wait for a mapped sequence to complete
vim.opt.ignorecase = true  -- Ignore case in search patterns
vim.opt.smartcase = true   -- Override ignorecase if pattern contains uppercase
vim.opt.undofile = true    -- Persist undo history across sessions
vim.opt.cmdheight = 1      -- Command line height
vim.opt.hidden = true      -- Allow buffer switching without saving
vim.opt.fileencoding = "utf-8" -- Default file encoding