local M = {}

function M.setup()
  lvim.builtin.project.active = true
  lvim.builtin.project.patterns = vim.g.root_markers
  lvim.builtin.project.silent_chdir = false
  -- NOTE(meijieru): lsp sometimes is annoying
  lvim.builtin.project.detection_methods = { "pattern", "lsp" }

  lvim.builtin.treesitter.ensure_installed = "maintained"
end

return M
