local M = {}

function M.setup()
  lvim.builtin.dap.active = true

  lvim.lsp.null_ls.setup = {
    root_dir = require("lspconfig").util.root_pattern(unpack(myvim.root_markers)),
  }
end

return M
