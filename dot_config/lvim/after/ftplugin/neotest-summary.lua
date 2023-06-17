local opts = {
  foldcolumn = "0",
  signcolumn = "no",
}
for key, value in pairs(opts) do
  vim.api.nvim_set_option_value(key, value, { scope = "local", win = 0 })
end
vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = 0, desc = "Close" })
