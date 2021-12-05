local config = {}

function config.hop()
  require("hop").setup()
end

function config.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
  -- enable ds%, cs%
  vim.g.matchup_surround_enabled = true
end

function config.lastplace()
  require("nvim-lastplace").setup {
    lastplace_ignore_buftype = myvim.ignores.buftype,
    lastplace_ignore_filetype = myvim.ignores.filetype,
    lastplace_open_folds = true,
  }
end

function config.dapui()
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

  require("dapui").setup {}
end

function config.visual_multi()
  local vm_maps = {}
  vm_maps["Select Operator"] = ""
  vm_maps["Undo"] = "u"
  vm_maps["Redo"] = "<C-r>"
  vm_maps["Add Cursor Down"] = "<C-Down>"
  vm_maps["Add Cursor Up"] = "<C-Up>"
  vm_maps["Reselect Last"] = "gS"
  -- useful default mappings
  -- \\z for normal everywhere
  -- ] for goto next
  -- [ for goto prev

  vim.g.VM_default_mappings = false
  vim.g.VM_maps = vm_maps
end

function config.symbols_outline()
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

require("modules.editor.lvim").setup()

return config
