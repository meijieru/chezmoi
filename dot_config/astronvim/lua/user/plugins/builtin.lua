local get_icon = require("astronvim.utils").get_icon

return {
  "AstroNvim/astrocommunity",

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        topdelete = { text = get_icon "GitSignTopDelete" },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.default_source = "buffers"
      opts.sources = { "buffers", "document_symbols" }
      local sources = opts.source_selector.sources
      sources[#sources + 1] = { source = "document_symbols", display_name = get_icon("Package", 1, true) .. "Symbols" }
      opts.document_symbols = {
        follow_cursor = false,
        renderers = {
          symbol = {
            { "indent", with_expanders = true },
            { "kind_icon", default = "?" },
            {
              "container",
              content = {
                { "name", zindex = 10 },
              },
            },
          },
        },
      }
      return opts
    end,
  },

  {
    "stevearc/aerial.nvim",
    opts = function(_, opts)
      local filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      }
      opts.filter_kind = filter_kind
      return opts
    end,
    enabled = false,
  },

  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      opts.tabline = nil
      local status = require "astronvim.utils.status"
      local hl = require "astronvim.utils.status.hl"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.file_info {
          filetype = {},
          filename = false,
          file_modified = {},
          surround = { separator = "left" },
        },
        status.component.git_branch(),
        status.component.git_diff(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.diagnostics(),
        status.component.treesitter {
          str = { str = "", padding = { left = 0, right = 0 }, show_empty = true },
          surround = { separator = "none" },
        },
        status.component.lsp {
          lsp_progress = false,
          lsp_client_names = {
            icon = { padding = { right = 1 } },
          },
          surround = { separator = "none" },
        },
        status.component.nav {
          ruler = {
            pad_ruler = { line = 2, col = 2 },
            hl = { bold = true, fg = "bg" },
            padding = { left = 1, right = 1 },
          },
          scrollbar = false,
          percentage = false,
          surround = { color = hl.mode_bg },
          update = {
            "ModeChanged",
            "CursorMoved",
            "CursorMovedI",
            "BufEnter",
          },
        },
      }
      return opts
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.open_mapping = [[<C-t>]]
      return opts
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then return end

      local mapping = opts.mapping
      for _, key in ipairs { "<C-j>", "<C-k>", "<C-y>", "<Down>", "<Up>" } do
        mapping[key] = nil
      end

      mapping["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" })
      mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })

      return opts
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"

      local function send_and_open_qflist(...)
        actions.smart_send_to_qflist(...)
        actions.open_qflist(...)
      end
      -- useful defalt:
      -- <C-/> Show mappings for picker actions (insert mode)
      -- ? Show mappings for picker actions (normal mode)
      local mappings = opts.defaults.mappings
      mappings.i = {
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = send_and_open_qflist,
        ["<CR>"] = actions.select_default,
      }
      mappings.n = {
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-q>"] = send_and_open_qflist,
        ["g?"] = "which_key",
      }

      local function git_diffview(prompt_bufnr, template)
        -- Open in diffview
        local selected_entry = action_state.get_selected_entry()
        local value = selected_entry.value
        actions.close(prompt_bufnr)
        vim.schedule(function() vim.cmd(template:format(value)) end)
      end
      local function git_diffview_commit(prompt_bufnr) return git_diffview(prompt_bufnr, "DiffviewOpen %s^!") end
      local function git_diffview_branch(prompt_bufnr) return git_diffview(prompt_bufnr, "DiffviewOpen %s") end

      opts.pickers = {
        git_commits = {
          mappings = {
            i = {
              ["<C-v>"] = git_diffview_commit,
            },
          },
        },
        git_bcommits = {
          mappings = {
            i = {
              ["<C-v>"] = git_diffview_commit,
            },
          },
        },
        git_branches = {
          mappings = {
            i = {
              ["<C-v>"] = git_diffview_branch,
            },
          },
        },
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
      }
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      render = "default",
      stages = "fade",
      top_down = false,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local utils = require "astronvim.utils"
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed =
          utils.list_insert_unique(opts.ensure_installed, { "comment", "rst", "regex", "markdown", "markdown_inline" })
      end
      opts.auto_install = true
      opts.textobjects = vim.tbl_deep_extend("force", opts.textobjects, {
        select = {
          keymaps = {
            ["i,"] = "@parameter.inner",
            ["a,"] = "@parameter.outer",
            ["ia"] = "@assignment.inner",
            ["aa"] = "@assignment.outer",
          },
        },
      })
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          -- init_selection = "gnn",
          node_incremental = ".",
          scope_incremental = ";",
          node_decremental = ",",
        },
      }
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, config_opts)
      require "plugins.configs.nvim-autopairs"(plugin, config_opts)

      -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules {
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(
            function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end
          ),
      }
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(
              function(_) return "<C-c>2xi<CR><C-c>O" end
            ),
        }
      end
    end,
  },

  { "Shatur/neovim-session-manager", enabled = false },
  { "max397574/better-escape.nvim", enabled = false },
}
