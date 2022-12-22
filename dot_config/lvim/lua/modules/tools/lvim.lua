local M = {}

function M.setup_telescope()
  lvim.builtin.telescope.active = myvim.plugins.telescope.active
  if not myvim.plugins.telescope.active then
    return
  end

  lvim.builtin.telescope.defaults.mappings.i["<C-w>"] = function()
    vim.cmd.normal { 'b"zcw', bang = true }
  end
  -- useful defalt:
  -- <C-/> Show mappings for picker actions (insert mode)
  -- ? Show mappings for picker actions (normal mode)
  lvim.builtin.telescope.defaults.mappings.n["g?"] = "which_key"
  lvim.builtin.telescope.defaults.layout_config = {
    width = 0.8,
  }
  lvim.builtin.telescope.theme = myvim.plugins.telescope.theme
end

function M.setup()
  M.setup_telescope()
end

return M
