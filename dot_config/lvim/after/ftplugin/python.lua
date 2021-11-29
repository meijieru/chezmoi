local function dap_install_config()
  if not require("core.utils").is_dap_debugger_installed "python" then
    return
  end

  local opt = {
    adapters = {
      type = "executable",
      command = "python3",
      args = { "-m", "debugpy.adapter" },
    },
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

          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          else
            return "/usr/bin/python3"
          end
        end,
      },
    },
  }

  local dap_install = require "dap-install"
  dap_install.config("python", opt)
end

dap_install_config()
