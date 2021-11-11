vim.g.root_markers = { ".git", ".root", ".project", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" }

local function disable_distribution_plugins()
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

function _G._my_load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox-material"
lvim.leader = "space"

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

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- Additional Plugins
lvim.plugins = load_plugins()

require "machine_specific"

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  { "BufWritePost", "~/.local/share/chezmoi/*", "!chezmoi apply --source-path %" },
  -- HACK(meijieru): postpone keymap settings, otherwise may not take effects
  { "VimEnter", "*", "lua require('keymap').setup()" },
}
