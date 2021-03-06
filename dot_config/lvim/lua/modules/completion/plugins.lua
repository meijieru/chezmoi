local completion = {}
local conf = require "modules.completion.config"

completion["benfowler/telescope-luasnip.nvim"] = {
  module = "telescope._extensions.luasnip", -- if you wish to lazy-load
  config = conf.telescope_luasnip,
  disable = not myvim.plugins.telescope.active,
  after = "telescope.nvim",
}

completion["folke/trouble.nvim"] = {
  -- FIXME(meijieru): lazy load
  -- cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  -- module = {
  --   "trouble.providers.telescope",
  -- },
  config = conf.trouble,
  disable = not myvim.plugins.trouble.active,
}

completion["tzachar/cmp-tabnine"] = {
  run = "./install.sh",
  event = "InsertEnter",
  config = conf.tabnine,
  disable = not (myvim.plugins.tabnine.active and myvim.plugins.cmp.active),
  after = "nvim-cmp",
}
completion["hrsh7th/cmp-cmdline"] = {
  event = "CmdlineEnter",
  config = conf.cmp_cmdline,
  after = "nvim-cmp",
  disable = not myvim.plugins.cmp.active,
}
completion["ray-x/cmp-treesitter"] = {
  ft = { "teal" },
  disable = not (myvim.plugins.cmp_treesitter.active and myvim.plugins.cmp.active),
}

completion["ray-x/lsp_signature.nvim"] = {
  event = "BufRead",
  config = conf.lsp_signature,
  after = "nvim-lspconfig",
}

return completion
