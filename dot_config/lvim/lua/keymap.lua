local escape = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.enhance_align()
  if not packer_plugins["vim-easy-align"].loaded then
    vim.cmd [[packadd vim-easy-align]]
  end
  return escape "<Plug>(EasyAlign)"
end

vim.api.nvim_set_keymap("n", "ga", "v:lua.enhance_align()", { expr = true })
vim.api.nvim_set_keymap("x", "ga", "v:lua.enhance_align()", { expr = true })

function _G.set_terminal_keymaps()
  -- TODO(meijieru): `vim-terminal-help` like `drop`
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<M-q>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-l>", [[<C-\><C-n><C-W>l]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

vim.api.nvim_set_keymap("v", "r", "<Plug>SnipRun", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRunOperator", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
