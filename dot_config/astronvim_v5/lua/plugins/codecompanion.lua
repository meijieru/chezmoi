local normal_command = require("core.utils.keymap").normal_command
local get_icon = require("astroui").get_icon

local function get_api_key(name)
  local key = string.format("cmd:gpg --decrypt ~/.local/share/chezmoi/data/encrypted/%s.gpg 2>/dev/null", name)
  return key
end

local enable_mcphub = false

local is_corporate_machine = myvim.plugins.machine_specific.is_corporate_machine
local profile

-- Keep OpenRouter choices intentionally small; the full catalog is too noisy for chat use.
local openrouter_model_choices = {
  { label = "GLM 5.2", model = "z-ai/glm-5.2", default_effort = "medium" },
  { label = "Kimi K2.6", model = "moonshotai/kimi-k2.6", default_effort = "medium" },
  {
    label = "DeepSeek V4 Flash",
    model = "deepseek/deepseek-v4-flash",
    default_effort = "high",
    efforts = { "none", "high", "xhigh" },
  },
  {
    label = "DeepSeek V4 Pro",
    model = "deepseek/deepseek-v4-pro",
    default_effort = "high",
    efforts = { "none", "high", "xhigh" },
  },
}

local default_openrouter_efforts = { "none", "medium", "high", "xhigh" }
local openrouter_effort_labels = { none = "Off", medium = "Medium", high = "High", xhigh = "Max / xhigh" }

local function openrouter_effort_choices(efforts)
  efforts = efforts or default_openrouter_efforts
  return vim.tbl_map(function(value)
    return { label = openrouter_effort_labels[value] or value, value = value }
  end, efforts)
end

-- Match the default thinking level to the selected OpenRouter model.
local function default_openrouter_reasoning_effort(adapter)
  local model = adapter.schema.model.default
  if type(model) == "function" then
    model = model(adapter)
  end

  for _, choice in ipairs(openrouter_model_choices) do
    if choice.model == model then
      return choice.default_effort
    end
  end

  return "medium"
end

-- One chat-buffer shortcut for changing both model and thinking level.
local function select_openrouter_model_and_effort(chat)
  if chat.adapter.name ~= "openrouter" then
    return
  end

  local current_model = chat.adapter.name == "openrouter" and chat.settings and chat.settings.model or nil
  local current_effort = chat.adapter.name == "openrouter" and chat.settings and chat.settings["reasoning.effort"]
    or nil
  local model_choices = vim.deepcopy(openrouter_model_choices)
  if current_model then
    table.sort(model_choices, function(a, b)
      if a.model == current_model then
        return true
      elseif b.model == current_model then
        return false
      end
      return a.label < b.label
    end)
  end

  vim.ui.select(model_choices, {
    prompt = "OpenRouter Model",
    format_item = function(item)
      local prefix = item.model == current_model and "* " or "  "
      return prefix .. item.label
    end,
  }, function(selected_model)
    if not selected_model then
      return
    end

    local selected_is_current_model = selected_model.model == current_model
    local effective_effort = selected_is_current_model and current_effort or nil
    effective_effort = effective_effort or selected_model.default_effort
    local supported_efforts = selected_model.efforts or default_openrouter_efforts
    local effort_choices = openrouter_effort_choices(supported_efforts)
    if not vim.tbl_contains(supported_efforts, effective_effort) then
      effective_effort = selected_model.default_effort
    end

    local effective_effort_index = 1
    for index, item in ipairs(effort_choices) do
      if item.value == effective_effort then
        effective_effort_index = index
        break
      end
    end

    vim.ui.select(effort_choices, {
      prompt = "Thinking Level",
      format_item = function(item)
        local prefix = item.value == effective_effort and "* " or "  "
        return prefix .. item.label
      end,
      snacks = {
        on_show = function(picker)
          picker.list:view(effective_effort_index)
        end,
      },
    }, function(selected_effort)
      if not selected_effort then
        return
      end

      local effort = selected_effort.value or selected_model.default_effort
      local function apply()
        chat:change_model({ model = selected_model.model })
        chat.settings["reasoning.effort"] = effort
      end

      apply()
    end)
  end)
end

local function select_current_adapter_model(chat)
  if chat.adapter.name == "openrouter" then
    return select_openrouter_model_and_effort(chat)
  end

  local config = require("codecompanion.config")
  -- Keep adapter switching quiet, but force full model choices for this explicit model picker.
  local show_model_choices = config.adapters.http.opts.show_model_choices
  config.adapters.http.opts.show_model_choices = true

  local ok, err = pcall(require("codecompanion.interactions.chat.keymaps.change_adapter").select_model, chat)
  config.adapters.http.opts.show_model_choices = show_model_choices

  if not ok then
    error(err)
  end
end

-- Corporate mode avoids direct external HTTP providers and extra AI extensions.
local function corporate_adapters()
  return {
    acp = {
      gemini_cli = function()
        -- Corporate-only module supplied outside this chezmoi source tree.
        local ok, google = pcall(require, "core.utils.google")
        local override = ok and google.codecompanion.gemini_cli_override or {}
        return require("codecompanion.adapters").extend("gemini_cli", override)
      end,
      opts = {
        show_presets = false,
      },
    },
    http = {
      opts = {
        show_presets = false,
        show_model_choices = false,
      },
    },
  }
end

-- Personal mode keeps OpenRouter as the main chat adapter and Copilot for cheap HTTP tasks.
local function personal_adapters()
  return {
    http = {
      opts = {
        show_presets = false,
        show_model_choices = false,
      },
      openrouter = function()
        return require("codecompanion.adapters").extend("openrouter", {
          env = {
            api_key = get_api_key("openrouter_key"),
          },
          schema = {
            model = {
              order = 1,
              mapping = "parameters",
              type = "enum",
              default = "deepseek/deepseek-v4-pro",
              choices = vim.tbl_map(function(choice)
                return choice.model
              end, openrouter_model_choices),
            },
            ["reasoning.effort"] = {
              order = 2,
              mapping = "parameters",
              type = "enum",
              default = default_openrouter_reasoning_effort,
              choices = {
                "xhigh",
                "high",
                "medium",
                "low",
                "minimal",
                "none",
              },
            },
          },
        })
      end,
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-haiku-4.5",
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
      opts = {
        show_presets = false,
      },
      gemini_cli = function()
        return require("codecompanion.adapters").extend("gemini_cli", {})
      end,
      opencode = function()
        return require("codecompanion.adapters").extend("opencode", {})
      end,
      codex = function()
        return require("codecompanion.adapters").extend("codex", {
          defaults = {
            auth_method = "chatgpt", -- "openai-api-key"|"codex-api-key"|"chatgpt"
            session_config_options = {
              mode = "Full Access",
            },
          },
        })
      end,
    },
  }
end

-- Profiles collect adapter choices so policy and cost decisions stay in one place.
local function corporate_profile()
  return {
    adapters = corporate_adapters(),
    chat_adapter = "gemini_cli",
    -- Only http adapters are supported for below interaction.
    inline_adapter = nil,
    history_adapter = nil,
    history_model = nil,
    gitcommit_adapter = nil,
    default_tools = nil,
  }
end

local function personal_profile()
  return {
    adapters = personal_adapters(),
    chat_adapter = "openrouter",
    -- Only http adapters are supported for below interaction.
    inline_adapter = "copilot",
    history_adapter = "copilot",
    history_model = nil,
    gitcommit_adapter = "copilot",
    default_tools = { "agent" },
  }
end

profile = is_corporate_machine and corporate_profile() or personal_profile()

-- History is installed for manual resume/search, but automatic titles are disabled.
local extensions = {
  history = {
    enabled = not is_corporate_machine,
    opts = {
      auto_generate_title = false,
      generation_opts = {
        adapter = profile.history_adapter,
        model = profile.history_model,
      },
      title_generation_opts = {
        adapter = profile.history_adapter,
        model = profile.history_model,
        refresh_every_n_prompts = 3,
        max_refreshes = 3,
      },
      summary = {
        generation_opts = {
          adapter = profile.history_adapter,
          model = profile.history_model,
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

if not is_corporate_machine then
  if enable_mcphub then
    extensions.mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true, -- Show mcp tool results in chat
        make_vars = true, -- Convert resources to #variables
        make_slash_commands = true, -- Add prompts as /slash commands
      },
    }
  end

  extensions.gitcommit = {
    callback = "codecompanion._extensions.gitcommit",
    opts = {
      adapter = profile.gitcommit_adapter,
      languages = { "English" },

      use_commit_history = true,
      commit_history_count = 20,

      -- Buffer integration
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
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

-- Avoid installing personal-only extensions on corporate machines.
local function codecompanion_dependencies()
  local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  }

  if is_corporate_machine then
    return dependencies
  end

  vim.list_extend(dependencies, {
    "ravitemer/codecompanion-history.nvim",
    "jinzhongjia/codecompanion-gitcommit.nvim",
  })

  if enable_mcphub then
    table.insert(dependencies, "ravitemer/mcphub.nvim")
  end

  return dependencies
end

local codecompanion_deps = codecompanion_dependencies()

local spec = {
  {
    "ravitemer/mcphub.nvim",
    version = "*",
    cmd = "MCPHub",
    build = "bun install -g mcp-hub@latest",
    opts = {},
    enabled = enable_mcphub,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "*",
    dependencies = codecompanion_deps,
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
                -- Delegate to gitcommit extension's buffer integration
                vim.cmd("Git commit")
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
        },
        display = {
          chat = {
            auto_scroll = true,
            intro_message = "",
            -- Adapter can't be changed when `display.chat.show_settings = true`
            show_settings = false,
          },
          action_palette = {
            opts = {
              show_default_prompt_library = true,
              show_preset_actions = true,
            },
          },
        },
        interactions = {
          chat = {
            adapter = profile.chat_adapter,
            tools = {
              opts = {
                default_tools = profile.default_tools,
              },
            },
            keymaps = not is_corporate_machine and {
              select_model = {
                modes = { n = "gm" },
                index = 23,
                callback = select_current_adapter_model,
                description = "[Adapter] Select model",
              },
              _btw = {
                modes = { n = "gB" },
                callback = "keymaps.btw",
                description = "[Request] Send a message to the LLM",
              },
            } or nil,
          },
          inline = {
            adapter = profile.inline_adapter,
          },
        },
        extensions = extensions,
        adapters = profile.adapters,
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
