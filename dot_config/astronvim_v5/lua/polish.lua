-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local normal_command = require("core.utils.keymap").normal_command

local api = vim.api
local map = vim.keymap.set
local on = vim.api.nvim_create_autocmd

-- TODO(meijieru): use https://github.com/xvzc/chezmoi.nvim instead
-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
on("BufWritePost", {
  pattern = { "*/.local/share/chezmoi/*" },
  callback = function(env)
    local opts = { title = "Chezmoi Apply" }
    if vim.system == nil then
      vim.notify_once("Chezmoi apply require nvim 0.10+, skipped", vim.log.levels.WARN, opts)
      return
    end

    local file = env.file
    local path = require("plenary.path")
    local relpath = path:new(file):make_relative()
    if vim.startswith(file, "fugitive:///") or vim.startswith(file, "oil:///") or vim.startswith(relpath, ".git") then
      return
    end

    vim.system({ "chezmoi", "apply", "--source-path", file }, { text = true }, function(obj)
      if obj.code == 0 and obj.signal == 0 then
        vim.notify(string.format("Done: %s", relpath), vim.log.levels.INFO, opts)
        return
      end
      local info = table.concat(vim.split(obj.stderr, ":"), ":", 2):gsub("\n$", "")
      vim.notify(info, vim.log.levels.ERROR, opts)
    end)
  end,
  desc = "Trigger chezmoi apply",
})

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

-- TODO(meijieru): temp solution until https://github.com/folke/lazydev.nvim/pull/96
local clientes_soportados = { "lua_ls", "emmylua_ls" }
---@param cliente vim.lsp.Client
local function emmylua_ls_soportado(cliente)
  return cliente and vim.tbl_contains(clientes_soportados, cliente.name)
end
require("lazydev.lsp").supports = emmylua_ls_soportado
