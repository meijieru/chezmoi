local lang = {}
local conf = require "modules.lang.config"

lang["plasticboy/vim-markdown"] = {
  ft = { "markdown" },
  disable = true,
}
lang["iamcco/markdown-preview.nvim"] = {
  run = "cd app && npm install",
  ft = "markdown",
  setup = conf.markdown_preview,
}

lang["jbyuki/one-small-step-for-vimkind"] = { ft = { "lua" } }
lang["lervag/vimtex"] = { ft = { "tex" }, disable = true }
lang["teal-language/vim-teal"] = { ft = { "teal" } }
lang["MTDL9/vim-log-highlighting"] = { ft = { "log" } }

return lang
