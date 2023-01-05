local function keymap_config()
  local keymap = require "core.keymap"

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close" })
  -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
  vim.keymap.set("n", "dt", keymap.chain("Gtabedit", "normal dv"), { buffer = true, desc = "Tab Diff" })
end

keymap_config()
