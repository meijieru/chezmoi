local utils = require "core.utils"
local Log = require "core.log"

local function dap_config()
  if not utils.is_dap_debugger_installed "python" then
    return
  end
  local status_dap_python_ok = utils.load_pack "nvim-dap-python"
  if not status_dap_python_ok then
    return
  end

  if require("dap").adapters.python ~= nil then
    Log:debug "python dap already loaded"
    return
  end
  local dbg_path = require("dap-install.config.settings").options["installation_path"] .. "python/bin/python"
  require("dap-python").setup(dbg_path, {
    console = nil,
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
  })
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

dap_config()
null_ls_config()

if myvim.plugins.lsp.ciderlsp then
  require("lvim.lsp.manager").setup "ciderlsp"
end
