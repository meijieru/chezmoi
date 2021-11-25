local M = {}

function M.load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

function M.safe_load(name)
  local Log = require "lvim.core.log"

  local status_ok, module = pcall(require, name)
  if not status_ok then
    Log:warn("Failed loading module: " .. name)
  end
  return status_ok, module
end

function M.map(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

return M
