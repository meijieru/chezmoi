local M = {}
local conf = require "modules.completion.config"

M["benfowler/telescope-luasnip.nvim"] = {
  lazy = true,
  config = conf.telescope_luasnip,
  enabled = myvim.plugins.telescope.active,
  dependencies = "telescope.nvim",
}

M["rcarriga/cmp-dap"] = {
  ft = { "dap-repl" },
  config = conf.cmp_dap,
  enabled = (myvim.plugins.cmp.active and myvim.plugins.dap.active and myvim.plugins.cmp_dap.active),
  dependencies = "nvim-cmp",
}

M["zbirenbaum/copilot.lua"] = {
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      ["dap-repl"] = false,
    },
  },
  enabled = myvim.plugins.copilot.active,
  dependencies = "copilot-cmp",
}
M["zbirenbaum/copilot-cmp"] = {
  lazy = true,
  opts = {},
  enabled = myvim.plugins.copilot.active and myvim.plugins.cmp.active,
}

M["ray-x/lsp_signature.nvim"] = {
  lazy = true,
  init = function()
    local augroup = vim.api.nvim_create_augroup("my_lsp_signature", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(args)
        local bufnr = args.buf
        local has_inline = false and vim.fn.has "nvim-0.10" == 1
        require("lsp_signature").on_attach({
          handler_opts = {
            border = "rounded",
          },
          max_width = 100,
          floating_window = not has_inline,
          floating_window_above_cur_line = true,
          hint_enable = has_inline, -- virtual text
          hint_inline = function()
            return has_inline
          end,
          doc_lines = 0,
        }, bufnr)
      end,
    })
  end,
  enabled = myvim.plugins.lsp_signature.active,
}

return M
