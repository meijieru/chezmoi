_G.myvim = {
  root_markers = { ".git", ".root", ".project", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  ignores = {
    buftype = { "quickfix", "nofile", "help", "terminal" },
    filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  },
  profile = {
    enable = false,
    infos = {},
  },

  colorscheme_enable_italic = false,
  colorscheme_enable_italic_comment = true,

  plugins = {
    tabnine = { active = false },

    treesitter = {
      ensure_installed = {},
    },

    imtoggle = { active = false },
  },
}
