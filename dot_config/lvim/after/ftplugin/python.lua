local utils = require "core.utils"
local Log = require "core.log"

local function dap_config()
  local debugger_name = "debugpy"
  if not utils.is_dap_debugger_installed(debugger_name) then
    return
  end
  local status_dap_python_ok, dap_python = utils.safe_load "dap-python"
  if not status_dap_python_ok then
    return
  end

  if require("dap").adapters.python ~= nil then
    Log:debug "python dap already loaded"
    return
  end

  local dbg_path = require("mason-registry").get_package(debugger_name):get_install_path() .. "/venv/bin/python"
  Log:debug("python dap use: " .. dbg_path)
  dap_python.setup(dbg_path, {
    console = nil,
    pythonPath = function()
      local venv_path = os.getenv "VIRTUAL_ENV"
      if venv_path then
        local is_windows = vim.loop.os_uname().version:match "Windows"
        if is_windows then
          return venv_path .. "\\Scripts\\python.exe"
        end
        return venv_path .. "/bin/python"
      end
      return "python3"
    end,
  })
end

local function null_ls_config()
  local formatters = require "lvim.lsp.null-ls.formatters"
  local null_ls = require "null-ls"
  formatters.setup {
    -- order matters
    { exe = "black" },
    { exe = "isort", extra_args = { "--profile", "black", "--force_sort_within_sections" } },
    -- only for range format
    { exe = "yapf", method = null_ls.methods.RANGE_FORMATTING },
  }
end

dap_config()
null_ls_config()

require("lvim.lsp.manager").setup "ruff_lsp"

if myvim.lsp.ciderlsp then
  require("lvim.lsp.manager").setup "ciderlsp"
end
