local list_insert_unique = require("astrocore").list_insert_unique

local function get_api_key(name)
  local key = string.format("cmd:gpg --decrypt ~/.local/share/chezmoi/data/encrypted/%s.gpg 2>/dev/null", name)
  return key
end

local function remove_select(list)
  return vim.tbl_filter(function(val) return not vim.tbl_contains({ "select_next", "select_prev" }, val) end, list)
end

local spec = {

  { import = "astrocommunity.completion.blink-cmp" },
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        keymap = {
          ["<Tab>"] = remove_select(opts.keymap["<Tab>"]),
          ["<S-Tab>"] = remove_select(opts.keymap["<S-Tab>"]),
          ["<C-J>"] = { "fallback" },
          ["<C-K>"] = { "fallback" },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal",
          },
        },
        completion = {
          menu = {
            auto_show = true,
            border = "rounded",
            winhighlight = "Normal:Normal",
          },
          documentation = {
            window = {
              border = "rounded",
              winhighlight = "Normal:Normal",
            },
          },
        },
        appearance = {
          kind_icons = {
            Copilot = "",
          },
        },
      })
    end,
  },

  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
    enabled = false,
  },

  -- { import = "astrocommunity.completion.cmp-cmdline" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
}

if myvim.plugins.is_development_machine and not myvim.plugins.is_corporate_machine then
  return vim.list_extend(spec, {

    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          ["dap-repl"] = false,
        },
        copilot_model = "gpt-4o-copilot",
      },
    },
    {
      "Saghen/blink.cmp",
      opts = function(_, opts)
        opts.sources.default = list_insert_unique(opts.sources.default, { "copilot" })
        opts.sources.providers.copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        }
      end,
      dependencies = {
        "fang2hou/blink-copilot",
        -- TODO(meijieru): word/line accept
        opts = {
          max_completions = 2,
          max_attempts = 2,
        },
      },
    },

    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
          "Saghen/blink.cmp",
          opts = function(_, opts) opts.sources.default = list_insert_unique(opts.sources.default, { "codecompanion" }) end,
        },
      },
      opts = {
        strategies = {
          chat = {
            adapter = "deepseek",
          },
          inline = {
            adapter = "deepseek",
          },
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              env = {
                api_key = get_api_key "deepseek_key",
              },
              schema = {
                model = {
                  default = "deepseek-reasoner",
                },
              },
            })
          end,
          siliconflow = function()
            return require("codecompanion.adapters").extend("deepseek", {
              url = "https://api.siliconflow.com/v1/chat/completions",
              env = {
                api_key = get_api_key "siliconflow_key",
              },
              schema = {
                model = {
                  default = "deepseek-ai/DeepSeek-R1",
                },
              },
            })
          end,
        },
      },
      enabled = true,
      lazy = true,
      event = { "InsertEnter", "CmdlineEnter" },
    },
  })
end

return spec
