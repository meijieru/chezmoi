vim.o.tabstop = 2
vim.o.shiftwidth = 2

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "prettier", filetypes = { "json" } } }
