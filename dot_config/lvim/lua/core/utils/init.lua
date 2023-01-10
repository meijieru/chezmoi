local M = {}

local Log = require "core.log"

--- Source vimscript relative to cur dir
--- @param path string
function M.load_vimscript(path)
  vim.cmd.source(vim.fn.expand "~/.config/lvim/" .. path)
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
  if not myvim.plugins.dap.active then
    return false
  end

  local status, _ = M.safe_load "mason"
  if not status then
    Log:info "Plugin mason not installed"
    return false
  end

  local mason_registry = require "mason-registry"
  local status, _ = pcall(mason_registry.get_package, name)
  if not status then
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
  -- luacheck: push ignore 631
  vim.cmd [[
    AsyncRun -post=lua\ require("core.utils").asyncrun_notify("Chezmoi\ apply:\ ") -silent -raw=1 chezmoi apply --source-path %
  ]]
  -- luacheck: pop
end

--- Load package.
--- @param package string #Dirname of the package.
--- @param opts any #table|nil Additional options
---    - skip_packer (boolean|nil) #Use packer if true.
--- @return boolean #true if success.
function M.load_pack(package, opts)
  vim.validate {
    package = { package, "string" },
    opts = { opts, "table", true },
  }
  opts = opts or {}
  local skip_packer = opts.skip_packer or false

  if skip_packer then
    local status = vim.cmd.packadd(package)
    if not status then
      Log:warn(package .. " fails to load")
    end
    return false
  else
    vim.cmd(string.format("Lazy load %s", package))
    return true
  end
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
  local parts = vim.split(url, "/")
  return parts[#parts]
end

--- Shortens path by turning apple/banana/orange -> a/b/orange
--- @param path string
--- @param len_target number
--- @return string
function M.shorten_path(path, len_target)
  local function count(base, pattern)
    return select(2, string.gsub(base, pattern, ""))
  end
  local function shorten_path_step(_path, sep)
    -- ('([^/])[^/]+%/', '%1/', 1)
    return _path:gsub(string.format("([^%s])[^%s]+%%%s", sep, sep, sep), "%1" .. sep, 1)
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

--- Check is in neovide gui
--- @return boolean
function M.is_neovide()
  return vim.g.neovide ~= nil
end

--- Check whether in google env
--- @return boolean
function M.is_google()
  return vim.fn.filereadable "/google/bin/releases/cider/ciderlsp/ciderlsp" == 1
end

--- Get content of current visual selection
--- @return string
function M.get_visual_selection()
  -- https://github.com/neovim/neovim/pull/13896
  local visual_modes = {
    v = true,
    V = true,
    -- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
  }
  -- Return if not in visual mode
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    Log:error "not in visual mode"
    return
  end

  vim.cmd.normal { '"zy', bang = true }
  local content = vim.fn.getreg "z"
  return content
end

return M
