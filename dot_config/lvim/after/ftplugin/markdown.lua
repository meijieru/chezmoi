local function null_ls_config()
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup { { exe = "prettier", filetypes = { "markdown" } } }
end

vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = 0 })
null_ls_config()

-- require("lvim.lsp.manager").setup "grammarly"
require("lvim.lsp.manager").setup "marksman"
