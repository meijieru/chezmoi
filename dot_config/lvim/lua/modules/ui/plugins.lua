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
use_colorschemes(M, "sainnhe/gruvbox-material", { "gruvbox-material" }, {
  init = function()
    conf.sainnhe_colorscheme "gruvbox_material"
  end,
})
use_colorschemes(M, "sainnhe/edge", { "edge" }, {
  init = function()
    conf.sainnhe_colorscheme "edge"
  end,
})
use_colorschemes(M, "sainnhe/everforest", { "everforest" }, {
  init = function()
    conf.sainnhe_colorscheme "everforest"
  end,
})
use_colorschemes(M, "shaunsingh/nord.nvim", { "nord" })
use_colorschemes(M, "catppuccin/nvim", { "catppuccin" }, {
  name = "catppuccin",
  opts = {
    no_italic = not myvim.colorscheme.enable_italic,
    dim_inactive = { enabled = myvim.colorscheme.dim_inactive_windows },
    show_end_of_buffer = myvim.colorscheme.show_eob,
    color_overrides = {
      latte = {
        base = "#FAFAFA",
      },
    },
    integrations = {
      notify = myvim.plugins.notify.active,
      aerial = myvim.plugins.aerial.active,
      alpha = myvim.plugins.alpha.active,
      dashboard = false,
      gitsigns = myvim.plugins.gitsigns.active,
      indent_blankline = {
        enabled = myvim.plugins.indentlines.active,
      },
      neotest = myvim.plugins.neotest.active,
      noice = myvim.plugins.noice.active,
      ts_rainbow2 = false,
      ts_rainbow = false,
      overseer = myvim.plugins.overseer.active,
      telescope = myvim.plugins.telescope.active,
      illuminate = myvim.plugins.illuminate.active,
      which_key = true,
      mason = true,
    },
  },
})

M["romainl/vim-cool"] = { event = { "VeryLazy" } }

M["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = conf.zen_mode,
}
M["folke/twilight.nvim"] = {
  cmd = { "Twilight", "TwilightEnable" },
  opts = {
    context = 20,
  },
}
M["folke/noice.nvim"] = {
  event = "VeryLazy",
  opts = {
    popupmenu = {
      enabled = false,
    },
    lsp = {
      -- FIXME(meijieru): wrap or increase the cmdline height if necessary
      progress = { enabled = false },
      signature = { enabled = false },
      hover = { enabled = false },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
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

M["debugloop/telescope-undo.nvim"] = {
  keys = { { "<leader>fu", "<cmd>lua require('telescope').extensions.undo.undo()<cr>", desc = "Undotree" } },
  dependencies = { "nvim-telescope/telescope.nvim" },
  init = function()
    local actions = require("core.utils").require_on_exported_call "telescope-undo.actions"
    lvim.builtin.telescope.extensions.undo = {
      use_delta = true,
      side_by_side = true,
      mappings = {
        i = {
          ["<cr>"] = actions.restore,
        },
        n = {
          ["y"] = actions.yank_additions,
          ["Y"] = actions.yank_deletions,
          ["u"] = actions.restore,
        },
      },
    }
  end,
}
M["stevearc/dressing.nvim"] = {
  event = "VeryLazy",
  config = conf.dressing,
  enabled = myvim.plugins.dressing.active,
}

M["ColaMint/pokemon.nvim"] = {
  lazy = true,
  config = function()
    local number_candidates = {
      "0025",
      "0039",
      "0104",
      "0105",
      "0116",
      "0131",
      "0006.3",
      "0735.1",
      "0196.1",
      "0628.2",
    }
    local number
    math.randomseed(os.time())
    if math.random() > 0.5 then
      number = "random"
    else
      number = number_candidates[math.random(#number_candidates)]
    end
    require("pokemon").setup {
      number = number,
      size = "auto",
    }
  end,
  enabled = myvim.plugins.pokemon.active,
}

M["stevearc/oil.nvim"] = {
  -- TODO(meijieru): lazy load
  config = conf.oil,
  enabled = myvim.plugins.oil.active,
}

M["luukvbaal/statuscol.nvim"] = {
  event = "UIEnter",
  config = conf.statuscol,
  enabled = myvim.plugins.statuscol.active,
}

return M
