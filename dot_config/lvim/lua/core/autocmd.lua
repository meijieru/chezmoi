-- Autocommands (https://neovim.io/doc/user/autocmd.html)

lvim.autocommands._alpha = nil
lvim.autocommands._markdown = nil
lvim.autocommands.custom_groups = {
  -- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  { "BufWritePost", "~/.local/share/chezmoi/*", "lua require('core.utils').chezmoi_apply()" },
  -- disable fold
  { "FileType", "alpha,lspinfo,aerial,dapui_scopes", "setlocal nofoldenable" },
}
