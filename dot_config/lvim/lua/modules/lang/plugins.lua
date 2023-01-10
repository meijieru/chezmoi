local lang = {}
local conf = require "modules.lang.config"

lang["plasticboy/vim-markdown"] = {
  ft = { "markdown" },
  enabled = false,
}
lang["iamcco/markdown-preview.nvim"] = {
  build = "cd app && npm install",
  ft = "markdown",
  init = conf.markdown_preview,
  enabled = myvim.plugins.markdown_preview.active,
}

lang["jbyuki/one-small-step-for-vimkind"] = {}
lang["lervag/vimtex"] = { ft = { "tex" }, enabled = false }
lang["MTDL9/vim-log-highlighting"] = { ft = { "log" } }
lang["simrat39/rust-tools.nvim"] = {
  ft = { "rust" },
  config = conf.rust_tools,
  enabled = myvim.plugins.rust_tools.active,
}

return lang
