_G.myvim = {
  plugins = {
    machine_specific = {
      is_development_machine = false,
      is_using_corp_lsp = false,
      is_corporate_machine = false,
    },

    lsp = {
      servers_from_system = {},
      ensure_installed = {},
      exclude_from_ensure_installed = {},
    },

    noice = {
      -- if nvim 0.12.0 or later, enable extui
      enabled = not (vim.version().major >= 0 and vim.version().minor >= 12),
    },
  },
}
