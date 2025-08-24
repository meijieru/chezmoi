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
      opts = function(_, _opts)
        vim.g.codecompanion_auto_tool_mode = true

        local cheap_adapter = "gemini"
        local cheap_model = "gemini-2.5-flash"

        return {
          -- TODO(meijieru):
          -- 1. keymap for refactor
          -- 2. programming language to system prompt
          opts = {
            language = "Simplified Chinese",
            -- system_prompt = function(opts)
            --   return "使用中文回答"
            -- end,
          },
          display = {
            chat = {
              auto_scroll = false,
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
              adapter = "gemini_pro",
              tools = {
                opts = {
                  default_tools = {
                    "full_stack_dev",
                  },
                },
              },
            },
            inline = {
              adapter = "gemini",
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
                  adapter = cheap_adapter,
                  model = cheap_model,
                },
                title_generation_opts = {
                  adapter = cheap_adapter,
                  model = cheap_model,
                  refresh_every_n_prompts = 3,
                  max_refreshes = 3,
                },
                summary = {
                  generation_opts = {
                    adapter = cheap_adapter,
                    model = cheap_model,
                  },
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
                    default = "openai/gpt-5",
                  },
                },
              })
            end,
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "gpt-5-mini",
                  },
                },
              })
            end,
            -- copilot_premium = function()
            --   return require("codecompanion.adapters").extend("copilot", {
            --     -- use copilot.lua token
            --     formatted_name = "Copilot Premium",
            --     schema = {
            --       model = {
            --         default = "claude-sonnet-4",
            --       },
            --     },
            --   })
            -- end,
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = get_api_key("gemini_key"),
                },
              })
            end,
            gemini_pro = function()
              return require("codecompanion.adapters").extend("gemini", {
                formatted_name = "Gemini Pro",
                env = {
                  api_key = get_api_key("gemini_key"),
                },
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
                    default = "zai-org/GLM-4.5",
                  },
                },
              })
            end,
            xai = function()
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
                  name = cheap_adapter,
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
        }
      end,
      enabled = true,
      lazy = true,
      cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
      event = { "InsertEnter", "CmdlineEnter" },
    },
  })
end

return spec
