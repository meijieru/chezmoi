local editor = {}
local conf = require "modules.editor.config"

-- editor["tpope/vim-unimpaired"] = {}
editor["tpope/vim-surround"] = {
  requires = { { "tpope/vim-repeat", opt = true } },
  event = "CursorMoved",
  -- keys = { "cs", "ds", "ys" }, -- cause delay dd
  after = "vim-repeat",
}
editor["machakann/vim-sandwich"] = { keys = { "s" }, disable = true }
editor["tpope/vim-sleuth"] = { event = "BufRead" }
editor["tpope/vim-rsi"] = { event = { "CmdlineEnter", "InsertEnter" } }
editor["tpope/vim-eunuch"] = { event = "BufRead" }
editor["bronson/vim-visual-star-search"] = {}
editor["ojroques/vim-oscyank"] = {
  -- cmd = { "OSCYank", "OSCYankReg" },
  -- keys = { "<Plug>OSCYank" },
  config = conf.oscyank,
  cond = function()
    return os.getenv "SSH_TTY" ~= nil
  end,
}
editor["anuvyklack/pretty-fold.nvim"] = {
  event = "BufRead",
  config = conf.pretty_fold,
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
  module = { "hop" },
  -- event = "BufRead",
  config = conf.hop,
  disable = not myvim.plugins.hop.active,
}
editor["mg979/vim-visual-multi"] = {
  keys = {
    "<Plug>(VM-Find-Under)",
    "<Plug>(VM-Add-Cursor-Down)",
    "<Plug>(VM-Add-Cursor-Up)",
  },
  setup = conf.visual_multi,
}

editor["stevearc/aerial.nvim"] = {
  cmd = { "AerialToggle", "AerialPrev", "AerialNext", "AerialPrevUp", "AerialNextUp" },
  config = conf.aerial,
  disable = not myvim.plugins.aerial.active,
}

editor["kana/vim-textobj-user"] = { fn = { "textobj#user#*" } }
editor["kana/vim-textobj-indent"] = { event = "BufRead" }
editor["jceb/vim-textobj-uri"] = { event = "BufRead" }
editor["sgur/vim-textobj-parameter"] = { ft = { "lua" }, disable = true }

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
  disable = false,
}

editor["rcarriga/nvim-dap-ui"] = {
  -- module = { "dapui" },  --affect open_on_start
  requires = { "mfussenegger/nvim-dap" },
  config = conf.dapui,
  disable = not myvim.plugins.dap.active,
}
editor["theHamsta/nvim-dap-virtual-text"] = {
  requires = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  cmd = { "DapVirtualTextToggle" },
  config = conf.dap_virtual_text,
  disable = not (myvim.plugins.dap_virtual_text.active and myvim.plugins.dap.active),
}
editor["nvim-telescope/telescope-dap.nvim"] = {
  requires = { "mfussenegger/nvim-dap" },
  module = "telescope._extensions.dap",
  disable = not (myvim.plugins.dap_telescope.active and myvim.plugins.dap.active and myvim.plugins.telescope.active),
}
editor["mfussenegger/nvim-dap-python"] = {
  requires = { "mfussenegger/nvim-dap" },
  ft = { "python" },
  disable = not myvim.plugins.dap.active,
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
  disable = true,
}
editor["lewis6991/spellsitter.nvim"] = {
  event = "BufRead", -- use filetype instead
  config = conf.spellsitter,
  disable = not myvim.plugins.spellsitter.active,
}

editor["danymat/neogen"] = {
  -- event = "BufRead",
  module = { "neogen" },
  requires = { "nvim-treesitter" },
  config = conf.neogen,
  disable = not myvim.plugins.neogen.active,
}

editor["b0o/mapx.nvim"] = { module = "mapx" }

editor["rmagatti/auto-session"] = {
  event = "VimEnter",
  config = conf.auto_session,
  disable = not myvim.plugins.auto_session.active,
}
editor["rmagatti/session-lens"] = {
  module = "telescope._extensions.session-lens",
  requires = {
    "auto-session",
    "telescope.nvim",
  },
  config = conf.session_lens,
  disable = not (myvim.plugins.auto_session.active and myvim.plugins.telescope.active),
}

return editor
