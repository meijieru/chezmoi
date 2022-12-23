local config = {}

local Log = require "core.log"

function config.lsp_signature()
  require("lsp_signature").setup {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      -- border = "rounded",
      border = "none",
    },
    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    hint_enable = false, -- virtual hint enable
    hint_prefix = "🐼 ", -- Panda for parameter

    doc_lines = 0,
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap
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
