local M = {}

function M.setup_null_ls()
  lvim.lsp.null_ls.setup = {
    root_dir = require("core.utils.lsp").root_dir,
  }
end

function M.setup()
  M.setup_null_ls()
end

return M
