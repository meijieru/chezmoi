local M = {}

function M.setup()
  lvim.builtin.dap.active = true

  lvim.lsp.null_ls.setup = {
    root_dir = function(fname)
      return require("lspconfig").util.root_pattern(unpack(myvim.root_markers))(fname) or vim.fn.getcwd()
    end,
  }
end

return M
