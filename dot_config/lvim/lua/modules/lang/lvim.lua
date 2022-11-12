local M = {}

function M.setup_null_ls()
  lvim.lsp.null_ls.setup = {
    root_dir = require("core.utils.lsp").root_dir,
  }

  local code_actions = require "lvim.lsp.null-ls.code_actions"
  code_actions.setup {
    -- general sources, ft plugins check `after/ftplugin`
    {
      name = "gitsigns",
      -- TODO(meijieru): wait for https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
      disabled_filetypes = { "cpp", "proto", "cuda" },
    },
  }
end

function M.setup()
  M.setup_null_ls()
end

return M
