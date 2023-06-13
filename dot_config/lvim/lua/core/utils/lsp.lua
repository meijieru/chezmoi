local M = {}

local uv = vim.uv or vim.loop

function M.root_dir(fname)
  return require("lspconfig.util").root_pattern(unpack(myvim.root_markers))(fname) or uv.cwd()
end

--- Toggle diagnostics
--- @param bufnr number | nil
--- @param namespace number | nil
function M.toggle_diagnostics(bufnr, namespace)
  if vim.diagnostic.is_disabled(bufnr, namespace) then
    vim.diagnostic.enable(bufnr, namespace)
  else
    vim.diagnostic.disable(bufnr, namespace)
  end
end

return M
