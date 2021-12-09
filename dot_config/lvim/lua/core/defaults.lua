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
    -- completion
    tabnine = { active = false },
    cmp_treesitter = { active = true },

    -- tool
    treesitter = {
      ensure_installed = {},
    },
    neogen = { active = true },

    imtoggle = { active = false },
    telescope_frecency = { active = false },

    -- ui
    aerial = { active = true },
    sidebar = { active = false },
    dressing = { active = false },
    notify = { active = true },
  },
}
