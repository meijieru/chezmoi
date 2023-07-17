_G.myvim = {
  log = {
    level = "info",
  },
  colorscheme = {
    name = "catppuccin",
    background = "light",
    enable_italic = true,
    enable_italic_comment = true,
    dim_inactive_windows = false,
    diagnostic_virtual_text = "grey",
    show_eob = false,
  },
  root_markers = { ".git", ".root", ".project", "BUILD", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

  ignores = {
    buftype = { "quickfix", "nofile", "help", "terminal" },
    filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
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
      ensured_servers = { "ruff_lsp" },
      ensured_filetypes = { "toml" },
    },
  },

  plugins = {
    -- completion
    copilot = { active = false },
    cmp = { active = true },
    cmp_dap = { active = true },
    lsp_signature = { active = true },

    -- tool
    treesitter = {
      ensure_installed = { "comment", "rst", "regex" },
    },
    imtoggle = { active = false },
    telescope = { active = true, theme = "center" },
    telescope_frecency = { active = true },
    wakatime = { active = true },
    sniprun = { active = false },
    overseer = { active = true },

    -- ui
    indentlines = { active = true },
    aerial = { active = true },
    dressing = { active = true },
    notify = { active = true },
    alpha = {
      active = true,
      theme = "theta",
      show_button = "auto",
    },
    pokemon = { active = true },
    terminal = { active = true },
    bufferline = { active = false },
    gitsigns = { active = true },
    gitlinker = { active = true },
    scrollbar = { active = true },
    nvimtree = { active = false },
    oil = { active = true },
    noice = { active = false },
    breadcrumbs = { active = true },
    neoscroll = { active = false },
    statuscol = { active = true },
    illuminate = { active = true },

    -- editor
    dap = { active = true },
    dap_virtual_text = { active = false },
    neogen = { active = true },
    neotest = { active = true },
    auto_session = { active = false },
    project = { active = true },
    flash = { active = true },
    ufo = { active = true },
    smartyank = { active = true },
    ts_node_action = {
      active = true,
      integrate_with_null_ls = false,
    },

    -- lang
    markdown_preview = { active = true },
  },
}
