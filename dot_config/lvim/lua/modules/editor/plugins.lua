local M = {}
local conf = require "modules.editor.config"

-- editor["tpope/vim-unimpaired"] = {}
M["tpope/vim-surround"] = {
  dependencies = { { "tpope/vim-repeat" } },
  event = { "VeryLazy" },
}
M["machakann/vim-sandwich"] = { keys = { "s" }, enabled = false }
M["tpope/vim-sleuth"] = { event = "BufRead" }
M["tpope/vim-rsi"] = { event = { "CmdlineEnter", "InsertEnter" } }
M["tpope/vim-eunuch"] = { event = "CmdlineEnter" }

M["ojroques/vim-oscyank"] = {
  -- cmd = { "OSCYank", "OSCYankReg" },
  -- keys = { "<Plug>OSCYank" },
  config = conf.oscyank,
  cond = function()
    return os.getenv "SSH_TTY" ~= nil
  end,
  enabled = myvim.plugins.oscyank.active,
}
M["ibhagwan/smartyank.nvim"] = {
  event = { "VeryLazy" },
  config = conf.smartyank,
  enabled = myvim.plugins.smartyank.active,
}

M["kevinhwang91/nvim-ufo"] = {
  event = { "BufRead" },
  dependencies = "kevinhwang91/promise-async",
  config = conf.ufo,
  enabled = myvim.plugins.ufo.active,
}

M["phaazon/hop.nvim"] = {
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
  config = conf.hop,
  enabled = myvim.plugins.hop.active,
}
M["ggandor/leap.nvim"] = {
  event = { "BufRead" },
  config = conf.leap,
  enabled = myvim.plugins.leap.active,
}
M["ggandor/flit.nvim"] = {
  event = { "BufRead" },
  config = conf.flit,
  dependencies = { "ggandor/leap.nvim" },
  enabled = (myvim.plugins.leap.active and myvim.plugins.flit.active),
}

M["mg979/vim-visual-multi"] = {
  keys = {
    "<Plug>(VM-Find-Under)",
    "<Plug>(VM-Add-Cursor-Down)",
    "<Plug>(VM-Add-Cursor-Up)",
    "<Plug>(VM-Find-Subword-Under)",
  },
  init = conf.visual_multi,
}

M["stevearc/aerial.nvim"] = {
  cmd = { "AerialToggle", "AerialPrev", "AerialNext", "AerialPrevUp", "AerialNextUp" },
  config = conf.aerial,
  enabled = myvim.plugins.aerial.active,
}

M["kana/vim-textobj-indent"] = { event = "BufRead", dependencies = { "kana/vim-textobj-user" } }
M["jceb/vim-textobj-uri"] = { event = "BufRead", dependencies = { "kana/vim-textobj-user" } }
M["sgur/vim-textobj-parameter"] = {
  ft = { "lua" },
  dependencies = { "kana/vim-textobj-user" },
  enabled = false,
}

M["dhruvasagar/vim-table-mode"] = {
  cmd = "TableModeToggle",
}
M["junegunn/vim-easy-align"] = {
  keys = { "<Plug>(EasyAlign)" },
  cmd = "EasyAlign",
}
M["andymass/vim-matchup"] = {
  event = "BufRead",
  config = conf.matchup,
}

M["ethanholz/nvim-lastplace"] = {
  event = "BufRead",
  config = conf.lastplace,
}

M["theHamsta/nvim-dap-virtual-text"] = {
  dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  cmd = { "DapVirtualTextToggle" },
  config = conf.dap_virtual_text,
  enabled = myvim.plugins.dap_virtual_text.active and myvim.plugins.dap.active,
}
M["nvim-telescope/telescope-dap.nvim"] = {
  lazy = true,
  dependencies = { "mfussenegger/nvim-dap" },
  enabled = myvim.plugins.dap.active and myvim.plugins.telescope.active,
}
M["mfussenegger/nvim-dap-python"] = {
  dependencies = { "mfussenegger/nvim-dap" },
  ft = { "python" },
  enabled = myvim.plugins.dap.active,
}

M["nvim-treesitter/nvim-treesitter-textobjects"] = {
  event = "BufRead",
  dependencies = "nvim-treesitter",
}
M["p00f/nvim-ts-rainbow"] = {
  event = "BufRead",
  dependencies = "nvim-treesitter",
}
M["nvim-treesitter/playground"] = {
  cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  dependencies = "nvim-treesitter",
}
M["RRethy/nvim-treesitter-textsubjects"] = {
  event = "BufRead",
  dependencies = "nvim-treesitter",
  enabled = false,
}

M["danymat/neogen"] = {
  cmd = { "Neogen" },
  dependencies = { "nvim-treesitter" },
  config = conf.neogen,
  enabled = myvim.plugins.neogen.active,
}

M["b0o/mapx.nvim"] = {}

M["rmagatti/auto-session"] = {
  event = "VimEnter",
  config = conf.auto_session,
  enabled = myvim.plugins.auto_session.active,
}
M["rmagatti/session-lens"] = {
  dependencies = {
    "auto-session",
    "telescope.nvim",
  },
  config = conf.session_lens,
  enabled = (myvim.plugins.auto_session.active and myvim.plugins.telescope.active),
}

M["ckolkey/ts-node-action"] = {
  event = "BufRead",
  dependencies = { "nvim-treesitter" },
}

return M
