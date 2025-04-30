local normal_command = require("core.utils.keymap").normal_command
local get_icon = require("astroui").get_icon
local list_insert_unique = require("astrocore").list_insert_unique

local function get_api_key(name)
  local key = string.format("cmd:gpg --decrypt ~/.local/share/chezmoi/data/encrypted/%s.gpg 2>/dev/null", name)
  return key
end

local function remove_select(list)
  return vim.tbl_filter(function(val)
    return not vim.tbl_contains({ "select_next", "select_prev" }, val)
  end, list)
end

local spec = {

  {
    "Saghen/blink.cmp",
    -- As we disabled the lazy_snapshot from AstroNvim.
    version = "*",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        keymap = {
          -- TODO(meijieru): word/line accept
          ["<Tab>"] = remove_select(opts.keymap["<Tab>"]),
          ["<S-Tab>"] = remove_select(opts.keymap["<S-Tab>"]),
          ["<C-J>"] = { "fallback" },
          ["<C-K>"] = { "fallback" },
        },
        cmdline = { enabled = true },
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
            Copilot = get_icon("Copilot", 0, true),
          },
        },
      })
    end,
  },
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
      specs = {
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
            opts = {
              max_completions = 2,
              max_attempts = 2,
            },
          },
        },
      },
    },

    {
      "ravitemer/mcphub.nvim",
      cmd = "MCPHub",
      build = "bundled_build.lua",
      config = function()
        require("mcphub").setup({
          use_bundled_binary = true,
        })
      end,
    },

    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/mcphub.nvim",
      },
      specs = {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local function prompt(name)
            return function()
              require("codecompanion").prompt(name)
            end
          end
          opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
            n = {
              ["<Leader>a"] = { desc = get_icon("Copilot", 1, true) .. "AI" },
              ["<Leader><Leader>"] = { normal_command("CodeCompanionChat Toggle"), desc = "Toggle Chat" },
              ["<Leader>aa"] = { normal_command("CodeCompanionActions"), desc = "Actions" },
            },
            v = {
              ["<Leader>a"] = { desc = get_icon("Copilot", 1, true) .. "AI" },
              ["<Leader><Leader>"] = { normal_command("CodeCompanionChat Add"), desc = "Add to Chat" },
              ["<Leader>aa"] = { normal_command("CodeCompanionActions"), desc = "Actions" },
              ["<Leader>ae"] = { prompt("explain"), desc = "Explain" },
              ["<Leader>af"] = { prompt("fix"), desc = "Fix" },
              ["<Leader>at"] = { prompt("tests"), desc = "Add Testcases" },
            },
            ca = {
              -- abbr in cmdline
              ["cc"] = { "CodeCompanion" },
            },
          })
        end,
      },
      opts = {
        -- TODO(meijieru):
        -- 1. add https://codecompanion.olimorris.dev/usage/ui.html#heirline-nvim-integration
        -- 2. keymap for refactor
        opts = {
          language = "Simplified Chinese",
        },
        display = {
          diff = {
            provider = "mini_diff",
          },
          action_palette = {
            opts = {
              show_default_prompt_library = true,
              show_default_actions = true,
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },
        },
        adapters = {
          opts = {
            show_defaults = false,
          },
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "openrouter",
              formatted_name = "OpenRouter",
              env = {
                api_key = get_api_key("openrouter_key"),
                url = "https://openrouter.ai/api",
              },
              schema = {
                model = {
                  default = "deepseek/deepseek-chat-v3-0324:free",
                },
              },
            })
          end,
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              -- use copilot.lua token
              schema = {
                model = {
                  default = "gemini-2.5-pro",
                },
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              env = {
                api_key = get_api_key("deepseek_key"),
              },
              schema = {
                model = {
                  default = "deepseek-chat",
                },
              },
            })
          end,
          deepseek_siliconflow = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = get_api_key("siliconflow_key"),
                url = "https://api.siliconflow.com",
              },
              schema = {
                model = {
                  default = "deepseek-ai/DeepSeek-V3",
                },
              },
            })
          end,
          xai = function()
            vim.notify_once(
              "Grok may share data with external services",
              vim.log.levels.WARN,
              { title = "CodeCompanion" }
            )
            return require("codecompanion.adapters").extend("xai", {
              env = {
                api_key = get_api_key("xai_key"),
              },
              schema = {
                model = {
                  default = "grok-3-latest",
                },
              },
            })
          end,
        },
        -- https://github.com/olimorris/codecompanion.nvim/discussions/694
        prompt_library = {
          ["Commit Message"] = {
            strategy = "inline",
            description = "Generate a commit message",
            opts = {
              short_name = "commit_inline",
              auto_submit = true,
              placement = "replace",
            },
            prompts = {
              {
                role = "user",
                content = function()
                  return string.format(
                    [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

` ` `diff
%s
` ` `

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

` ` `
%s
` ` `

Output only the commit message without any explanations and follow-up suggestions.
]],
                    vim.fn.system("git diff --no-ext-diff --staged"),
                    vim.fn.system('git log --pretty=format:"%s" -n 20')
                  )
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
        },
      },
      enabled = true,
      lazy = true,
      cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
      event = { "InsertEnter", "CmdlineEnter" },
    },
  })
end

return spec
