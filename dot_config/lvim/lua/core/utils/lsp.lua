local M = {
  _diagnostics_active = true,
}

local Log = require "core.log"

function M.root_dir(fname)
  return require("lspconfig.util").root_pattern(unpack(myvim.root_markers))(fname) or vim.fn.getcwd()
end

function M.lsp_config(server_name, automatic_servers_installation)
  automatic_servers_installation = automatic_servers_installation or false

  local lsp_installer_servers = require "nvim-lsp-installer.servers"
  local server_available, requested_server = lsp_installer_servers.get_server(server_name)
  if server_available then
    requested_server:on_ready(function()
      local opts = { root_dir = M.root_dir }
      requested_server:setup(opts)
    end)
    if (not requested_server:is_installed()) and automatic_servers_installation then
      requested_server:install()
    end
  else
    Log:info(server_name .. " not available")
  end
end

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
function M.format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end

function M.toggle_diagnostics()
  if M._diagnostics_active then
    vim.diagnostic.disable(0)
    M._diagnostics_active = false
  else
    vim.diagnostic.enable(0)
    M._diagnostics_active = true
  end
end

return M
