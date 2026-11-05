vim.loader.enable()

_G.Raquino = require("raquino.utils")

require("raquino.config.options")
require("raquino.config.keymaps")
require("raquino.config.autocmds")
require("raquino.config.commands")
require("raquino.config.workarounds")

require("raquino.plugins")
