local M = {}

function M.hop()
  require("hop").setup()
end

function M.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
  -- enable ds%, cs%
  vim.g.matchup_surround_enabled = true
end

function M.lastplace()
  require("nvim-lastplace").setup {
    lastplace_ignore_buftype = myvim.ignores.buftype,
    lastplace_ignore_filetype = myvim.ignores.filetype,
    lastplace_open_folds = true,
  }
end

function M.dapui()
  local dap, dapui = require "dap", require "dapui"
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  -- end

  require("dapui").setup {
    sidebar = {
      -- You can change the order of elements in the sidebar
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        { id = "watches", size = 0.18 },
        { id = "stacks", size = 0.20 },
        { id = "breakpoints", size = 0.20 },
        { id = "scopes", size = 0.42 },
      },
      size = 45,
      position = "left", -- Can be "left", "right", "top", "bottom"
    },
    floating = {
      border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    },
  }
end

function M.dap_virtual_text()
  require("nvim-dap-virtual-text").setup {
    enabled = true,
  }
end

function M.visual_multi()
  local vm_maps = {}
  vm_maps["Select Operator"] = ""
  vm_maps["Undo"] = "u"
  vm_maps["Redo"] = "<C-r>"
  vm_maps["Reselect Last"] = "gs"
  -- useful default mappings
  -- \\z for normal everywhere
  -- ] for goto next
  -- [ for goto prev

  vim.g.VM_default_mappings = false
  vim.g.VM_maps = vm_maps
end

function M.symbols_outline()
  vim.g.symbols_outline = {
    width = 40,
    show_guides = false,
    preview_bg_highlight = "Normal",
    symbols = {
      -- use lvim.builtin.cmp.formatting.kind_icons
      File = { icon = "", hl = "TSURI" },
      Module = { icon = "", hl = "TSNamespace" },
      Package = { icon = "", hl = "TSNamespace" },
      Class = { icon = "ﴯ", hl = "TSType" },
      Method = { icon = "", hl = "TSMethod" },
      Property = { icon = "ﰠ", hl = "TSMethod" },
      Field = { icon = "ﰠ", hl = "TSField" },
      Constructor = { icon = "", hl = "TSConstructor" },
      Enum = { icon = "", hl = "TSType" },
      Function = { icon = "", hl = "TSFunction" },
      Variable = { icon = "", hl = "TSVariable" },
      Constant = { icon = "", hl = "TSConstant" },
      Struct = { icon = "פּ", hl = "TSType" },
      Event = { icon = "", hl = "TSType" },
      Operator = { icon = "", hl = "TSOperator" },
      TypeParameter = { icon = "", hl = "TSParameter" },

      -- TODO: override
      -- Namespace = { icon = "", hl = "TSNamespace" },
      -- Interface = { icon = "ﰮ", hl = "TSType" },
      -- String = { icon = "𝓐", hl = "TSString" },
      -- Number = { icon = "#", hl = "TSNumber" },
      -- Boolean = { icon = "⊨", hl = "TSBoolean" },
      -- Array = { icon = "", hl = "TSConstant" },
      -- Object = { icon = "⦿", hl = "TSType" },
      -- Key = { icon = "🔐", hl = "TSType" },
      -- Null = { icon = "NULL", hl = "TSType" },
      -- EnumMember = { icon = "", hl = "TSField" },
    },
  }
end

-- TODO: maybe lualine integration
function M.aerial()
  local opts = {
    -- Priority list of preferred backends for aerial
    backends = { "lsp", "treesitter", "markdown" },
    max_width = 40,
    min_width = 40,

    lsp = {
      -- Set to false to not update the symbols when there are LSP errors
      update_when_errors = false,
    },

    -- A list of all symbols to display. Set to false to display all symbols.
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Struct",
    },
  }
  local icons = { Collapsed = "" }
  for _, name in ipairs(opts.filter_kind) do
    icons[name] = myvim.kind_icons[name]
    icons[name .. "Collapsed"] = string.format("%s %s", myvim.kind_icons[name], icons.Collapsed)
  end
  opts.icons = icons
  vim.g.aerial = opts

  lvim.lsp.on_attach_callback = function(client, bufnr)
    require("aerial").on_attach(client, bufnr)
  end
  require("telescope").load_extension "aerial"
end

function M.spellsitter()
  require("spellsitter").setup()
end

function M.neogen()
  require("neogen").setup { enabled = true }
end

function M.oscyank()
  vim.cmd [[
    " autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
  ]]
end

require("modules.editor.lvim").setup()

return M
