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

function M.asyncrun_notify(prefix)
  prefix = prefix or ""
  local status = vim.g.asyncrun_status
  local info_level = {
    running = "info",
    success = "info",
    failure = "warn",
  }
  vim.notify(prefix .. status, info_level[status], { title = "AsyncRun" })
end

function M.chezmoi_apply()
  vim.cmd [[
    AsyncRun -post=lua\ require("core.utils").asyncrun_notify("Chezmoi\ apply:\ ") -silent -raw=1 chezmoi apply --source-path %
  ]]
end

return M
