local normal_command = require("core.utils.keymap").normal_command
local get_icon = require("astroui").get_icon

local function get_api_key(name)
  local key = string.format("cmd:gpg --decrypt ~/.local/share/chezmoi/data/encrypted/%s.gpg 2>/dev/null", name)
  return key
end

local cheap_model, cheap_adapter, chat_adapter, inline_adapter
local adapters
local default_tools

if myvim.plugins.is_corporate_machine then
  cheap_model = ""
  cheap_adapter = "gemini_cli"
  chat_adapter = "gemini_cli"
  inline_adapter = "gemini_cli"

  default_tools = nil

  adapters = {
    acp = {
      gemini_cli = function()
        local override = require("core.utils.google").codecompanion.gemini_cli_override
        return require("codecompanion.adapters").extend("gemini_cli", override)
      end,
    },
    http = {
      opts = {
        show_defaults = false,
        show_model_choices = false,
      },
    },
  }
else
  cheap_adapter = "gemini"
  cheap_model = "gemini-2.5-flash"
  chat_adapter = "gemini_pro"
  inline_adapter = "gemini"

  default_tools = {
    "full_stack_dev",
  }

  adapters = {
    http = {
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
          schema = {
            model = {
              default = "gemini-2.5-flash",
            },
            reasoning_effort = {
              default = "none",
            },
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
    acp = {
      gemini_cli = function()
        return require("codecompanion.adapters").extend("gemini_cli", {})
      end,
    },
  }
end

local extensions = {
  history = {
    enabled = true,
    opts = {
      auto_generate_title = not myvim.plugins.is_corporate_machine,
      generation_opts = {
        adapter = cheap_adapter,
        -- model = cheap_model,
      },
      title_generation_opts = {
        adapter = cheap_adapter,
        -- model = cheap_model,
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
}

if not myvim.plugins.is_corporate_machine then
  extensions.mcphub = {
    callback = "mcphub.extensions.codecompanion",
    opts = {
      show_result_in_chat = true, -- Show mcp tool results in chat
      make_vars = true, -- Convert resources to #variables
      make_slash_commands = true, -- Add prompts as /slash commands
    },
  }

  extensions.gitcommit = {
    callback = "codecompanion._extensions.gitcommit",
    opts = {
      adapter = cheap_adapter,
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
  }
end

local spec = {
  {
    "ravitemer/mcphub.nvim",
    version = "*",
    cmd = "MCPHub",
    build = "bun install -g mcp-hub@latest",
    opts = {},
    enabled = not myvim.plugins.is_corporate_machine,
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
            adapter = chat_adapter,
            tools = {
              opts = {
                default_tools = default_tools,
              },
            },
          },
          inline = {
            adapter = inline_adapter,
          },
        },
        extensions = extensions,
        adapters = adapters,
        -- https://github.com/olimorris/codecompanion.nvim/discussions/694
      }
    end,
    enabled = true,
    lazy = true,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    event = { "InsertEnter", "CmdlineEnter", "VeryLazy" },
  },
}

return spec
