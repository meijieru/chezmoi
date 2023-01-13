local M = {}

local Log = require "core.log"

function M.root_dir(fname)
  return require("lspconfig.util").root_pattern(unpack(myvim.root_markers))(fname) or vim.loop.cwd()
end

--- Toggle diagnostics
--- @param bufnr number | nil
--- @param namespace number | nil
function M.toggle_diagnostics(bufnr, namespace)
  if vim.diagnostic.is_disabled == nil then
    Log:warn "toggle_diagnostics skipped"
  end
  if vim.diagnostic.is_disabled(bufnr, namespace) then
    vim.diagnostic.enable(bufnr, namespace)
  else
    vim.diagnostic.disable(bufnr, namespace)
  end
end

return M
