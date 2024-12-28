return {
  {
    "none-ls.nvim",
    opts = function(_, opts)
      if not myvim.plugins.is_development_machine then return opts end

      local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      opts.sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.cmake_format,
        null_ls.builtins.code_actions.gitrebase,
      }
      return opts
    end,
    enabled = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      if myvim.plugins.is_development_machine then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "basedpyright" })
      end
    end,
  },
}
