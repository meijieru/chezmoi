local M = {}

local Log = require "core.log"
local utils = require "core.utils"

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
    if name == "edge_lush" then
      local palette = require "edge_lush.palette"
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

  local filename = vim.tbl_extend("force", components.filename, {
    path = 1,
    shorting_target = 150,
  })
  lvim.builtin.lualine.sections.lualine_b = { components.branch, filename }
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

function M.setup_nvimtree()
  -- local trash_callback = utils.ensure_loaded_wrapper("nvim-tree.lua", function()
  --   local tree_cb = require("nvim-tree.config").nvim_tree_callback
  --   local cmd = tree_cb "trash"
  --   vim.validate { cmd = { cmd, "string" } }
  --   vim.cmd(cmd)
  -- end)

  lvim.builtin.nvimtree.show_icons.git = 1
  lvim.builtin.nvimtree.quit_on_open = 1

  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.view.mappings.list = {
    -- FIXME(meijieru): revisit after https://github.com/neovim/neovim/pull/16594
    -- { key = "d", cb = trash_callback },
    { key = "<leader>ff", cb = "<cmd>lua require'lvim.core.nvimtree'.start_telescope('find_files')<cr>" },
    { key = "<leader>fg", cb = "<cmd>lua require'lvim.core.nvimtree'.start_telescope('live_grep')<cr>" },
  }

  local trash_cmd = "trash-put"
  if vim.fn.executable(trash_cmd) then
    lvim.builtin.nvimtree.setup.trash = {
      cmd = trash_cmd,
      require_confirm = true,
    }
  else
    Log:warn(trash_cmd .. " not found")
  end
end

function M.setup_notify()
  lvim.builtin.notify.active = myvim.plugins.notify.active
  if not myvim.plugins.notify.active then
    return
  end
  lvim.builtin.notify.opts.stages = "fade_in_slide_out"
  local status_ok, notify = utils.safe_load "notify"
  if not status_ok then
    return
  end
  vim.notify = notify
end

function M.setup_whichkey()
  lvim.builtin.which_key.setup.window.border = "rounded"
  -- lvim.builtin.which_key.setup.plugins.presets.text_objects = true
end

function M.setup()
  lvim.builtin.bufferline.active = myvim.plugins.bufferline.active

  -- lvim.builtin.alpha.mode = "startify"
  lvim.builtin.terminal.active = myvim.plugins.terminal.active

  lvim.builtin.gitsigns.opts.signs.delete.text = "▎"
  lvim.builtin.gitsigns.opts.signs.topdelete.text = "▔"

  lvim.builtin.terminal.execs = {}

  M.setup_whichkey()
  M.setup_lualine()
  M.setup_nvimtree()
  M.setup_notify()
end

return M
