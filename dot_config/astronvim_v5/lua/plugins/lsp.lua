return {

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "prettierd", "injected" },
      },
    },
  },

  {
    "none-ls.nvim",
    opts = function(_, opts)
      if (not myvim.plugins.is_development_machine) or myvim.plugins.is_corporate_machine then
        return opts
      end

      local null_ls = require("null-ls")

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
    enabled = false,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        vim.tbl_filter(function(val)
          return not vim.tbl_contains(myvim.plugins.lsp.exclude_from_ensure_installed, val)
        end, opts.ensure_installed),
        myvim.plugins.lsp.ensure_installed
      )
    end,
  },
}
