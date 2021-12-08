local editor = {}
local conf = require "modules.editor.config"

-- editor["tpope/vim-unimpaired"] = {}
editor["tpope/vim-repeat"] = {}
editor["tpope/vim-surround"] = {}
editor["machakann/vim-sandwich"] = { keys = { "s" }, disable = true }
editor["tpope/vim-sleuth"] = {}
editor["tpope/vim-rsi"] = {}
editor["tpope/vim-eunuch"] = {}
editor["bronson/vim-visual-star-search"] = {}

editor["phaazon/hop.nvim"] = {
  cmd = {
    "HopLineStart",
    "HopLineStartAC",
    "HopLineStartBC",
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
  disable = false,
}
editor["mg979/vim-visual-multi"] = {
  -- TODO(meijieru): lazy load
  -- TODO(meijieru): fix https://github.com/mg979/vim-visual-multi/issues/121
  -- keys = { "<Plug>(VM-Find-Under)" },
  config = conf.visual_multi,
}

editor["simrat39/symbols-outline.nvim"] = {
  cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
  setup = conf.symbols_outline,
  disable = true,
}
editor["stevearc/aerial.nvim"] = {
  cmd = { "AerialToggle", "AerialPrev", "AerialNext", "AerialPrevUp", "AerialNextUp" },
  config = conf.aerial,
  disable = not myvim.plugins.aerial.active,
}

editor["kana/vim-textobj-user"] = {}
editor["kana/vim-textobj-indent"] = {}
editor["jceb/vim-textobj-uri"] = {}
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
  config = conf.dapui,
  -- module = { "dapui" },  --affect open_on_start
  requires = { "mfussenegger/nvim-dap" },
}
editor["nvim-telescope/telescope-dap.nvim"] = {
  config = conf.dap,
  -- cmd = "Telescope",
  disable = true, -- TODO: revisit later
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

editor["danymat/neogen"] = {
  -- event = "BufRead",
  module = { "neogen" },
  requires = { "nvim-treesitter" },
  config = conf.neogen,
  disable = not myvim.plugins.neogen.active,
}

editor["b0o/mapx.nvim"] = {}

return editor
