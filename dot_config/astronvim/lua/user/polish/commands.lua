vim.api.nvim_create_user_command("DiffRemote", function(params)
  local remote = require "core.utils.remote"
  local fpath = vim.api.nvim_buf_get_name(0)
  local remote_path = remote.get_remote_path_for_local(fpath)
  if remote_path ~= nil then
    local remote_url = remote.get_remote_url(params.args, remote_path)
    vim.cmd("vertical diffsplit " .. remote_url)
  else
    vim.notify("Fail to get remote url", "info", { title = "remote" })
  end
end, {
  desc = "Diff remote file",
  nargs = 1,
  complete = function()
    local remote = require "core.utils.remote"
    local config = remote.get_remote_config()
    if config ~= nil then
      return config.hosts
    else
      return {}
    end
  end,
})
