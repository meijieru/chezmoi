local completion = {}
local conf = require "modules.completion.config"

completion["benfowler/telescope-luasnip.nvim"] = {
  module = "telescope._extensions.luasnip", -- if you wish to lazy-load
  config = conf.telescope_luasnip,
  disable = not lvim.builtin.telescope.active,
}

completion["folke/trouble.nvim"] = {
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  module = {
    "trouble.providers.telescope",
  },
  config = conf.trouble,
  disable = false,
}

return completion
