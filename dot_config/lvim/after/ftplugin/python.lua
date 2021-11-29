local Log = require "lvim.core.log"

local function dap_install_config()
  if not require("core.utils").is_dap_debugger_installed "python" then
    return
  end

  local dap_install = require "dap-install"
  local opt = {
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
    configurations = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local venv_path = os.getenv "VIRTUAL_ENV"
          if venv_path then
            local util_sys = require "dap-install.utils.sys"
            if util_sys.is_windows() then
              return venv_path .. "\\Scripts\\python.exe"
            end
            return venv_path .. "/bin/python"
          end

          return "python3"
        end,
      },
    },
  }
  dap_install.config("python", opt)
end

local function null_ls_config()
  local safe_load = require("core.utils").safe_load
  local status_ok, nls = safe_load "null-ls"
  if not status_ok then
    return
  end

  local methods = require "null-ls.methods"
  local my_nls_python = nls.builtins.formatting.black
  if type(my_nls_python.method) == "table" then
    Log:warn "Remove these block, use null-ls black"
  else
    my_nls_python.method = { methods.internal.FORMATTING, methods.internal.RANGE_FORMATTING }
  end

  nls.register {
    -- order matters
    sources = {
      my_nls_python,
      nls.builtins.formatting.isort.with { extra_args = { "--profile", "black" } },
    },
  }
end

dap_install_config()
null_ls_config()
