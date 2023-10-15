-- default options: ~/.config/astronvim/lua/astronvim/options.lua

vim.opt.diffopt:append { "algorithm:patience", "indent-heuristic" }

_G.qftf = require("core.utils.ui").qftf

return {
  opt = {
    relativenumber = false,
    showtabline = 1,
    shiftwidth = 4,
    tabstop = 4,
    showbreak = "↳ ",
    grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]],
    grepformat = "%f:%l:%c:%m",
    background = "light",
    splitkeep = "screen",
    -- https://github.com/hrsh7th/nvim-cmp/issues/309
    title = false,
    -- for click handler of `luukvbaal/statuscol.nvim`
    mousemodel = "extend",
    qftf = "{info -> v:lua._G.qftf(info, 'shorten')}",
    swapfile = false,
    clipboard = "",
    fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  },
}
