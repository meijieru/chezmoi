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
      -- remove after nvim 0.12
      enabled = vim.lsp.inline_completion == nil,
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
        "jinzhongjia/codecompanion-gitcommit.nvim",
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
                  local func = require("codecompanion._extensions.gitcommit.buffer")._generate_and_insert_commit_message
                  if vim.bo.filetype == "gitcommit" then
                    func(0)
                  else
                    vim.cmd("Git commit")
                    vim.schedule(function()
                      if vim.bo.filetype == "gitcommit" then
                        -- We are in commit message buffer and the commit is not empty
                        func(0)
                      end
                    end)
                  end
                end,
                desc = "AI Commit",
              },
              -- -- vscode copilot style, conflict with nvim stack navigation
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
            gitcommit = {
              callback = "codecompanion._extensions.gitcommit",
              opts = {
                adapter = "gemini",
                languages = { "English" },

                use_commit_history = true,
                commit_history_count = 20,

                -- Buffer integration
                buffer = {
                  enabled = false, -- Enable gitcommit buffer keymaps
                  keymap = "<leader>ac", -- Keymap for generating commit messages
                  auto_generate = true, -- Auto-generate on buffer enter
                  auto_generate_delay = 200, -- Auto-generation delay (ms)
                  skip_auto_generate_on_amend = true, -- Skip auto-generation during git commit --amend
                },
                -- Feature toggles
                add_slash_command = true, -- Add /gitcommit slash command
                add_git_tool = true, -- Add @git_read and @git_edit tools
                enable_git_read = true, -- Enable read-only Git operations
                enable_git_edit = true, -- Enable write-access Git operations
                enable_git_bot = true, -- Enable @git_bot tool group (requires both read/write enabled)
                add_git_commands = true, -- Add :CodeCompanionGitCommit commands
                git_tool_auto_submit_errors = false, -- Auto-submit errors to LLM
                git_tool_auto_submit_success = true, -- Auto-submit success to LLM
                gitcommit_select_count = 100, -- Number of commits shown in /gitcommit
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
        }
      end,
      enabled = true,
      lazy = true,
      cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
      event = { "InsertEnter", "CmdlineEnter", "VeryLazy" },
    },
  })
end

return spec
