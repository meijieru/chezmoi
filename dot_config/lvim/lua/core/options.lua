vim.o.ruler = false
vim.o.cmdheight = 1
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.mouse = ""
vim.o.showtabline = 1
vim.o.splitbelow = false
vim.o.splitright = false
vim.o.timeoutlen = 500
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.showbreak = "↳ "
vim.o.diffopt = "filler,iwhite,internal,algorithm:patience" -- use patience diff algorithm
vim.o.lazyredraw = true
vim.o.colorcolumn = ""
vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

_G.qftf = require("core.utils.ui").qftf
vim.o.qftf = "{info -> v:lua._G.qftf(info, 'shorten')}"

-- lvim
lvim.log.level = "info"
lvim.format_on_save = false
lvim.leader = "space"
vim.o.background = "light"
lvim.colorscheme = "edge_lush"
-- lvim.transparent_window = true
