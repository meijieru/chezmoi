return {
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
  enabled = vim.fn.has "nvim-0.10" == 0,
}
