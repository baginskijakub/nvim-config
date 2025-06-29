vim.opt.rtp:append(vim.fn.stdpath("config") .. "/lua")

require("core.options")

require("core.keymaps")

require("config.lazy")
