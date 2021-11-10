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
  -- FIXME(meijieru): lazy load
  event = "BufRead",
  config = conf.hop,
  disable = false,
}
editor["mg979/vim-visual-multi"] = {}
editor["simrat39/symbols-outline.nvim"] = {
  cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
}

editor["Chiel92/vim-autoformat"] = {
  cmd = { "Autoformat" },
  setup = function()
    _my_load_vimscript "./site/bundle/autoformat.vim"
  end,
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
  -- FIXME(meijieru): lazy load
  config = conf.lastplace,
  disable = false,
}

return editor
