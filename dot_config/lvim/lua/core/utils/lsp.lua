local M = {
  _diagnostics_active = true,
}

function M.root_dir(fname)
  return require("lspconfig.util").root_pattern(unpack(myvim.root_markers))(fname) or vim.loop.cwd()
end

function M.toggle_diagnostics()
  if M._diagnostics_active then
    vim.diagnostic.disable(0)
    M._diagnostics_active = false
  else
    vim.diagnostic.enable(0)
    M._diagnostics_active = true
  end
end

return M
