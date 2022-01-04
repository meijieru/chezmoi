local M = {}

local Log = require "core.log"

--- Source vimscript relative to cur dir
--- @param path string
function M.load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

--- Try load package, logging if failed
--- @param name string
--- @return table tuple of status & module
function M.safe_load(name)
  local status_ok, module = pcall(require, name)
  if not status_ok then
    Log:warn("Failed loading module: " .. name)
  end
  return status_ok, module
end

--- Check whether dap debugger installed
--- @param name string
--- @return boolean
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

--- AsyncrRun customized notify hook
--- @param prefix string
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

--- Load package.
--- @param package string #Dirname of the package.
--- @param opts any #table|nil Additional options
---    - skip_packer (boolean|nil) #Use packer if true.
---    - profile (boolean|nil) #Profile if true.
--- @return boolean #true if success.
function M.load_pack(package, opts)
  vim.validate {
    package = { package, "string" },
    opts = { opts, "table", true },
  }
  opts = opts or {}
  local profile = myvim.profile.enable or (opts.profile or false)
  local skip_packer = opts.skip_packer or false

  -- NOTE: According to the following doc, must be after `packer_compiled.lua` is loaded
  -- https://github.com/wbthomason/packer.nvim/blob/db3c3e3379613443d94e677a6ac3f61278e36e47/README.md#checking-plugin-statuses
  if not skip_packer and packer_plugins[package] == nil then
    Log:warn(package .. " doens't exist")
    return false
  end
  if myvim.profile.infos[package] and myvim.profile.infos[package].loaded then
    Log:debug(package .. " already loaded")
    return true
  end

  local packadd_cmd = "PackerLoad "
  if skip_packer then
    packadd_cmd = "packadd "
  end
  local infos = { loaded = true }
  if profile then
    local start = vim.loop.hrtime()
    vim.cmd(packadd_cmd .. package)
    infos["load_time"] = (vim.loop.hrtime() - start) / 1e6
  else
    vim.cmd(packadd_cmd .. package)
  end
  myvim.profile.infos[package] = infos
  Log:debug(package .. " loaded")
  return true
end

--- Ensure package is loaded before func
--- @param package string
--- @param func function
--- @return any
function M.ensure_loaded_wrapper(package, func)
  return function(...)
    M.load_pack(package)
    return func(...)
  end
end

--- Get plugin base dir.
--- @param url string
--- @return string
function M.get_plugin_dir(url)
  local parts = vim.fn.split(url, "/")
  return parts[#parts]
end

local function shorten_path_step(path, sep)
  -- ('([^/])[^/]+%/', '%1/', 1)
  return path:gsub(string.format("([^%s])[^%s]+%%%s", sep, sep, sep), "%1" .. sep, 1)
end

--- Shortens path by turning apple/banana/orange -> a/b/orange
--- @param path string
--- @param len_target number
--- @return string
function M.shorten_path(path, len_target)
  local function count(base, pattern)
    return select(2, string.gsub(base, pattern, ""))
  end

  local data = path
  local path_separator = package.config:sub(1, 1)
  for _ = 0, count(data, path_separator) do
    if #data > len_target then
      data = shorten_path_step(data, path_separator)
    end
  end
  return data
end

--- Check is in vscode gui
--- @return boolean
function M.is_vscode()
  return vim.g.vscode ~= nil
end

return M
