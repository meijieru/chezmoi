return {

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "prettierd", "injected" },
        -- NOTE(meijieru): biome doesn't work with vscode setting.json for now
        jsonc = { "prettierd" },
      },
      format_on_save = false,
    },
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
