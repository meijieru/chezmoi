local M = {}
local conf = require "modules.completion.config"

M["benfowler/telescope-luasnip.nvim"] = {
  lazy = true,
  config = conf.telescope_luasnip,
  enabled = myvim.plugins.telescope.active,
  dependencies = "telescope.nvim",
}

M["tzachar/cmp-tabnine"] = {
  build = "./install.sh",
  event = "InsertEnter",
  config = conf.tabnine,
  enabled = (myvim.plugins.tabnine.active and myvim.plugins.cmp.active),
  dependencies = "nvim-cmp",
}
M["ray-x/cmp-treesitter"] = {
  event = "InsertEnter",
  enabled = (myvim.plugins.cmp_treesitter.active and myvim.plugins.cmp.active),
  dependencies = "nvim-cmp",
}
M["rcarriga/cmp-dap"] = {
  ft = { "dap-repl" },
  config = conf.cmp_dap,
  enabled = (myvim.plugins.cmp.active and myvim.plugins.dap.active and myvim.plugins.cmp_dap.active),
  dependencies = "nvim-cmp",
}

M["ray-x/lsp_signature.nvim"] = {
  event = "VeryLazy",
  config = conf.lsp_signature,
  dependencies = "nvim-lspconfig",
  enabled = myvim.plugins.lsp_signature.active,
}

return M
