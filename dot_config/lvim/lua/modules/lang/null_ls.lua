local M = {}

M.config = function()
  -- NOTE: By default, all null-ls providers are checked on startup.
  -- If you want to avoid that or want to only set up the provider
  -- when you opening the associated file-type,
  -- then you can use filetype plugins for this purpose.
  -- https://www.lunarvim.org/languages/#lazy-loading-the-formatter-setup

  -- local status_ok, nls = pcall(require, "null-ls")
  -- if not status_ok then
  --   return
  -- end
  local nls = require "null-ls"

  local methods = require "null-ls.methods"
  local my_nls_yapf = nls.builtins.formatting.yapf
  if type(my_nls_yapf.method) == "table" then
    error "Remove these block, use null-ls yapf"
  else
    my_nls_yapf.method = { methods.internal.FORMATTING, methods.internal.RANGE_FORMATTING }
  end

  -- you can either config null-ls itself
  nls.config {
    sources = {
      nls.builtins.formatting.prettier,
      nls.builtins.formatting.stylua,
      my_nls_yapf,
      -- nls.builtins.formatting.goimports,
      -- nls.builtins.formatting.cmake_format,
      -- nls.builtins.formatting.scalafmt,
      -- nls.builtins.formatting.sqlformat,
      -- nls.builtins.formatting.terraform_fmt,
      -- nls.builtins.formatting.shfmt.with { extra_args = { "-i", "2", "-ci" } },
      -- nls.builtins.diagnostics.eslint_d,
      -- nls.builtins.diagnostics.shellcheck,
      -- nls.builtins.diagnostics.luacheck,
      -- nls.builtins.diagnostics.vint,
      -- nls.builtins.diagnostics.chktex,
    },
  }

  local util = require "lspconfig/util"
  local default_opts = require("lvim.lsp").get_common_opts()
  default_opts.root_dir = function(fname)
    return util.root_pattern(unpack(myvim.root_markers))(fname) or vim.fn.getcwd()
  end
  lvim.lsp.null_ls.setup = default_opts

  -- or use the lunarvim syntax
  -- local formatters = require "lvim.lsp.null-ls.formatters"
  -- formatters.setup {
  --   {
  --     exe = "prettier",
  --     filetypes = {
  --       "javascriptreact",
  --       "javascript",
  --       "typescriptreact",
  --       "typescript",
  --       "json",
  --       "markdown",
  --     },
  --   },
  -- }
  -- local linters = require "lvim.lsp.null-ls.linters"
  -- linters.setup {
  --   {
  --     exe = "eslint",
  --     filetypes = {
  --       "javascriptreact",
  --       "javascript",
  --       "typescriptreact",
  --       "typescript",
  --       "vue",
  --     },
  --   },
  -- }

  -- WARN: do not redfine or reuse formatter/linters in this format
  -- or use the lang specific format
  --[[ lvim.lang.python.formatters = {
    {
      exe = "black",
      args = { "--fast" },
    },
    {
      exe = "isort",
      args = {
        "--profile",
        "black",
      },
    },
  } --]]
end

return M
