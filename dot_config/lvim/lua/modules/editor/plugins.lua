local editor = {}
local conf = require "modules.editor.config"

-- editor["tpope/vim-unimpaired"] = {}
editor["tpope/vim-surround"] = {
  dependencies = { { "tpope/vim-repeat" } },
  event = "CursorMoved",
  -- keys = { "cs", "ds", "ys" }, -- cause delay dd
  after = "vim-repeat",
}
editor["machakann/vim-sandwich"] = { keys = { "s" }, enabled = false }
editor["tpope/vim-sleuth"] = { event = "BufRead" }
editor["tpope/vim-rsi"] = { event = { "CmdlineEnter", "InsertEnter" } }
editor["tpope/vim-eunuch"] = { event = "BufRead" }

editor["ojroques/vim-oscyank"] = {
  -- cmd = { "OSCYank", "OSCYankReg" },
  -- keys = { "<Plug>OSCYank" },
  config = conf.oscyank,
  cond = function()
    return os.getenv "SSH_TTY" ~= nil
  end,
  enabled = myvim.plugins.oscyank.active,
}
editor["ibhagwan/smartyank.nvim"] = {
  config = conf.smartyank,
  enabled = myvim.plugins.smartyank.active,
}

editor["kevinhwang91/nvim-ufo"] = {
  -- NOTE(meijieru): `BufReadPre` cause problem.
  event = { "BufRead" },
  dependencies = "kevinhwang91/promise-async",
  config = conf.ufo,
  enabled = myvim.plugins.ufo.active,
}

editor["phaazon/hop.nvim"] = {
  cmd = {
    "HopLineStart",
    "HopLineStartAC",
    "HopLineStartBC",
    "HopLineStartMW",
    "HopWord",
    "HopWordAC",
    "HopWordBC",
    "HopPattern",
    "HopChar1",
    "HopChar2",
  },
  -- event = "BufRead",
  config = conf.hop,
  enabled = myvim.plugins.hop.active,
}
editor["ggandor/leap.nvim"] = {
  config = conf.leap,
  enabled = myvim.plugins.leap.active,
}
editor["ggandor/flit.nvim"] = {
  config = conf.flit,
  enabled = (myvim.plugins.leap.active and myvim.plugins.flit.active),
}

editor["mg979/vim-visual-multi"] = {
  keys = {
    "<Plug>(VM-Find-Under)",
    "<Plug>(VM-Add-Cursor-Down)",
    "<Plug>(VM-Add-Cursor-Up)",
    "<Plug>(VM-Find-Subword-Under)",
  },
  init = conf.visual_multi,
}

editor["stevearc/aerial.nvim"] = {
  cmd = { "AerialToggle", "AerialPrev", "AerialNext", "AerialPrevUp", "AerialNextUp" },
  config = conf.aerial,
  enabled = myvim.plugins.aerial.active,
}

editor["kana/vim-textobj-user"] = { fn = { "textobj#user#*" } }
editor["kana/vim-textobj-indent"] = { event = "BufRead" }
editor["jceb/vim-textobj-uri"] = { event = "BufRead" }
editor["sgur/vim-textobj-parameter"] = { ft = { "lua" }, enabled = false }

editor["dhruvasagar/vim-table-mode"] = {
  cmd = "TableModeToggle",
}
editor["junegunn/vim-easy-align"] = {
  cmd = "EasyAlign",
}
editor["andymass/vim-matchup"] = {
  event = "CursorMoved",
  config = conf.matchup,
}

editor["ethanholz/nvim-lastplace"] = {
  event = "BufRead",
  config = conf.lastplace,
}

editor["theHamsta/nvim-dap-virtual-text"] = {
  dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  cmd = { "DapVirtualTextToggle" },
  config = conf.dap_virtual_text,
  enabled = (myvim.plugins.dap_virtual_text.active and myvim.plugins.dap.active),
}
editor["nvim-telescope/telescope-dap.nvim"] = {
  dependencies = { "mfussenegger/nvim-dap" },
  enabled = (myvim.plugins.dap_telescope.active and myvim.plugins.dap.active and myvim.plugins.telescope.active),
}
editor["mfussenegger/nvim-dap-python"] = {
  dependencies = { "mfussenegger/nvim-dap" },
  ft = { "python" },
  enabled = myvim.plugins.dap.active,
}

editor["nvim-treesitter/nvim-treesitter-textobjects"] = {
  event = "BufRead",
  after = "nvim-treesitter",
}
editor["p00f/nvim-ts-rainbow"] = {
  event = "BufRead",
  after = "nvim-treesitter",
}
editor["nvim-treesitter/playground"] = {
  cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  after = "nvim-treesitter",
}
editor["RRethy/nvim-treesitter-textsubjects"] = {
  event = "BufRead",
  after = "nvim-treesitter",
  enabled = false,
}

editor["danymat/neogen"] = {
  cmd = { "Neogen" },
  dependencies = { "nvim-treesitter" },
  config = conf.neogen,
  enabled = myvim.plugins.neogen.active,
}

editor["b0o/mapx.nvim"] = {}

editor["rmagatti/auto-session"] = {
  event = "VimEnter",
  config = conf.auto_session,
  enabled = myvim.plugins.auto_session.active,
}
editor["rmagatti/session-lens"] = {
  dependencies = {
    "auto-session",
    "telescope.nvim",
  },
  config = conf.session_lens,
  enabled = (myvim.plugins.auto_session.active and myvim.plugins.telescope.active),
}

editor["ckolkey/ts-node-action"] = {
  dependencies = { "nvim-treesitter" },
}

return editor
