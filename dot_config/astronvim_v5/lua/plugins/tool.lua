return {

  { import = "astrocommunity.media.vim-wakatime" },
  {
    "vim-wakatime",
    cond = not require("core.utils").is_neovide(),
  },

  {
    "kawre/leetcode.nvim",
    lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
    opts = {
      lang = "python3",
    },
    enabled = myvim.plugins.is_development_machine,
  },
}
