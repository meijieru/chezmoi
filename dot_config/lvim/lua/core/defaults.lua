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

  kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },

  colorscheme_enable_italic = false,
  colorscheme_enable_italic_comment = true,

  plugins = {
    tabnine = { active = false },

    treesitter = {
      ensure_installed = {},
    },

    imtoggle = { active = false },

    dressing = { active = true },

    aerial = { active = true },

    telescope_frecency = { active = false },
  },
}
