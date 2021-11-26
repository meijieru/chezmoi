local ui = {}
local conf = require "modules.ui.config"

ui["https://gitea.meijieru.com/meijieru/edge_lush"] = {
  requires = { "rktjmp/lush.nvim" },
}

ui["sainnhe/gruvbox-material"] = { opt = false }
-- ui["sainnhe/edge"] = { opt = false }
ui["sainnhe/everforest"] = { opt = false }
ui["LunarVim/Colorschemes"] = {}

ui["lukas-reineke/indent-blankline.nvim"] = {
  event = "BufRead",
  config = conf.indent_blankline,
  disable = false,
}

ui["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  after = { "twilight.nvim" },
  config = conf.zen_mode,
}
ui["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  config = conf.twilight,
}

ui["karb94/neoscroll.nvim"] = {
  event = "WinScrolled",
  config = conf.neoscroll,
}

ui["kevinhwang91/nvim-bqf"] = {
  ft = "qf",
  config = conf.bqf,
  disable = false,
}

ui["vimpostor/vim-tpipeline"] = {}
ui["mbbill/undotree"] = { cmd = { "UndotreeToggle" } }

return ui
