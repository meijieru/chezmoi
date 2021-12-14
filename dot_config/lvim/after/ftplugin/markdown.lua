local function null_ls_config()
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup { { exe = "prettier", filetypes = { "markdown" } } }
end

vim.wo.wrap = true
null_ls_config()
-- require("modules.completion.lsp").lsp_config("ltex", false)
