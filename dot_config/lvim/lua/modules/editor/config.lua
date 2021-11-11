local config = {}

function config.hop()
  require("hop").setup()
end

function config.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

function config.lastplace()
  require("nvim-lastplace").setup {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
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

return config
