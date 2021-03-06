local M = {}

function M.indent_blankline()
  require("indent_blankline").setup {
    char = "|",
    buftype_exclude = myvim.ignores.buftype,
    filetype_exclude = myvim.ignores.filetype,
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    show_current_context = true,
    show_current_context_start = false,
    context_patterns = {
      "class",
      "function",
      "method",
      "block",
      "list_literal",
      "selector",
      "^if",
      "^table",
      "if_statement",
      "while",
      "for",
      "type",
      "var",
      "import",
    },
  }
end

function M.zen_mode()
  require("zen-mode").setup {
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = true }, -- hide the gitsigns
      diagnostics = { enabled = true },
      tmux = { enabled = false },
    },
  }
end

function M.twilight()
  require("twilight").setup {}
end

function M.neoscroll()
  require("neoscroll").setup {
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil, -- Default easing function
    pre_hook = nil, -- Function to run before the scrolling animation starts
    post_hook = nil, -- Function to run after the scrolling animation ends
  }
end

function M.scrollbar()
  require("scrollbar").setup {
    handle = {
      text = " ",
      color = require("core.utils.ui").get_scroll_bar_color(myvim.colorscheme).fg,
    },
  }
end

function M.bqf()
  require("bqf").setup {
    auto_resize_height = false,
  }
end

function M.dressing()
  require("dressing").setup {
    input = {
      -- Default prompt string
      -- default_prompt = "> ",

      -- When true, <Esc> will close the modal
      insert_only = true,

      -- These are passed to nvim_open_win
      border = "rounded",
      winhighlight = "NormalFloat:Normal",

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      prefer_width = 40,
      max_width = nil,
      min_width = 20,
    },
    select = {
      -- Priority list of preferred vim.select implementations
      backend = { "telescope", "fzf", "builtin", "nui" },

      telescope = nil,
    },
  }
end

function M.sidebar()
  require("sidebar-nvim").setup()
end

vim.g.tpipeline_fillcentre = true

vim.g.gruvbox_material_palette = "origin"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_enable_italic = myvim.colorscheme_enable_italic
vim.g.gruvbox_material_disable_italic_comment = not myvim.colorscheme_enable_italic_comment
vim.g.gruvbox_material_show_eob = 1
vim.g.gruvbox_material_better_performance = 1

vim.g.edge_enable_italic = myvim.colorscheme_enable_italic
vim.g.edge_disable_italic_comment = not myvim.colorscheme_enable_italic_comment
vim.g.edge_show_eob = 1
vim.g.edge_better_performance = 1

vim.g.everforest_enable_italic = myvim.colorscheme_enable_italic
vim.g.everforest_disable_italic_comment = not myvim.colorscheme_enable_italic_comment
vim.g.everforest_show_eob = 1
vim.g.everforest_better_performance = 1

require("modules.ui.lvim").setup()

return M
