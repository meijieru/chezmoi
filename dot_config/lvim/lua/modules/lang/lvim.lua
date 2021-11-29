local M = {}

function M.setup()
  lvim.builtin.dap.active = true

  lvim.lsp.null_ls.setup = {
    root_dir = require("modules.completion.lsp").root_dir,
  }
end

return M
