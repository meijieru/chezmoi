-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local normal_command = require("core.utils.keymap").normal_command

local api = vim.api
local map = vim.keymap.set
local on = api.nvim_create_autocmd

on("FileType", {
  pattern = { "startuptime", "fugitiveblame", "gitsigns-blame", "qf", "help" },
  callback = function()
    map("n", "q", normal_command("close"), { buffer = true, desc = "Close" })
  end,
})

on("FileType", {
  pattern = { "lspinfo", "aerial", "dapui_scopes" },
  callback = function()
    api.nvim_set_option_value("foldenable", false, { scope = "local", win = 0 })
  end,
  desc = "Disable fold",
})

on("FileType", {
  pattern = { "lua", "json", "markdown" },
  callback = function()
    vim.notify("set tabstop from filetype plugin", vim.log.levels.DEBUG, { title = "Filetype indent" })
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
  desc = "Filetype indent",
})

on("TextYankPost", {
  group = api.nvim_create_augroup("SmartYankOSC52", { clear = true }),
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", vim.fn.getreg('"'))
    end
  end,
})

-- diable autocmds
local autocmds_to_disable = {}
for _, params in ipairs(autocmds_to_disable) do
  local autocmds = api.nvim_get_autocmds(params)
  for _, autocmd in ipairs(autocmds) do
    api.nvim_del_autocmd(autocmd.id)
  end
end

api.nvim_create_user_command("DiffRemote", function(params)
  local remote = require("core.utils.remote")
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
    local remote = require("core.utils.remote")
    local config = remote.get_remote_config()
    if config ~= nil then
      return config.hosts
    else
      return {}
    end
  end,
})

require("vim._core.ui2").enable({})

vim.lsp.inline_completion.enable()
vim.lsp.enable("copilot")
