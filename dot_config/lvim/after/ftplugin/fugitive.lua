local function keymap_config()
  local mapx = require "mapx"
  local keymap = require "core.keymap"

  mapx.nnoremap("q", "<cmd>close<cr>", mapx.silent, mapx.buffer)
  -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
  mapx.nnoremap("dt", keymap.chain("Gtabedit", "normal dv"), "Tab Diff")
end

keymap_config()
