local completion = {}
local conf = require "modules.completion.config"

completion["benfowler/telescope-luasnip.nvim"] = {
  config = conf.telescope_luasnip,
  enabled = myvim.plugins.telescope.active,
  after = "telescope.nvim",
}

completion["tzachar/cmp-tabnine"] = {
  build = "./install.sh",
  event = "InsertEnter",
  config = conf.tabnine,
  enabled = (myvim.plugins.tabnine.active and myvim.plugins.cmp.active),
  after = "nvim-cmp",
}
completion["hrsh7th/cmp-cmdline"] = {
  enabled = myvim.plugins.cmp.active,
}
completion["ray-x/cmp-treesitter"] = {
  enabled = (myvim.plugins.cmp_treesitter.active and myvim.plugins.cmp.active),
}
completion["rcarriga/cmp-dap"] = {
  config = conf.cmp_dap,
  enabled = (myvim.plugins.cmp.active and myvim.plugins.dap.active and myvim.plugins.cmp_dap.active),
  after = "nvim-cmp",
}

completion["ray-x/lsp_signature.nvim"] = {
  event = "BufRead",
  config = conf.lsp_signature,
  after = "nvim-lspconfig",
}

return completion
