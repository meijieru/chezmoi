local config = {}

local Log = require "core.log"

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

function config.cmp_dap()
  require("cmp").setup {
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
  }

  require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

require("modules.completion.lvim").setup()

return config
