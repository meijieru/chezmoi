local M = {}

local uv = vim.uv or vim.loop
local Log = require "core.log"

--- Source vimscript relative to cur dir
--- @param path string
function M.load_vimscript(path)
  vim.cmd.source(vim.fn.expand "~/.config/lvim/" .. path)
end

--- Try load package, logging if failed
--- @param name string
--- @return boolean, table
function M.safe_load(name)
  local status_ok, module = pcall(require, name)
  if not status_ok then
    Log:warn("Failed loading module: " .. name)
  end
  return status_ok, module
end

M.require_on_index = require("lvim.utils.modules").require_on_index

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
  status, _ = pcall(mason_registry.get_package, name)
  if not status then
    Log:info("Debugger " .. name .. " not installed")
    return false
  end

  return true
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

--- Check whether in wsl env
--- @return boolean
function M.is_wsl()
  return vim.fn.has "wsl" == 1
end

--- Check whether in windows env
--- @return boolean
function M.is_windows()
  return uv.os_uname().version:match "Windows" ~= nil
end

--- Get content of current visual selection
--- @return string?
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

--- Open in other application
--- @param file string
function M.xdg_open(file)
  if vim.fn.has "nvim-0.10" == 0 then
    Log:info "xdg_open requires neovim 0.10 or above"
    return
  end

  vim.system({ "xdg-open", file }, { text = true, timeout = 1000 }, function(obj)
    local opts = { title = "xdg-open" }
    if obj.code == 0 and obj.signal == 0 then
      vim.notify(string.format("Opened: %s", file), "info", opts)
      return
    end
    vim.notify(obj.stderr, "error", opts)
  end)
end

--- Apply chezmoi file
--- @param file string
function M.chezmoi_apply(file)
  local path = require "plenary.path"
  local relpath = path:new(file):make_relative()
  if vim.startswith(file, "fugitive:///") or vim.startswith(relpath, ".git") then
    return
  end

  if vim.fn.has "nvim-0.10" == 0 then
    Log:info "chezmoi_apply requires neovim 0.10 or above"
    return
  end

  vim.system({ "chezmoi", "apply", "--source-path", file }, { text = true }, function(obj)
    local opts = { title = "Chezmoi Apply" }
    if obj.code == 0 and obj.signal == 0 then
      vim.notify(string.format("Done: %s", relpath), "info", opts)
      return
    end
    local info = table.concat(vim.split(obj.stderr, ":"), ":", 2):gsub("\n$", "")
    vim.notify(info, "error", opts)
  end)
end

--- Read the content
---@param fpath string file path
---@return string?
function M.read_file(fpath)
  local file = io.open(fpath, "r")
  local contents
  if file then
    contents = file:read "*all"
    file:close()
    return contents
  else
    return
  end
end

--- Read json
---@param fpath string
---@return table?
function M.read_json(fpath)
  local contents = M.read_file(fpath)
  if contents == nil then
    return nil
  else
    return vim.json.decode(contents)
  end
end

return M
