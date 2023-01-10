local ui = {}

local conf = require "modules.ui.config"

local function is_used_colorschemes(colors)
  return vim.tbl_contains(colors, myvim.colorscheme.name)
end
local function use_colorschemes(plugins, url, colors, extras)
  vim.validate {
    plugins = { plugins, "table" },
    url = { url, "string" },
    extras = { extras, "table", true },
  }

  local is_used = is_used_colorschemes(colors)
  local priority = nil
  if is_used then
    priority = 1000
  end
  local opts = { lazy = not is_used, priority = priority }
  if extras then
    opts = vim.tbl_extend("error", opts, extras)
  end

  plugins[url] = opts
end

use_colorschemes(ui, "meijieru/edge.nvim", { "edge_lush" }, { dependencies = { "rktjmp/lush.nvim" } })
use_colorschemes(ui, "sainnhe/gruvbox-material", { "gruvbox-material" })
use_colorschemes(ui, "sainnhe/edge", { "edge" })
use_colorschemes(ui, "sainnhe/everforest", { "everforest" })
use_colorschemes(ui, "shaunsingh/nord.nvim", { "nord" })
use_colorschemes(ui, "catppuccin/nvim", { "catppuccin" }, { name = "catppuccin" })

ui["romainl/vim-cool"] = {}

ui["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = conf.zen_mode,
}
ui["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  config = conf.twilight,
}
ui["folke/noice.nvim"] = {
  event = "VimEnter",
  config = function()
    require("noice").setup()
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
  enabled = myvim.plugins.noice.active,
}
ui["rcarriga/nvim-notify"] = {
  config = conf.notify,
  enabled = myvim.plugins.notify.active,
}

ui["karb94/neoscroll.nvim"] = {
  event = "WinScrolled",
  config = conf.neoscroll,
  enabled = myvim.plugins.neoscroll.active,
}
ui["petertriho/nvim-scrollbar"] = {
  event = "BufRead",
  config = conf.scrollbar,
  enabled = myvim.plugins.scrollbar.active,
}

ui["kevinhwang91/nvim-bqf"] = {
  ft = "qf",
  config = conf.bqf,
  enabled = true,
}

ui["vimpostor/vim-tpipeline"] = { enabled = myvim.plugins.tpipeline.active }
ui["mbbill/undotree"] = { cmd = { "UndotreeToggle" } }
ui["stevearc/dressing.nvim"] = {
  config = conf.dressing,
  enabled = myvim.plugins.dressing.active,
}

ui["stevearc/oil.nvim"] = {
  config = conf.oil,
  enabled = myvim.plugins.oil.active,
}

ui["luukvbaal/statuscol.nvim"] = {
  config = conf.statuscol,
  enabled = myvim.plugins.statuscol.active,
}

return ui
