local M = {}

function M.setup_null_ls()
  lvim.lsp.null_ls.setup = {
    root_dir = require("core.utils.lsp").root_dir,
  }

  if myvim.plugins.ts_node_action.integrate_with_null_ls then
    require("null-ls").register {
      name = "more_actions",
      method = { require("null-ls").methods.CODE_ACTION },
      filetypes = { "_all" },
      generator = {
        fn = require("ts-node-action").available_actions,
      },
    }
  end
end

function M.setup()
  M.setup_null_ls()
end

return M
