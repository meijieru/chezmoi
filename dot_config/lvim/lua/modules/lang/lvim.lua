local M = {}

function M.setup_null_ls()
  lvim.lsp.null_ls.setup = {
    root_dir = require("modules.completion.lsp").root_dir,
  }

  local code_actions = require "lvim.lsp.null-ls.code_actions"
  code_actions.setup {
    -- general sources, ft plugins check `after/ftplugin`
    { name = "gitsigns" },
  }
end

function M.setup()
  lvim.builtin.dap.active = myvim.plugins.dap.active

  lvim.builtin.treesitter.highlight.is_supported = function(lang)
    return require("nvim-treesitter.query").has_highlights(lang)
  end

  M.setup_null_ls()
end

return M
