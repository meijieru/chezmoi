local spec = {

  { import = "astrocommunity.completion.cmp-cmdline" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },

  {
    "onsails/lspkind.nvim",
    opts = {
      symbol_map = {
        Copilot = "",
      },
    },
  },
}

-- TODO(meijieru): revisit

-- if myvim.plugins.is_development_machine then
if false then
  return vim.list_extend(spec, {

    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          ["dap-repl"] = false,
        },
      },
    },
    {
      "zbirenbaum/copilot-cmp",
      opts = {},
      dependencies = "copilot.lua",
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = { "zbirenbaum/copilot-cmp" },
      opts = function(_, opts)
        local cmp_sources = require "cmp.config.sources"
        opts.sources = cmp_sources {
          { name = "copilot", priority = 1001 },
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }
        opts.duplicates.copilot = 1
        return opts
      end,
    },
  })
end

return spec
