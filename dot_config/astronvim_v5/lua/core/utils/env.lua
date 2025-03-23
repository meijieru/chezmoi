local M = {}

function M.neovide_setup(opts)
  opts = vim.tbl_deep_extend("force", {
    neovide_scroll_animation_length = 0.1,
    neovide_fullscreen = true,
    neovide_scale_factor = 1.0,
  }, opts or {})
  for key, value in pairs(opts) do
    vim.g[key] = value
  end
end

return M
