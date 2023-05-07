local remote = require "core.utils.remote"

local config = remote.get_remote_config()
if config == nil or config.expdir == nil then
  return {}
end

return {
  name = "sync_exp",
  priority = 50,
  params = {
    preset = { type = "enum", default = "_all", choices = { "_all", unpack(config.hosts) } },
  },
  builder = function(params)
    local hosts
    if params.preset == "_all" then
      hosts = table.concat(config.hosts, " ")
    else
      hosts = params.preset
    end
    return {
      cmd = { "sync_exp" },
      args = {
        hosts,
        config.targetdir,
        config.expdir,
        config.local_expdir or config.expdir,
      },
      name = string.format("sync %s", params.preset),
    }
  end,
  condition = {
    callback = function(_)
      return remote.get_remote_config_path() ~= nil and remote.get_remote_config().expdir ~= nil
    end,
  },
}
