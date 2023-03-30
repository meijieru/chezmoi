local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { exe = "stylua" } }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup { { exe = "luacheck" } }

-- TODO(meijieru): currently the hover has wrong highlight
for _, hl in ipairs { "luaParenError", "luaError", "markdownError" } do
  vim.api.nvim_set_hl(0, hl, { link = "None" })
end
