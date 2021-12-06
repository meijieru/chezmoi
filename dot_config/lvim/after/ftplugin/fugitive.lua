local function keymap_config()
  local mapx = require "mapx"

  mapx.nnoremap("q", "<cmd>close<cr>", mapx.silent, mapx.buffer)
  -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
  mapx.nmap("dt", ":Gtabedit <Plug><cfile><Bar>Gdiffsplit<CR>", mapx.buffer)
end

keymap_config()
