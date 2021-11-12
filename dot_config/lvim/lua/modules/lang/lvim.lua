local M = {}

function M.setup()
  lvim.builtin.dap.active = true
  lvim.builtin.dap.on_config_done = function()
    local dap_install = require "dap-install"
    local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

    local overrides = {
      python = {
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
            program = "${workspaceFolder}/${file}",
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
      },
    }

    for _, debugger in ipairs(dbg_list) do
      dap_install.config(debugger, overrides[debugger])
    end
  end
end

return M
