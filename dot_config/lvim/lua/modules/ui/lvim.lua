local M = {}

function M.setup_lualine()
  local background = vim.opt.background:get()
  local components = require "lvim.core.lualine.components"
  local scrollbar = components.scrollbar

  local function _sainnhe_palettes(name)
    name = name:gsub("-", "_")
    local palette = nil
    local configuration = vim.fn[name .. "#get_configuration"]()
    if name == "gruvbox_material" then
      palette = vim.fn[name .. "#get_palette"](background, configuration.palette)
      return {
        bg = palette.bg1[1],
        fg = palette.fg1[1],
      }
    elseif name == "edge" then
      palette = vim.fn[name .. "#get_palette"](configuration.style)
      return { bg = palette.bg1[1], fg = palette.fg[1] }
    elseif name == "everforest" then
      palette = vim.fn[name .. "#get_palette"](configuration.background)
      return { bg = palette.bg1[1], fg = palette.fg[1] }
    end
  end

  local function _my_palettes(name)
    local utils = require "core.utils"
    if name == "edge_lush" then
      local palette = require "lush_theme.palette"
      return vim.tbl_map(function(hsl)
        return tostring(hsl):lower()
      end, { bg = palette.bg1, fg = palette.grey_dim })
    end
  end

  local function safe_get_palettes(name)
    local status, value
    if name == "edge_lush" then
      status, value = pcall(_my_palettes, name)
    else
      status, value = pcall(_sainnhe_palettes, name)
    end
    if status then
      return value
    else
      return scrollbar.color
    end
  end

  scrollbar.color = safe_get_palettes(lvim.colorscheme)
  lvim.builtin.lualine.sections.lualine_z = { scrollbar }

  local diff = components.diff
  -- the original symbol behaves wired
  diff.symbols = { added = "  ", modified = " ", removed = " " }
  lvim.builtin.lualine.sections.lualine_c = { diff, components.python_env }
  -- table.insert(lvim.builtin.lualine.sections.lualine_x, components.encoding)

  local lsp = components.lsp
  lsp.color = {}
  lvim.builtin.lualine.sections.lualine_x = {
    components.diagnostics,
    components.treesitter,
    lsp,
    components.filetype,
  }
  lvim.builtin.lualine.sections.lualine_y = { "encoding" }

  lvim.builtin.lualine.style = "lvim"
  lvim.builtin.lualine.options.disabled_filetypes = { "toggleterm", "dashboard", "terminal", "NvimTree", "Outline" }
end

function M.setup()
  lvim.builtin.bufferline.active = false

  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.show_icons.git = 0
  lvim.builtin.nvimtree.quit_on_open = 1

  -- lvim.builtin.dashboard.active = true
  lvim.builtin.alpha.mode = "startify"
  lvim.builtin.terminal.active = true

  lvim.builtin.gitsigns.opts.signs.delete.text = "▎"
  lvim.builtin.gitsigns.opts.signs.topdelete.text = "▔"

  lvim.builtin.terminal.execs = {}

  M.setup_lualine()
end

return M
