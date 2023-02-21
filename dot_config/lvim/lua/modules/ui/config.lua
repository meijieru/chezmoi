local M = {}

local Log = require "core.log"

function M.notify()
  local notify = require "notify"
  vim.notify = notify

  local opts = {
    render = "default",
    stages = "fade",
    icons = {
      ERROR = lvim.icons.diagnostics.Error,
      WARN = lvim.icons.diagnostics.Warning,
      INFO = lvim.icons.diagnostics.Information,
      DEBUG = lvim.icons.diagnostics.Debug,
      TRACE = lvim.icons.diagnostics.Trace,
    },
  }
  notify.setup(opts)

  local lvim_log = require "lvim.core.log"
  if not myvim.plugins.noice.active then
    lvim_log:configure_notifications(notify)
  end
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
  local scroll_bar_color = require("core.utils.ui").get_scroll_bar_color(myvim.colorscheme.name)
  local fg = nil
  if scroll_bar_color == nil then
    Log:info "scrollbar color not available"
  else
    fg = scroll_bar_color.fg
  end
  require("scrollbar").setup {
    handle = {
      color = fg,
    },
    marks = {
      Error = { highlight = "DiagnosticSignError" },
      Warn = { highlight = "DiagnosticSignWarn" },
      Info = { highlight = "DiagnosticSignInfo" },
      Hint = { highlight = "DiagnosticSignHint" },
    },
    handlers = { gitsigns = myvim.plugins.gitsigns.active },
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
      border = "rounded",
    },
    select = {
      backend = { "telescope", "fzf", "builtin", "nui" },
      telescope = nil,
    },
  }
end

function M.oil()
  require("oil").setup {
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    keymaps = {
      ["."] = "actions.open_cmdline",
    },
    win_options = {
      -- https://github.com/stevearc/oil.nvim/issues/57
      concealcursor = "nc",
    },
  }
end

function M.statuscol()
  require("statuscol").setup {
    setopt = true,
    order = "NSFs",
    foldfunc = "builtin",
  }
end

function M.sainnhe_colorscheme(name)
  vim.g[name .. "_enable_italic"] = myvim.colorscheme.enable_italic
  vim.g[name .. "_disable_italic_comment"] = not myvim.colorscheme.enable_italic_comment
  vim.g[name .. "_show_eob"] = myvim.colorscheme.show_eob
  vim.g[name .. "_dim_inactive_windows"] = myvim.colorscheme.dim_inactive_windows
  vim.g[name .. "_diagnostic_virtual_text"] = myvim.colorscheme.diagnostic_virtual_text
  vim.g[name .. "_better_performance"] = true
end

local sainnhe_colorscheme_names = { "gruvbox_material", "edge", "everforest" }
for _, colorscheme in ipairs(sainnhe_colorscheme_names) do
  M.sainnhe_colorscheme(colorscheme)
end

vim.g.tpipeline_fillcentre = true

require("modules.ui.lvim").setup()

return M
