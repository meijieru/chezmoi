_G.myvim = {
  log = {
    level = "info",
    override_notify = true,
  },
  colorscheme = "edge_lush",
  colorscheme_enable_italic = false,
  colorscheme_enable_italic_comment = true,
  root_markers = { ".git", ".root", ".project", "BUILD", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

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

  lsp = {
    ciderlsp = false,
    lvim = {
      skipped_servers = {},
    },
  },

  plugins = {
    -- completion
    tabnine = { active = false },
    cmp = { active = true },
    cmp_treesitter = { active = true },

    -- tool
    treesitter = {
      ensure_installed = {},
    },
    imtoggle = { active = false },
    telescope = { active = true, theme = "center" },
    telescope_frecency = { active = false },
    shipwright = { active = true },
    wakatime = { active = true },

    -- ui
    indentlines = { active = true },
    aerial = { active = true },
    sidebar = { active = false },
    dressing = { active = true },
    notify = { active = true },
    alpha = { active = true, theme = "theta" },
    terminal = { active = true },
    bufferline = { active = false },
    gitsigns = { active = true },
    gitlinker = { active = true },
    scrollbar = { active = true },
    nvimtree = { active = true },
    tpipeline = { active = false },
    noice = { active = false },
    breadcrumbs = { active = true },

    -- editor
    dap = { active = true },
    dap_virtual_text = { active = false },
    dap_telescope = { active = true },
    neogen = { active = true },
    spellsitter = { active = false },
    auto_session = { active = false },
    project = { active = true },
    hop = {
      active = true,
      enable_ft = false,
    },
    ufo = { active = true },

    -- lang
    markdown_preview = { active = true },
    rust_tools = { active = false },
  },
}
