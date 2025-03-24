return {
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts)
      local filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      }
      opts.filter_kind = filter_kind
      return opts
    end,
    enabled = false,
  },

  { "max397574/better-escape.nvim", enabled = false },
  { "s1n7ax/nvim-window-picker", enabled = false },

  -- TODO(meijieru): remove after v5 release
  { "AstroNvim/astrocore", version = false, branch = "v2" },
  { "AstroNvim/astrolsp", version = false, branch = "v3" },
  { "AstroNvim/astroui", version = false, branch = "v3" },
}
