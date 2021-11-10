local escape = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.enhance_align = function()
  if not packer_plugins["vim-easy-align"].loaded then
    vim.cmd [[packadd vim-easy-align]]
  end
  return escape "<Plug>(EasyAlign)"
end

vim.api.nvim_set_keymap("n", "ga", "v:lua.enhance_align()", { expr = true })
vim.api.nvim_set_keymap("x", "ga", "v:lua.enhance_align()", { expr = true })
