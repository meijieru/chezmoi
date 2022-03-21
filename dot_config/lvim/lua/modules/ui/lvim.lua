local M = {}

local Log = require "core.log"
local utils = require "core.utils"
local ui = require "core.utils.ui"

function M.setup_lualine()
  local components = require "lvim.core.lualine.components"
  local filename = vim.tbl_extend("force", components.filename, {
    path = 1,
    shorting_target = 150,
  })
  lvim.builtin.lualine.sections.lualine_b = { components.branch, filename }

  local scrollbar = components.scrollbar
  scrollbar.color = ui.get_scroll_bar_color(myvim.colorscheme) or scrollbar.color
  lvim.builtin.lualine.sections.lualine_z = { scrollbar }

  lvim.builtin.lualine.sections.lualine_y = { "encoding" }

  lvim.builtin.lualine.style = "lvim"
  lvim.builtin.lualine.options.disabled_filetypes = { "toggleterm", "dashboard", "terminal", "NvimTree", "Outline" }
  lvim.builtin.lualine.options.globalstatus = true
end

function M.setup_nvimtree()
  lvim.builtin.nvimtree.active = myvim.plugins.nvimtree.active
  if not myvim.plugins.nvimtree.active then
    return
  end
  -- local trash_callback = utils.ensure_loaded_wrapper("nvim-tree.lua", function()
  --   local tree_cb = require("nvim-tree.config").nvim_tree_callback
  --   local cmd = tree_cb "trash"
  --   vim.validate { cmd = { cmd, "string" } }
  --   vim.cmd(cmd)
  -- end)

  lvim.builtin.nvimtree.show_icons.git = 1
  lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true

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
  lvim.builtin.notify.opts.stages = "fade"
end

function M.setup_whichkey()
  lvim.builtin.which_key.setup.window.border = "rounded"
  -- lvim.builtin.which_key.setup.plugins.presets.text_objects = true
end

function M.setup_gitsigns()
  lvim.builtin.gitsigns.active = myvim.plugins.gitsigns.active
  if not myvim.plugins.gitsigns.active then
    return
  end
  lvim.builtin.gitsigns.opts.signs.delete.text = "▎"
  lvim.builtin.gitsigns.opts.signs.topdelete.text = "▔"
  lvim.builtin.gitsigns.opts.show_deleted = false
  lvim.builtin.gitsigns.opts.word_diff = false
end

function M.setup()
  lvim.builtin.bufferline.active = myvim.plugins.bufferline.active
  -- lvim.builtin.alpha.mode = "startify"
  lvim.builtin.terminal.active = myvim.plugins.terminal.active
  lvim.builtin.terminal.execs = {}

  M.setup_whichkey()
  M.setup_lualine()
  M.setup_nvimtree()
  M.setup_notify()
  M.setup_gitsigns()
end

return M
