if not myvim.plugins.is_development_machine then return {} end

-- enable servers that you already have installed without mason
return {
  "pyright",
  "ruff_lsp",
  "clangd",
  "lua_ls",
}
