local Log = require "core.log"
if vim.api.nvim_create_user_command == nil then
  Log:info "Skip customized commands"
  return
end

local dap_utils = require "core.utils.dap"
vim.api.nvim_create_user_command("MyDapStoreBreakpoints", dap_utils.store, { desc = "Save DAP breakpoints" })
vim.api.nvim_create_user_command("MyDapLoadBreakpoints", dap_utils.load, { desc = "Load DAP breakpoints" })

vim.api.nvim_create_user_command("UpdateAll", function()
  vim.cmd "TSUpdate"
  require("lazy").sync { show = true }
  -- TODO(meijieru): update lsp
end, {
  desc = "Update plugins & lsp & treesitter parsers",
})

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
