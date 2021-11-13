local editor = {}
local conf = require "modules.editor.config"

editor["tpope/vim-unimpaired"] = {}
editor["tpope/vim-surround"] = { keys = { "c", "d", "y", "S" } }
editor["tpope/vim-repeat"] = {}
editor["tpope/vim-sleuth"] = {}
editor["tpope/vim-rsi"] = {}
editor["tpope/vim-eunuch"] = {}
editor["p00f/nvim-ts-rainbow"] = {}
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
  -- event = "BufRead",
  config = conf.hop,
  disable = false,
}
editor["mg979/vim-visual-multi"] = {
  -- TODO(meijieru): lazy load
  -- keys = { "<Plug>(VM-Find-Under)" },
}
editor["simrat39/symbols-outline.nvim"] = {
  cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
}

editor["kana/vim-textobj-user"] = {}
editor["kana/vim-textobj-indent"] = {}
editor["jceb/vim-textobj-uri"] = {}
editor["sgur/vim-textobj-parameter"] = { ft = { "lua" }, enable = false }

editor["junegunn/vim-easy-align"] = {
  cmd = "EasyAlign",
}
editor["andymass/vim-matchup"] = {
  config = conf.matchup,
}

editor["ethanholz/nvim-lastplace"] = {
  config = conf.lastplace,
  disable = false,
}

editor["rcarriga/nvim-dap-ui"] = {
  config = conf.dapui,
  -- module = { "dapui" },  --affect open_on_start
  requires = { "mfussenegger/nvim-dap" },
}

editor["nvim-treesitter/nvim-treesitter-textobjects"] = {}
editor["p00f/nvim-ts-rainbow"] = {}
editor["nvim-treesitter/playground"] = { event = "BufRead" }
editor["RRethy/nvim-treesitter-textsubjects"] = {}

return editor
