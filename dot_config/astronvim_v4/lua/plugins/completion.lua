local spec = {

  { import = "astrocommunity.completion.blink-cmp" },
  {
    "Saghen/blink.cmp",
    opts_extend = { "sources.default", "sources.cmdline" },

    opts = {
      keymap = {
        ["<Tab>"] = vim.NIL,
        ["<S-Tab>"] = vim.NIL,
        ["<C-J>"] = vim.NIL,
        ["<C-K>"] = vim.NIL,
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal",
        },
      },
      completion = {
        menu = {
          auto_show = true,
          border = "rounded",
          winhighlight = "Normal:Normal",
        },
        documentation = {
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal",
          },
        },
      },
    },
  },

  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },

  -- { import = "astrocommunity.completion.cmp-cmdline" },
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
