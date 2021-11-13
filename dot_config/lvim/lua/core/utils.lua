local M = {}

function M.load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

return M
