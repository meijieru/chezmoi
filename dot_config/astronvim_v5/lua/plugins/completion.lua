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
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        keymap = {
          -- TODO(meijieru): word/line accept
          ["<Tab>"] = remove_select(opts.keymap["<Tab>"]),
          ["<S-Tab>"] = remove_select(opts.keymap["<S-Tab>"]),
          ["<C-J>"] = { "fallback" },
          ["<C-K>"] = { "fallback" },
        },
        cmdline = {
          completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
          },
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
        server = {
          -- Better RAM usage & no nodejs dependency
          type = "binary", -- "nodejs" | "binary"
        },
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
      version = "*",
      cmd = "MCPHub",
      build = "bun install -g mcp-hub@latest",
      opts = {},
    },

    {
      "olimorris/codecompanion.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/mcphub.nvim",
        "ravitemer/codecompanion-history.nvim",
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
              ["<Leader>ac"] = {
                function()
                  if vim.bo.filetype == "gitcommit" then
                    require("codecompanion").prompt("commit_inline")
                  else
                    vim.cmd("Git commit")
                    vim.schedule(function()
                      if vim.bo.filetype == "gitcommit" then
                        -- It means we are in commit message buffer and the commit is not empty
                        require("codecompanion").prompt("commit_inline")
                      end
                    end)
                  end
                end,
                desc = "AI Commit",
              },
              -- vscode copilot style, conflict with nvim stack navigation
              -- ["<C-I>"] = { ":CodeCompanion " },
            },
            v = {
              ["<Leader>a"] = { desc = get_icon("Copilot", 1, true) .. "AI" },
              ["<Leader><Leader>"] = { normal_command("CodeCompanionChat Add"), desc = "Add to Chat" },
              ["<Leader>aa"] = { normal_command("CodeCompanionActions"), desc = "Actions" },
              ["<Leader>ae"] = { prompt("explain"), desc = "Explain" },
              ["<Leader>af"] = { prompt("fix"), desc = "Fix" },
              ["<Leader>at"] = { prompt("tests"), desc = "Add Testcases" },
              -- vscode copilot style
              ["<C-I>"] = { ":CodeCompanion " },
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
            adapter = "copilot_premium",
            tools = {
              opts = {
                auto_submit_errors = false, -- Send any errors to the LLM automatically?
                auto_submit_success = true, -- Send any successful output to the LLM automatically?
              },
            },
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
          history = {
            enabled = true,
            opts = {
              auto_generate_title = true,
              generation_opts = {
                adapter = "copilot",
                model = "gpt-4.1",
              },
              title_generation_opts = {
                adapter = "copilot",
                model = "gpt-4.1",
                refresh_every_n_prompts = 3,
                max_refreshes = 3,
              },
              delete_on_clearing_chat = false,
              continue_last_chat = false,
              picker = "snacks",
              picker_keymaps = {
                -- FIXME(meijieru): revisit keymaps and fix
                rename = { n = "<C-r>", i = "<C-r>" },
                delete = { n = "<C-x>", i = "<C-x>" },
                duplicate = { n = "<C-y>", i = "<C-y>" },
              },
            },
          },
        },
        adapters = {
          opts = {
            show_defaults = false,
            show_model_choices = false,
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
                  default = "moonshotai/kimi-k2:free",
                },
              },
            })
          end,
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {})
          end,
          copilot_premium = function()
            return require("codecompanion.adapters").extend("copilot", {
              -- use copilot.lua token
              formatted_name = "Copilot Premium",
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
          siliconflow = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "siliconflow",
              formatted_name = "SiliconFlow",
              env = {
                api_key = get_api_key("siliconflow_key"),
                url = "https://api.siliconflow.cn",
              },
              schema = {
                model = {
                  default = "moonshotai/Kimi-K2-Instruct",
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
                  default = "grok-4",
                },
              },
            })
          end,
          tavily = function()
            return require("codecompanion.adapters").extend("tavily", {
              env = {
                api_key = get_api_key("tavily_key"),
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
              adapter = {
                name = "copilot",
              },
              ignore_system_prompt = true,
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
