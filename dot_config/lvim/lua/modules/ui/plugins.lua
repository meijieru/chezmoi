local ui = {}

local conf = require "modules.ui.config"
local utils = require "core.utils"
local Log = require "core.log"

local function is_used_colorschemes(colors)
  return vim.tbl_contains(colors, myvim.colorscheme)
end
local function load_colorscheme(url)
  utils.load_pack(utils.get_plugin_dir(url), { skip_packer = true })
end
local function use_colorschemes(plugins, url, colors, extras)
  vim.validate {
    plugins = { plugins, "table" },
    url = { url, "string" },
    extras = { extras, "table", true },
  }

  local opts = { opt = true }
  if extras then
    opts = vim.tbl_extend("error", opts, extras)
  end

  plugins[url] = opts
  if is_used_colorschemes(colors) then
    for _, dep in ipairs(opts.requires or {}) do
      load_colorscheme(dep)
    end
    load_colorscheme(url)

    -- packer always call the setup
    -- if opts.setup then
    --   opts.setup()
    -- end
    if opts.config then
      Log:warn "Config not called"
    end
  end
end

use_colorschemes(ui, "meijieru/edge.nvim", { "edge_lush" }, { requires = { "rktjmp/lush.nvim" } })
use_colorschemes(ui, "sainnhe/gruvbox-material", { "gruvbox-material" })
use_colorschemes(ui, "sainnhe/edge", { "edge" })
use_colorschemes(ui, "sainnhe/everforest", { "everforest" })
use_colorschemes(ui, "shaunsingh/nord.nvim", { "nord" })

ui["romainl/vim-cool"] = {}

ui["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = conf.zen_mode,
}
ui["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  module = "twilight",
  config = conf.twilight,
}
ui["folke/noice.nvim"] = {
  event = "VimEnter",
  config = function()
    require("noice").setup()
  end,
  requires = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
  disable = not myvim.plugins.noice.active,
}
ui["rcarriga/nvim-notify"] = {
  config = conf.notify,
  disable = not myvim.plugins.notify.active,
}

ui["karb94/neoscroll.nvim"] = {
  event = "WinScrolled",
  config = conf.neoscroll,
  disable = not myvim.plugins.neoscroll.active,
}
ui["petertriho/nvim-scrollbar"] = {
  event = "BufRead",
  config = conf.scrollbar,
  disable = not myvim.plugins.scrollbar.active,
}

ui["kevinhwang91/nvim-bqf"] = {
  ft = "qf",
  config = conf.bqf,
  disable = false,
}

ui["vimpostor/vim-tpipeline"] = { disable = not myvim.plugins.tpipeline.active }
ui["mbbill/undotree"] = { cmd = { "UndotreeToggle" } }
ui["stevearc/dressing.nvim"] = {
  config = conf.dressing,
  disable = not myvim.plugins.dressing.active,
}

ui["stevearc/oil.nvim"] = {
  config = conf.oil,
  disable = not myvim.plugins.oil.active,
}

ui["stevearc/oil.nvim"] = {
  config = conf.oil,
  disable = not myvim.plugins.oil.active,
}

return ui
