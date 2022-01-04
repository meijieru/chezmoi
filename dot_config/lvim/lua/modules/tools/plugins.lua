local tools = {}
local conf = require "modules.tools.config"

tools["meijieru/imtoggle.nvim"] = {
  event = "InsertEnter",
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
}

tools["sindrets/diffview.nvim"] = {
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  config = conf.diffview,
}

tools["TimUntersberger/neogit"] = {
  cmd = { "Neogit" },
  module = { "neogit" },
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
      disable = not myvim.plugins.telescope.active,
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
  cmd = { "SnipRun" },
  config = conf.sniprun,
  disable = false,
}

tools["norcalli/nvim-colorizer.lua"] = {
  cmd = { "ColorizerToggle" },
  config = conf.colorizer,
  disable = false,
}

tools["wakatime/vim-wakatime"] = {
  -- FIXME(meijieru): wait for https://github.com/wbthomason/packer.nvim/issues/8
  event = "BufRead",
  disable = not myvim.plugins.wakatime.active,
}
tools["nathom/filetype.nvim"] = {
  config = conf.filtype,
}

tools["nvim-telescope/telescope-frecency.nvim"] = {
  config = conf.telescope_frecency,
  requires = { "tami5/sqlite.lua" },
  disable = not myvim.plugins.telescope_frecency.active,
}

tools["rcarriga/vim-ultest"] = {
  requires = { "vim-test/vim-test", setup = conf.vim_test },
  cmd = { "Ultest", "UltestNearest" },
  run = function()
    vim.cmd [[packadd vim-ultest]]
    vim.cmd [[UpdateRemotePlugins]]
  end,
  setup = conf.vim_ultest,
  -- config = function()
  --   vim.cmd [[UpdateRemotePlugins]]
  -- end,
  disable = true,
}

tools["alker0/chezmoi.vim"] = { disable = true }
tools["Pocco81/AutoSave.nvim"] = {
  event = { "BufRead" },
  disable = true,
}

tools["glacambre/firenvim"] = {
  -- FIXME(meijieru): doesn't work now
  run = function()
    vim.fn["firenvim#install"](0)
  end,
  disable = true,
}

tools["rktjmp/shipwright.nvim"] = {
  cmd = { "Shipwright" },
  disable = not myvim.plugins.shipwright.active,
}

return tools
