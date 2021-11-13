vim.g.root_markers = { ".git", ".root", ".project", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" }

function _G._my_load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
vim.o.background = "light"
lvim.colorscheme = "gruvbox-material"
lvim.leader = "space"

require("core").setup()

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  { "BufWritePost", "~/.local/share/chezmoi/*", "!chezmoi apply --source-path %" },
  -- HACK(meijieru): postpone keymap settings, otherwise may not take effects
  { "VimEnter", "*", "lua require('keymap').setup()" },
}
