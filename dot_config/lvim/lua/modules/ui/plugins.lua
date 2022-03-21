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

ui["lukas-reineke/indent-blankline.nvim"] = {
  event = "BufRead",
  config = conf.indent_blankline,
  disable = false,
}

ui["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = conf.zen_mode,
}
ui["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  module = "twilight",
  config = conf.twilight,
}

ui["karb94/neoscroll.nvim"] = {
  event = "WinScrolled",
  config = conf.neoscroll,
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

ui["sidebar-nvim/sidebar.nvim"] = {
  -- branch = "dev",
  conf = conf.sidebar,
  disable = not myvim.plugins.sidebar.active,
}

return ui
