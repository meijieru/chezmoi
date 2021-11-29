local M = {}

function M.setup()
  lvim.builtin.dap.active = true

  lvim.lsp.null_ls.setup = {
    root_dir = require("modules.completion.lsp").root_dir,
  }

  lvim.builtin.treesitter.highlight.is_supported = function(lang)
    return require("nvim-treesitter.query").has_highlights(lang)
  end
end

return M
