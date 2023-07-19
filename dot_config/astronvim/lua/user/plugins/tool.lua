return {

  { import = "astrocommunity.media.vim-wakatime" },
  {
    "vim-wakatime",
    cond = not require("core.utils").is_neovide(),
  },
}
