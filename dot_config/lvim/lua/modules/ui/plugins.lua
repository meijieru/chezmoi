local M = {}

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

use_colorschemes(M, "meijieru/edge.nvim", { "edge_lush" }, { dependencies = { "rktjmp/lush.nvim" } })
use_colorschemes(M, "sainnhe/gruvbox-material", { "gruvbox-material" })
use_colorschemes(M, "sainnhe/edge", { "edge" })
use_colorschemes(M, "sainnhe/everforest", { "everforest" })
use_colorschemes(M, "shaunsingh/nord.nvim", { "nord" })
use_colorschemes(M, "catppuccin/nvim", { "catppuccin" }, { name = "catppuccin" })

M["romainl/vim-cool"] = { event = { "VeryLazy" } }

M["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = conf.zen_mode,
}
M["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  config = conf.twilight,
}
M["folke/noice.nvim"] = {
  event = "VeryLazy",
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
M["rcarriga/nvim-notify"] = {
  event = "VeryLazy",
  config = conf.notify,
  enabled = myvim.plugins.notify.active,
}

M["karb94/neoscroll.nvim"] = {
  event = "WinScrolled",
  config = conf.neoscroll,
  enabled = myvim.plugins.neoscroll.active,
}
M["petertriho/nvim-scrollbar"] = {
  event = "VeryLazy",
  config = conf.scrollbar,
  enabled = myvim.plugins.scrollbar.active,
}

M["kevinhwang91/nvim-bqf"] = {
  ft = "qf",
  config = conf.bqf,
  enabled = true,
}

M["vimpostor/vim-tpipeline"] = { enabled = myvim.plugins.tpipeline.active }
M["mbbill/undotree"] = { cmd = { "UndotreeToggle" } }
M["stevearc/dressing.nvim"] = {
  event = "VeryLazy",
  config = conf.dressing,
  enabled = myvim.plugins.dressing.active,
}

M["stevearc/oil.nvim"] = {
  lazy = true,
  config = conf.oil,
  enabled = myvim.plugins.oil.active,
}

M["luukvbaal/statuscol.nvim"] = {
  config = conf.statuscol,
  enabled = myvim.plugins.statuscol.active and vim.fn.has "nvim-0.9",
}

return M
