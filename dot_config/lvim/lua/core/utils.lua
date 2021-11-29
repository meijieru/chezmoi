local M = {}

local Log = require "lvim.core.log"

function M.load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

function M.safe_load(name)
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

function M.is_dap_debugger_installed(name)
  if not lvim.builtin.dap.active then
    return false
  end

  local status, _ = M.safe_load "dap-install"
  if not status then
    Log:info "Plugin dap_install not installed"
    return false
  end

  local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()
  if not vim.tbl_contains(dbg_list, name) then
    Log:info("Debugger " .. name .. " not installed")
    return false
  end

  return true
end

return M
