local tools = {}
local conf = require "modules.tools.config"

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
  },
  ft = { "fugitive" },
  fn = { "FugitiveGitDir" },
  disable = false,
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
  -- FIXME(meijieru): lazy_load
  -- cmd = { "SnipRun", "'<,'>SnipRun" },
  config = conf.sniprun,
  disable = false,
}

tools["norcalli/nvim-colorizer.lua"] = {
  event = "BufRead",
  config = conf.colorizer,
  disable = false,
}

tools["wakatime/vim-wakatime"] = {}
tools["nathom/filetype.nvim"] = {}

tools["ludovicchabant/vim-gutentags"] = { disable = true }
tools["skywind3000/gutentags_plus"] = { disable = true }

return tools
