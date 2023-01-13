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

M["TimUntersberger/neogit"] = {
  cmd = { "Neogit" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = conf.neogit,
  enabled = false,
}

M["GustavoKatel/telescope-asynctasks.nvim"] = {
  lazy = true,
  dependencies = {
    "skywind3000/asynctasks.vim",
    "nvim-telescope/telescope-frecency.nvim",
  },
  enabled = myvim.plugins.telescope.active and myvim.plugins.asynctasks.active,
}
M["skywind3000/asynctasks.vim"] = {
  cmd = { "AsyncTask", "AsyncTaskEdit", "AsyncTaskList" },
  dependencies = {
    { "skywind3000/asyncrun.vim", cmd = { "AsyncRun" }, config = conf.asyncrun },
  },
  init = conf.asynctasks,
  enabled = myvim.plugins.asynctasks.active,
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
  },
  enabled = myvim.plugins.overseer.active,
}

M["dstein64/vim-startuptime"] = {
  cmd = { "StartupTime" },
  init = conf.startuptime,
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

M["rktjmp/shipwright.nvim"] = {
  cmd = { "Shipwright" },
  enabled = myvim.plugins.shipwright.active,
}

return M
