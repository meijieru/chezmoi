local overseer = require("overseer")
local remote = require("core.utils.remote")

local gpu_monitor_dir = "~/lib/gpu-monitor/"

local tmpl = {
  priority = 51,
  params = {
    preset = {},
    name = {},
  },
  builder = function(params)
    return {
      cmd = { "python" },
      cwd = gpu_monitor_dir,
      args = {
        "gpu_monitor.py",
        "--server-file",
        vim.fs.joinpath("servers", params.preset),
      },
      name = params.name,
      components = { "status_only" },
    }
  end,
}

return {
  generator = function(_, cb)
    local ret = {}
    for preset in vim.fs.dir(vim.fs.joinpath(gpu_monitor_dir, "servers")) do
      local name = "check_gpu " .. vim.split(preset, "%.")[1]
      ret[#ret + 1] = overseer.wrap_template(tmpl, {
        -- name in selection
        name = name,
      }, {
        -- name in task list
        name = name,
        preset = preset,
      })
    end
    cb(ret)
  end,
  condition = {
    callback = function(_)
      return remote.get_remote_config_path() ~= nil
    end,
  },
}
