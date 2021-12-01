vim.bo.filetype = "teal"

local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { exe = "teal" } }
