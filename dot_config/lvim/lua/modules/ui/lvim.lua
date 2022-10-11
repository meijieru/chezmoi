local M = {}

local Log = require "core.log"

function M.setup_lualine()
  local components = require "lvim.core.lualine.components"

  lvim.builtin.lualine.sections.lualine_b = { components.branch }
  if not myvim.plugins.breadcrumbs.active then
    local filename = vim.tbl_extend("force", components.filename, {
      path = 1,
      shorting_target = 150,
    })
    table.insert(lvim.builtin.lualine.sections.lualine_b, filename)
  end

  -- lvim.builtin.lualine.sections.lualine_y = { "encoding" }
  lvim.builtin.lualine.sections.lualine_y = {}
  lvim.builtin.lualine.sections.lualine_z = { "location" }

  lvim.builtin.lualine.style = "lvim"
  lvim.builtin.lualine.options.disabled_filetypes = { "toggleterm", "dashboard", "terminal", "NvimTree", "Outline" }
  lvim.builtin.lualine.options.globalstatus = true
end

function M.setup_nvimtree()
  lvim.builtin.nvimtree.active = myvim.plugins.nvimtree.active
  if not myvim.plugins.nvimtree.active then
    return
  end

  lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true
  lvim.builtin.nvimtree.setup.view.mappings.list = {
    {
      key = "d",
      action = "trash",
      action_cb = function(node)
        require("nvim-tree.actions.fs.trash").fn(node)
      end,
    },
    {
      key = "<leader>ff",
      action = "telescope_find_files",
      action_cb = function(_)
        require("lvim.core.nvimtree").start_telescope "find_files"
      end,
    },
    {
      key = "<leader>fg",
      action = "telescope_live_grep",
      action_cb = function(_)
        require("lvim.core.nvimtree").start_telescope "live_grep"
      end,
    },
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

function M.setup_alpha()
  lvim.builtin.alpha.active = myvim.plugins.alpha.active
  if not myvim.plugins.alpha.active then
    return
  end

  -- completely override lvim setup
  require("lvim.core.alpha").setup = function()
    local alpha = require "alpha"
    local theme_name = myvim.plugins.alpha.theme
    local theme = require("alpha.themes." .. theme_name)

    if theme.mru_opts ~= nil then
      theme.mru_opts.ignore = function(path, ext)
        local default_mru_ignore = { "gitcommit" }
        return (string.find(path, ".git/")) or (vim.tbl_contains(default_mru_ignore, ext))
      end
    end

    if theme_name == "theta" then
      local dashboard = require "alpha.themes.dashboard"
      local buttons_val = vim.list_slice(theme.buttons.val, 1, 3)
      vim.list_extend(buttons_val, {
        dashboard.button("SPC f f", "  Find file"),
        dashboard.button("SPC f g", "  Live grep"),
        dashboard.button("SPC f P", "  Find project"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      })
      theme.buttons.val = buttons_val
    end
    alpha.setup(theme.config)
  end
end

function M.setup_indent_blankline()
  lvim.builtin.indentlines.active = myvim.plugins.indentlines.active
  if not myvim.plugins.indentlines.active then
    return
  end
  lvim.builtin.indentlines.options.char = "│"
  lvim.builtin.indentlines.options.buftype_exclude = myvim.ignores.buftype
  lvim.builtin.indentlines.options.filetype_exclude = myvim.ignores.filetype
end

function M.setup_breadcrumbs()
  lvim.builtin.breadcrumbs.active = myvim.plugins.breadcrumbs.active
end

function M.setup_illuminate()
  table.insert(lvim.builtin.illuminate.options.filetypes_denylist, "aerial")
end

function M.setup()
  lvim.builtin.bufferline.active = myvim.plugins.bufferline.active
  lvim.builtin.terminal.active = myvim.plugins.terminal.active
  lvim.builtin.terminal.execs = {}

  M.setup_whichkey()
  M.setup_lualine()
  M.setup_nvimtree()
  M.setup_notify()
  M.setup_gitsigns()
  M.setup_alpha()
  M.setup_indent_blankline()
  M.setup_breadcrumbs()
  M.setup_illuminate()
end

return M
