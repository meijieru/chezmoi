local M = {}
local conf = require "modules.lang.config"

M["iamcco/markdown-preview.nvim"] = {
  build = "cd app && npm install",
  ft = "markdown",
  init = conf.markdown_preview,
  enabled = myvim.plugins.markdown_preview.active,
}

M["jbyuki/one-small-step-for-vimkind"] = { lazy = true }
M["lervag/vimtex"] = { ft = { "tex" }, enabled = false }
M["MTDL9/vim-log-highlighting"] = { ft = { "log" } }

return M
