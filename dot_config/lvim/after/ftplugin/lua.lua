local Log = require "core.log"

Log:debug "set tabstop from filetype plugin"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "stylua" } }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup { { exe = "luacheck" } }

-- TODO(meijieru): currently the hover has wrong highlight
for _, hl in ipairs { "luaParenError", "luaError", "markdownError" } do
  vim.api.nvim_set_hl(0, hl, { link = "None" })
end
