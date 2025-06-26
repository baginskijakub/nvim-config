-- ~/.config/nvim/init.lua

-- Add your Lua files to the runtimepath
-- This tells Neovim where to find your custom Lua modules (e.g., lua/core/options.lua)
vim.opt.rtp:append(vim.fn.stdpath("config") .. "/lua")

-- Load core Neovim options
require("core.options")

-- Load core Neovim keymaps
require("core.keymaps")

-- Load and setup lazy.nvim (which will then load all other plugins)
-- This file will contain your plugin definitions, including nvim-tree
require("config.lazy")