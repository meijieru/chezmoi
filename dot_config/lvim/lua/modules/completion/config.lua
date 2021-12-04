local config = {}

function config.lsp_signature()
  require("lsp_signature").setup {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      -- border = "rounded",
      border = "none",
    },
    floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🐼 ", -- Panda for parameter

    doc_lines = 0,
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap
  }
end

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

function config.trouble()
  require("trouble").setup {
    use_lsp_diagnostic_signs = true,
  }
end

function config.cmp_cmdline()
  local cmp = require "cmp"

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
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

local cmp = require "cmp"
lvim.builtin.cmp.confirm_opts = {
  behavior = cmp.ConfirmBehavior.Insert,
  select = false,
}
lvim.builtin.cmp.formatting.kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

if lvim.builtin.telescope.active then
  local function _open_with_trouble(prompt_bufnr, _mode)
    -- defer trouble loading
    local trouble = require "trouble.providers.telescope"
    return trouble.open_with_trouble(prompt_bufnr, _mode)
  end

  lvim.builtin.telescope.defaults.mappings.i["<C-t>"] = _open_with_trouble
  lvim.builtin.telescope.defaults.mappings.n["<C-t>"] = _open_with_trouble
end

return config
