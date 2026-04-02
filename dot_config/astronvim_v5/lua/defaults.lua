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
  },
}
