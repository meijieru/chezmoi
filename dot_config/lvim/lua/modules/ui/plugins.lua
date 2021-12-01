local ui = {}

local conf = require "modules.ui.config"
local utils = require "modules.ui.utils"

utils.use_colorschemes(
  ui,
  "https://gitea.meijieru.com/meijieru/edge_lush",
  { "edge_lush" },
  { requires = { "rktjmp/lush.nvim" } }
)
utils.use_colorschemes(ui, "sainnhe/gruvbox-material", { "gruvbox-material" })
utils.use_colorschemes(ui, "sainnhe/edge", { "edge" })
utils.use_colorschemes(ui, "sainnhe/everforest", { "everforest" })
utils.use_colorschemes(ui, "LunarVim/Colorschemes", {
  "aurora",
  "codemonkey",
  "darkplus",
  "onedarker",
  "spacedark",
  "system76",
  "tomorrow",
})

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
