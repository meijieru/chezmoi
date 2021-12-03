local tools = {}
local conf = require "modules.tools.config"

tools["meijieru/imtoggle.nvim"] = {
  config = conf.imtoggle,
  disable = not myvim.plugins.imtoggle.active,
}

tools["tpope/vim-fugitive"] = {
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
  ft = { "fugitive" },
  fn = { "FugitiveGitDir" },
  disable = false,
  -- TODO(meijieru): close info buf when diff
}

tools["TimUntersberger/neogit"] = {
  requires = { "nvim-lua/plenary.nvim" },
  config = conf.neogit,
  disable = true,
}

tools["skywind3000/asynctasks.vim"] = {
  cmd = { "AsyncTask", "AsyncTaskEdit", "AsyncTaskList" },
  fn = { "asynctasks#source" },
  after = { "asyncrun.vim" },
  requires = {
    { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } },
    {
      "GustavoKatel/telescope-asynctasks.nvim",

      module = "telescope._extensions.asynctasks", -- if you wish to lazy-load
      disable = not lvim.builtin.telescope.active,
    },
  },
  setup = conf.asynctasks,
}

tools["dstein64/vim-startuptime"] = {
  cmd = { "StartupTime" },
  setup = conf.startuptime,
}

tools["michaelb/sniprun"] = {
  run = { "bash install.sh" },
  keys = { "<Plug>SnipRun", "<Plug>SnipRunOperator" },
  cmd = { "SnipRun", "'<,'>SnipRun" },
  config = conf.sniprun,
  disable = false,
}

tools["norcalli/nvim-colorizer.lua"] = {
  event = "BufRead",
  config = conf.colorizer,
  disable = true,
}

tools["wakatime/vim-wakatime"] = {}
tools["nathom/filetype.nvim"] = {
  config = conf.filtype,
}

tools["ludovicchabant/vim-gutentags"] = { disable = true }
tools["skywind3000/gutentags_plus"] = { disable = true }

tools["nvim-telescope/telescope-frecency.nvim"] = {
  config = conf.telescope_frecency,
  requires = { "tami5/sqlite.lua" },
  disable = false,
}

tools["glacambre/firenvim"] = {
  -- FIXME(meijieru): doesn't work now
  run = function()
    vim.fn["firenvim#install"](0)
  end,
  disable = true,
}

return tools
