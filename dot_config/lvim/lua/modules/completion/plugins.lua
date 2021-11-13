local completion = {}
local conf = require "modules.completion.config"

completion["benfowler/telescope-luasnip.nvim"] = {
  module = "telescope._extensions.luasnip", -- if you wish to lazy-load
  config = conf.telescope_luasnip,
  disable = not lvim.builtin.telescope.active,
}

completion["folke/trouble.nvim"] = {
  -- FIXME(meijieru): lazy load
  -- cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  -- module = {
  --   "trouble.providers.telescope",
  -- },
  config = conf.trouble,
  disable = false,
}

completion["tzachar/cmp-tabnine"] = {
  run = "./install.sh",
  config = conf.tabnine,
  disable = not myvim.plugins.tabnine.active,
}
completion["hrsh7th/cmp-cmdline"] = { config = conf.cmp_cmdline }

return completion
