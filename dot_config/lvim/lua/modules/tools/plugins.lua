local M = {}
local conf = require "modules.tools.config"

M["meijieru/imtoggle.nvim"] = {
  event = "InsertEnter",
  config = conf.imtoggle,
  enabled = myvim.plugins.imtoggle.active,
}

M["tpope/vim-fugitive"] = {
  cmd = {
    "G",
    "Git",
    "Gdiffsplit",
    "Gvdiff",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GDelete",
    "GBrowse",
    "GRemove",
    "GRename",
    "Glgrep",
    "Gedit",
    "Gtabedit",
  },
}
M["ruifm/gitlinker.nvim"] = {
  lazy = true,
  dependencies = "nvim-lua/plenary.nvim",
  config = conf.gitlinker,
  enabled = myvim.plugins.gitlinker.active,
}
M["sindrets/diffview.nvim"] = {
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  config = conf.diffview,
}

M["stevearc/overseer.nvim"] = {
  cmd = { "OverseerRun", "OverseerToggle" },
  opts = {
    strategy = { "toggleterm", open_on_start = false },
    templates = { "builtin", "myplugin.global_tasks" },
    task_list = {
      bindings = {
        ["q"] = "<cmd>close<cr>",
        ["<c-x>"] = "OpenSplit",
      },
    },
    component_aliases = {
      status_only = {
        "on_exit_set_status",
        "on_complete_notify",
      },
    },
  },
  enabled = myvim.plugins.overseer.active,
}

M["dstein64/vim-startuptime"] = {
  cmd = { "StartupTime" },
  init = function()
    vim.g.startuptime_tries = 10
    vim.g.startuptime_event_width = 40
  end,
}

M["michaelb/sniprun"] = {
  build = { "bash install.sh" },
  keys = { "<Plug>SnipRun", "<Plug>SnipRunOperator" },
  cmd = { "SnipRun" },
  config = conf.sniprun,
  enabled = myvim.plugins.sniprun.active,
}

M["NvChad/nvim-colorizer.lua"] = {
  cmd = { "ColorizerToggle" },
  config = conf.colorizer,
}

M["wakatime/vim-wakatime"] = {
  event = "VeryLazy",
  enabled = myvim.plugins.wakatime.active,
}

M["nvim-telescope/telescope-frecency.nvim"] = {
  lazy = true,
  dependencies = { "tami5/sqlite.lua", lazy = true },
  init = function()
    lvim.builtin.telescope.extensions.frecency = {
      default_workspace = "CWD",
      show_unindexed = false,
    }
  end,
  enabled = myvim.plugins.telescope_frecency.active,
}

M["alker0/chezmoi.vim"] = { enabled = false }

M["glacambre/firenvim"] = {
  lazy = true,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  enabled = false,
}

return M
