local M = {}

function M.setup_telescope()
  lvim.builtin.telescope.active = myvim.plugins.telescope.active
  if not myvim.plugins.telescope.active then
    return
  end
  -- useful defalt:
  -- <C-/> Show mappings for picker actions (insert mode)
  -- ? Show mappings for picker actions (normal mode)
  lvim.builtin.telescope.defaults.mappings.n["g?"] = "which_key"
  lvim.builtin.telescope.defaults.layout_config = {
    width = 0.8,
  }
  lvim.builtin.telescope.theme = myvim.plugins.telescope.theme
  lvim.builtin.telescope.pickers.buffers.initial_mode = nil
  lvim.builtin.telescope.pickers.find_files = {
    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
  }
end

function M.setup()
  M.setup_telescope()
end

return M
