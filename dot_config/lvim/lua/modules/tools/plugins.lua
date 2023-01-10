local tools = {}
local conf = require "modules.tools.config"

tools["meijieru/imtoggle.nvim"] = {
  event = "InsertEnter",
  config = conf.imtoggle,
  enabled = myvim.plugins.imtoggle.active,
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
}
tools["ruifm/gitlinker.nvim"] = {
  dependencies = "nvim-lua/plenary.nvim",
  config = conf.gitlinker,
  enabled = myvim.plugins.gitlinker.active,
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
  dependencies = { "nvim-lua/plenary.nvim" },
  config = conf.neogit,
  enabled = false,
}

tools["skywind3000/asynctasks.vim"] = {
  cmd = { "AsyncTask", "AsyncTaskEdit", "AsyncTaskList" },
  fn = { "asynctasks#source" },
  after = { "asyncrun.vim" },
  dependencies = {
    { "skywind3000/asyncrun.vim", cmd = { "AsyncRun" }, config = conf.asyncrun },
    {
      "GustavoKatel/telescope-asynctasks.nvim",
      enabled = myvim.plugins.telescope.active,
    },
  },
  init = conf.asynctasks,
}

tools["dstein64/vim-startuptime"] = {
  cmd = { "StartupTime" },
  init = conf.startuptime,
}

tools["michaelb/sniprun"] = {
  build = { "bash install.sh" },
  keys = { "<Plug>SnipRun", "<Plug>SnipRunOperator" },
  cmd = { "SnipRun" },
  config = conf.sniprun,
  enabled = myvim.plugins.sniprun.active,
}

tools["norcalli/nvim-colorizer.lua"] = {
  cmd = { "ColorizerToggle" },
  config = conf.colorizer,
}

tools["wakatime/vim-wakatime"] = {
  -- FIXME(meijieru): wait for https://github.com/wbthomason/packer.nvim/issues/8
  event = "BufRead",
  enabled = myvim.plugins.wakatime.active,
}

tools["nvim-telescope/telescope-frecency.nvim"] = {
  config = conf.telescope_frecency,
  dependencies = { "tami5/sqlite.lua" },
  enabled = myvim.plugins.telescope_frecency.active,
}

tools["alker0/chezmoi.vim"] = { enabled = false }
tools["Pocco81/AutoSave.nvim"] = {
  event = { "BufRead" },
  enabled = false,
}

tools["glacambre/firenvim"] = {
  -- FIXME(meijieru): doesn't work now
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  enabled = false,
}

tools["rktjmp/shipwright.nvim"] = {
  cmd = { "Shipwright" },
  enabled = myvim.plugins.shipwright.active,
}

return tools
