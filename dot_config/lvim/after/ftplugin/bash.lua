local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "shfmt", filetypes = { "bash" } } }
