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
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    -- order matters
    { exe = "black" },
    -- { exe = "yapf" },
    { exe = "isort", extra_args = { "--profile", "black" } },
  }
end

dap_install_config()
null_ls_config()
