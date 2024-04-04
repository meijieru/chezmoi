return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon
    opts.signs.topdelete = { text = get_icon "GitSignTopDelete" }
  end,
}
