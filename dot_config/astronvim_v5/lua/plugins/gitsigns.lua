return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon
    opts.signs.topdelete = { text = get_icon "GitSignTopDelete" }
    opts.signcolumn = false
    opts.numhl = false
    opts.on_attach = nil
  end,
  enabled = true,
}
