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
    cmp = { active = true },
    cmp_treesitter = { active = true },
    trouble = { active = false },

    -- tool
    treesitter = {
      ensure_installed = {},
    },
    imtoggle = { active = false },
    telescope = { active = true },
    telescope_frecency = { active = false },
    shipwright = { active = true },
    wakatime = { active = true },

    -- ui
    aerial = { active = true },
    sidebar = { active = false },
    dressing = { active = true },
    notify = { active = true },
    alpha = { active = true },
    terminal = { active = true },
    bufferline = { active = false },

    -- editor
    dap_virtual_text = { active = false },
    neogen = { active = true },
    spellsitter = { active = false },
    auto_session = { active = false },
    project = { active = true },

    -- lang
    dap = { active = true },
    markdown_preview = { active = true },
  },
}
