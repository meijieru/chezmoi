local M = {}

function M.setup()
  lvim.builtin.project.active = true
  lvim.builtin.project.patterns = myvim.root_markers
  lvim.builtin.project.silent_chdir = false
  -- NOTE(meijieru): lsp sometimes is annoying
  lvim.builtin.project.detection_methods = { "pattern", "lsp" }

  lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = false
  lvim.builtin.treesitter.ensure_installed = "maintained"
  lvim.builtin.treesitter.matchup.enable = true
  -- TODO(meijieru): check later
  lvim.builtin.treesitter.indent.disable = { "yaml", "python" }
  lvim.builtin.treesitter.textobjects = {
    swap = {
      enable = false,
      -- swap_next = textobj_swap_keymaps,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]["] = "@function.outer",
        ["]m"] = "@class.outer",
      },
      goto_next_end = {
        ["]]"] = "@function.outer",
        ["]M"] = "@class.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[m"] = "@class.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[M"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["i,"] = "@parameter.inner",
        ["a,"] = "@parameter.outer",
      },
    },
  }
  lvim.builtin.treesitter.textsubjects = {
    enable = true,
    keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
  }
  lvim.builtin.treesitter.playground.enable = true
  lvim.builtin.treesitter.rainbow.enable = true

  lvim.builtin.autopairs.on_config_done = function(autopairs)
    -- Pick from: https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
    local Rule = require "nvim-autopairs.rule"
    autopairs.add_rules {
      Rule(" ", " "):with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ "()", "[]", "{}" }, pair)
      end),
      Rule("( ", " )")
        :with_pair(function()
          return false
        end)
        :with_move(function(opts)
          return opts.prev_char:match ".%)" ~= nil
        end)
        :use_key ")",
      Rule("{ ", " }")
        :with_pair(function()
          return false
        end)
        :with_move(function(opts)
          return opts.prev_char:match ".%}" ~= nil
        end)
        :use_key "}",
      Rule("[ ", " ]")
        :with_pair(function()
          return false
        end)
        :with_move(function(opts)
          return opts.prev_char:match ".%]" ~= nil
        end)
        :use_key "]",
    }
  end
end

return M
