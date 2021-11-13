vim.g.root_markers = { ".git", ".root", ".project", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" }

require("core").setup()

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  { "BufWritePost", "~/.local/share/chezmoi/*", "!chezmoi apply --source-path %" },
  -- HACK(meijieru): postpone keymap settings, otherwise may not take effects
  { "VimEnter", "*", "lua require('keymap').setup()" },
}
