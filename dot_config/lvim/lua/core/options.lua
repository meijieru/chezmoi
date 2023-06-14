vim.o.foldcolumn = "1"
if myvim.plugins.ufo.active then
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = -1
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
else
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
end
vim.o.showtabline = 1
vim.o.timeoutlen = 500
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.showbreak = "↳ "
vim.opt.diffopt:append { "internal", "algorithm:patience", "indent-heuristic", "linematch:60" }
vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.background = myvim.colorscheme.background
vim.o.splitkeep = "screen"

-- https://github.com/hrsh7th/nvim-cmp/issues/309
vim.o.title = false

-- for click handler of `luukvbaal/statuscol.nvim`
vim.o.mousemodel = "extend"

-- vim.o.exrc = true
-- vim.o.cmdheight = 0

if myvim.plugins.smartyank.active then
  vim.o.clipboard = ""
end
_G.qftf = require("core.utils.ui").qftf
vim.o.qftf = "{info -> v:lua._G.qftf(info, 'shorten')}"

-- lvim
lvim.log = vim.tbl_deep_extend("force", lvim.log, myvim.log)
lvim.colorscheme = myvim.colorscheme.name
