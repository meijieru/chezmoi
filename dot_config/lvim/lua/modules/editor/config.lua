local config = {}

function config.hop()
  require("hop").setup()
end

function config.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
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
  -- useful default mappings
  -- \\z for normal everywhere

  vim.g.VM_default_mappings = false
  vim.g.VM_maps = vm_maps
end

require("modules.editor.lvim").setup()

return config
