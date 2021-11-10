vim.g.root_markers = { ".svn", ".git", ".root", ".project", ".env", ".vim" }

local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.did_load_filetypes = 1
end

disable_distribution_plugins()

-- speed up startup
-- $ANACONDA_HOME should be set in shell
local anaconda_home = os.getenv "ANACONDA_HOME"
if anaconda_home ~= nil then
  vim.g.python_host_prog = anaconda_home .. "/bin/python2"
  vim.g.python3_host_prog = anaconda_home .. "/bin/python3"
else
  vim.g.python_host_prog = "/usr/bin/python2"
  vim.g.python3_host_prog = "/usr/bin/python3"
end

function _G._my_load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "edge"
lvim.leader = "space"

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.telescope.active = true
lvim.builtin.bufferline.active = false
lvim.builtin.treesitter.ensure_installed = "maintained"

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
lvim.lsp.null_ls.setup = {
  root_dir = require("lspconfig").util.root_pattern(unpack(vim.g.root_markers)),
}

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "yapf" },
  { exe = "prettier" },
  { exe = "stylua", args = { "--search-parent-directories" } },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "black" },
--   {
--     exe = "eslint_d",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "javascriptreact" },
--   },
-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
vim.cmd [[
  autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
]]

local function load_plugins()
  local lvim_config_dir = os.getenv "LUNARVIM_CONFIG_DIR"
  local modules_dir = lvim_config_dir .. "/lua/modules"

  local get_plugins_list = function()
    local list = {}
    local tmp = vim.split(vim.fn.globpath(modules_dir, "*/plugins.lua"), "\n")
    for _, f in ipairs(tmp) do
      list[#list + 1] = f:sub(#modules_dir - 6, -1)
    end
    return list
  end

  local plugins_file = get_plugins_list()
  local plugins = {}
  for _, m in ipairs(plugins_file) do
    local ok, _repos = pcall(require, m:sub(0, #m - 4))
    if not ok then
      print(vim.inspect { ok, m })
    end
    for repo, conf in pairs(_repos) do
      plugins[#plugins + 1] = vim.tbl_extend("force", { repo }, conf)
    end
  end

  return plugins
end

-- Additional Plugins
lvim.plugins = load_plugins()

require "keymap"
require "machine_specific"
