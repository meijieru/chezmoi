local M = {}

function M.setup_telescope()
  lvim.builtin.telescope.defaults.mappings.i["<C-w>"] = function()
    vim.cmd [[normal! b"zcw]]
  end
  lvim.builtin.telescope.defaults.mappings.i["<C-h>"] = "which_key"
  lvim.builtin.telescope.defaults.mappings.n["g?"] = "which_key"
  lvim.builtin.telescope.defaults.layout_config.width = 0.95
  lvim.builtin.telescope.on_config_done = function()
    local actions = require "telescope.actions"
    local function checktime_wrapper(func_name)
      local func = actions[func_name]
      return function(...)
        func(...)
        vim.cmd "checktime"
      end
    end
    -- checktime to refresh the content
    actions.git_checkout = checktime_wrapper "git_checkout"
    actions.git_checkout_current_buffer = checktime_wrapper "git_checkout_current_buffer"
  end
end

function M.setup()
  M.setup_telescope()
end

return M
