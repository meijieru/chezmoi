-- vim.o.cmdheight = 0
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
vim.opt.diffopt:append { "internal", "algorithm:patience", "indent-heuristic" }
vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.laststatus = 3
vim.o.background = myvim.colorscheme.background
vim.o.exrc = true
-- https://github.com/hrsh7th/nvim-cmp/issues/309
vim.o.title = false

if myvim.plugins.smartyank.active then
  vim.o.clipboard = ""
end

if vim.fn.has "nvim-0.9" then
  vim.o.splitkeep = "screen"
  vim.opt.diffopt:append "linematch:60"
end

_G.qftf = require("core.utils.ui").qftf
vim.o.qftf = "{info -> v:lua._G.qftf(info, 'shorten')}"

-- lvim
lvim.log = vim.tbl_deep_extend("force", lvim.log, myvim.log)
lvim.format_on_save = false
lvim.leader = "space"
lvim.colorscheme = myvim.colorscheme.name
