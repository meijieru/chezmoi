-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  { "BufWritePost", "~/.local/share/chezmoi/*", "lua require('core.utils').chezmoi_apply()" },
  -- HACK(meijieru): postpone keymap settings, otherwise may not take effects
  -- { "VimEnter", "*", "lua require('core.keymap').post_setup()" },

  -- disable fold
  { "FileType", "alpha,lspinfo,aerial", "setlocal nofoldenable" },
}
