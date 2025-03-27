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
}
