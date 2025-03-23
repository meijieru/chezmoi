local normal_command = require("core.utils.keymap").normal_command

return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<Leader>s",
      normal_command "Neotree document_symbols toggle",
      desc = "Symbols",
    },
  },
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon

    opts.default_source = "buffers"
    opts.sources = { "buffers", "document_symbols" }
    local sources = opts.source_selector.sources
    sources[#sources + 1] = { source = "document_symbols", display_name = get_icon("Package", 1, true) .. "Symbols" }
    opts.document_symbols = {
      follow_cursor = false,
      renderers = {
        symbol = {
          { "indent", with_expanders = true },
          { "kind_icon", default = "?" },
          {
            "container",
            content = {
              { "name", zindex = 10 },
            },
          },
        },
      },
    }
    return opts
  end,
}
