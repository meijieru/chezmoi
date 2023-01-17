local config = {}

local Log = require "core.log"

function config.lsp_signature()
  require("lsp_signature").setup {
    handler_opts = {
      border = "rounded",
    },
    max_width = 100,
    floating_window = false,
    floating_window_above_cur_line = true,
    hint_enable = true,
    doc_lines = 0,
  }
end

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

function config.tabnine()
  local tabnine = require "cmp_tabnine.config"

  tabnine:setup {
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    -- run_on_every_keystroke = true;
    -- snippet_placeholder = '..';
  }
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
