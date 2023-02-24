local M = {}

local utils = require "core.utils"
local Log = require "core.log"
local config_name = ".vim/remote.json"

---@class remote.RemoteConfig
---@field hosts string[]
---@field targetdir string
---@field expdir string?

--- Get the config path when available
---@return string?
function M.get_remote_config_path()
  local cwd = vim.loop.cwd()
  local file = join_paths(cwd, config_name)
  local status, _ = pcall(vim.loop.fs_stat, file)
  if status then
    return file
  end
end

local _remote_config_cache = {}

function M.reset_cache()
  _remote_config_cache = {}
end

--- Get the remote config, use cached value if available
---@return remote.RemoteConfig?
function M.get_remote_config()
  local remote_config_path = M.get_remote_config_path()
  if remote_config_path ~= nil then
    if vim.tbl_contains(_remote_config_cache, remote_config_path) then
      Log:debug "use cached remote config"
      return _remote_config_cache[remote_config_path]
    end
    Log:debug "read remote config"
    local config = utils.read_json(remote_config_path)
    _remote_config_cache[remote_config_path] = config
    return config
  end
end

return M
