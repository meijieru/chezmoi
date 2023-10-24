return {
  "null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local yapf = null_ls.builtins.formatting.yapf
    yapf.method = null_ls.methods.RANGE_FORMATTING
    opts.sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.code_actions.gitrebase,

      -- TODO(meijieru): revisit when ruff works
      yapf,
    }
    return opts
  end,
  enabled = true,
}
