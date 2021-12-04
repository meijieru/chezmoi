local function setup_null_ls()
  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup { { exe = "teal" } }
end

local function setup_lsp()
  local lspconfig = require "lspconfig"
  local configs = require "lspconfig/configs"

  local lsp_installer = require "nvim-lsp-installer"
  local server = require "nvim-lsp-installer.server"
  local shell = require "nvim-lsp-installer.installers.shell"

  local name = "teal_language_server"
  local root_dir = server.get_server_root_path(name)

  configs[name] = {
    default_config = {
      cmd = {
        root_dir .. "/bin/teal-language-server",
        -- "logging=on", use this to enable logging in /tmp/teal-language-server.log
      },
      filetypes = { "teal", "tl" },
      root_dir = lspconfig.util.root_pattern("tlconfig.lua", ".git"),
      settings = {},
    },
  }

  local install_cmd = string.format("luarocks install --tree %s --dev teal-language-server", root_dir)
  local tealls = server.Server:new {
    name = name,
    root_dir = root_dir,
    installer = { shell.sh(install_cmd) },
    default_options = {},
  }
  lsp_installer.register(tealls)
end

vim.bo.filetype = "teal"
setup_null_ls()
setup_lsp()

require("modules.completion.lsp").lsp_config("teal_language_server", true)
