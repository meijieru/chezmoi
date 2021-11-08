local terminal = require("toggleterm.terminal").Terminal

local M = {
  settings = {
    mapping = "<leader>ta",
  },
}

function M.reset()
  if M._asynctask_term ~= nil then
    if vim.g.asynctasks_term_reuse ~= 1 then
      -- TODO(meijieru): handle multiple terminals
      error "Terminal existed"
    else
      vim.notify("Delete existing terminal", "info")
    end
    M._asynctask_term:shutdown()
    vim.api.nvim_del_keymap("n", M._asynctask_mapping)
  end

  M._asynctask_term = nil
  M._asynctask_term_toggle = nil
  M._asynctask_mapping = nil
end

-- TODO(meijieru): honor more options?
-- silent, close, hidden
function M.runner(cmd, dir, mapping)
  M.reset()
  M._asynctask_term = terminal:new {
    cmd = cmd,
    dir = dir,
    close_on_exit = false,
    hidden = true,
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
  }

  function M._asynctask_term_toggle()
    M._asynctask_term:toggle()
  end

  M._asynctask_term_toggle()
  M._asynctask_mapping = mapping or M.settings.mapping
  vim.api.nvim_set_keymap(
    "n",
    M._asynctask_mapping,
    "<cmd>lua require('site.bundle.asynctasks')._asynctask_term_toggle()<CR>",
    { noremap = true, silent = true }
  )
end

return M
