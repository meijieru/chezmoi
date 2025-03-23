return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      -- make sure python doesn't get set up by mason-nvim-dap, it's being set up by nvim-dap-python
      opts.handlers = vim.tbl_deep_extend("force", opts.handlers or {}, {
        python = function() end,
      })
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    config = function(_, opts)
      local path = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python"
      require("dap-python").setup(path, opts)
    end,
    specs = {
      "mfussenegger/nvim-dap",
      optional = true,
      dependencies = "mfussenegger/nvim-dap-python",
    },
  },
}
