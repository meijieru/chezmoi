local uv = vim.uv or vim.loop
local overseer = require "overseer"
local remote = require "core.utils.remote"

local lsyncd_tmpl_path = vim.fs.normalize "~/.config/lsyncd/ssh_tmpl.lua"
local tmpl = {
  priority = 52,
  params = {
    env = {},
    name = {},
  },
  builder = function(params)
    return {
      cmd = { "lsyncd", lsyncd_tmpl_path },
      env = params.env,
      name = params.name,
      components = { "status_only" },
    }
  end,
}

return {
  generator = function(_, cb)
    local config = remote.get_remote_config()
    if config == nil then return {} end

    local cwd = uv.cwd()
    local ret = {}
    for _, host in ipairs(config.hosts) do
      local name = "lsyncd " .. host
      ret[#ret + 1] = overseer.wrap_template(tmpl, {
        -- name in selection
        name = name,
      }, {
        -- name in task list
        name = name,
        env = { HOST = host, SOURCE = cwd, TARGETDIR = config.targetdir },
      })
    end
    cb(ret)
  end,
  condition = {
    callback = function(_) return remote.get_remote_config_path() ~= nil end,
  },
}
