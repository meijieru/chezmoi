local M = {}

local uv = vim.uv

---@class remote.Cache
---@field config_path table
---@field config table

---@type remote.Cache
local _cache

function M.reset_cache()
  _cache = {
    config_path = {},
    config = {},
  }
end
M.reset_cache()

local utils = require("core.utils")
local config_dir_name = ".vim"
local config_name = "remote.json"

---@class remote.RemoteConfig
---@field hosts string[]
---@field targetdir string
---@field expdir string?
---@field local_expdir string?

--- Get the config path when available
---@return string?
function M.get_remote_config_path()
  local cwd = uv.cwd()
  local cache = _cache.config_path
  if cache[cwd] ~= nil then
    vim.notify(
      string.format("use cached remote config path: %s -> %s", cwd, cache[cwd]),
      vim.log.levels.DEBUG,
      { title = "Remote" }
    )
    return cache[cwd]
  end

  local config_dir = vim.fs.find(config_dir_name, { upward = true })[1]
  if config_dir == nil then
    return
  end
  local file = vim.fs.joinpath(config_dir, config_name)
  if vim.fn.filereadable(file) == 1 then
    vim.notify(
      string.format("find remote config file: %s -> %s", cwd, file),
      vim.log.levels.DEBUG,
      { title = "Remote" }
    )
    cache[cwd] = file
    return file
  end
end

--- Get the remote config, use cached value if available
---@return remote.RemoteConfig?
function M.get_remote_config()
  local remote_config_path = M.get_remote_config_path()
  local cache = _cache.config
  if remote_config_path ~= nil then
    if cache[remote_config_path] ~= nil then
      vim.notify(
        string.format("use cached remote config: %s", remote_config_path),
        vim.log.levels.DEBUG,
        { title = "Remote" }
      )
      return cache[remote_config_path]
    end
    vim.notify("read remote config", vim.log.levels.DEBUG, { title = "Remote" })
    local config = utils.read_json(remote_config_path)
    cache[remote_config_path] = config
    return config
  end
end

--- Get the remote url
---@param host string
---@param fpath string
---@param protocol string?
---@return string
function M.get_remote_url(host, fpath, protocol)
  return string.format("%s://%s/%s", protocol or "oil-ssh", host, fpath)
end

--- Get the remote url for local fpath
---@param fpath string
---@return string?
function M.get_remote_path_for_local(fpath)
  local remote_config = M.get_remote_config()
  if remote_config == nil then
    return nil
  end
  local remote_dir = remote_config.targetdir
  local path = require("plenary.path")
  local relpath = path:new(fpath):make_relative()
  return vim.fs.normalize(vim.fs.joinpath(remote_dir, relpath))
end

return M
