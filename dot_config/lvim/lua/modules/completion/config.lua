local config = {}

local Log = require "core.log"

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

function config.cmp_dap()
  require("cmp").setup {
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
  }

  require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

if myvim.lsp.ciderlsp then
  Log:debug "Enable ciderlsp"

  local nvim_lsp = require "lspconfig"
  local configs = require "lspconfig.configs"
  configs.ciderlsp = {
    default_config = {
      cmd = { "/google/bin/releases/cider/ciderlsp/ciderlsp", "--tooltag=nvim-lsp", "--noforward_sync_responses" },
      filetypes = { "c", "cpp", "java", "proto", "textproto", "go", "python", "bzl" },
      root_dir = nvim_lsp.util.root_pattern "BUILD",
      settings = {},
    },
  }
end

require("modules.completion.lvim").setup()

return config
