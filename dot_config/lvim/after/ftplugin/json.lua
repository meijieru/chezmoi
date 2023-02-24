local Log = require "core.log"

Log:debug "set tabstop from filetype plugin"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "prettier", filetypes = { "json" } } }
