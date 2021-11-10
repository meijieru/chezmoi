local lang = {}
local conf = require "modules.lang.config"

lang["plasticboy/vim-markdown"] = {
  ft = { "markdown" },
  disable = true,
}
lang["lervag/vimtex"] = { ft = { "tex" }, disable = true }

return lang
