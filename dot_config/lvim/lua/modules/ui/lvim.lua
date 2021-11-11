local M = {}

function M.setup()
  lvim.builtin.bufferline.active = false

  lvim.builtin.lualine.style = "lvim"
  lvim.builtin.lualine.options.disabled_filetypes = { "toggleterm", "dashboard", "terminal" }

  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.show_icons.git = 0

  lvim.builtin.dashboard.active = true
  lvim.builtin.terminal.active = true
end

return M
