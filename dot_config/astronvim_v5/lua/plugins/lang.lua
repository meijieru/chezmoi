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
    config = function(_, _)
      require("dap-python").setup(vim.env.MASON .. "/bin/debugpy-adapter")
    end,
    specs = {
      "mfussenegger/nvim-dap",
      optional = true,
      dependencies = "mfussenegger/nvim-dap-python",
    },
  },

  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "codecompanion" },
      code = {
        sign = false,
      },
      overrides = {
        buftype = {
          nofile = {
            code = {
              border = "hide",
              style = "normal",
              -- TODO(meijieru): no shadow in hover window. How about codecopmanion?
              highlight = "",
            },
          },
        },
        filetype = {
          -- https://github.com/olimorris/codecompanion.nvim/discussions/1638#discussioncomment-13484618
          -- https://github.com/olimorris/codecompanion.nvim/discussions/1638#discussioncomment-13532012
          codecompanion = {
            heading = {
              -- icons = { "󰪥 ", "  ", " ", " ", " ", "" },
              custom = {
                codecompanion_input = {
                  pattern = "^## Me$",
                  icon = " ",
                },
              },
            },
            html = {
              tag = {
                buf = { icon = " ", highlight = "CodeCompanionChatVariable" },
                file = { icon = " ", highlight = "CodeCompanionChatVariable" },
                help = { icon = "󰘥 ", highlight = "CodeCompanionChatVariable" },
                image = { icon = " ", highlight = "CodeCompanionChatVariable" },
                symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
                url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
                var = { icon = " ", highlight = "CodeCompanionChatVariable" },
                tool = { icon = " ", highlight = "CodeCompanionChatTool" },
                user_prompt = { icon = " ", highlight = "CodeCompanionChatTool" },
                group = { icon = " ", highlight = "CodeCompanionChatToolGroup" },
              },
            },
          },
        },
      },
    },
  },
}
