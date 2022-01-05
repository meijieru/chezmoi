local M = {}

function M.setup_treesitter()
  lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = false
  lvim.builtin.treesitter.ensure_installed = myvim.plugins.treesitter.ensure_installed
  lvim.builtin.treesitter.incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = "gnn",
      node_incremental = ".",
      scope_incremental = ";",
      node_decremental = ",",
    },
  }
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
    enable = false,
    keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
  }
  lvim.builtin.treesitter.playground.enable = true
  lvim.builtin.treesitter.rainbow.enable = true
end

function M.setup_autopair()
  lvim.builtin.autopairs.on_config_done = function(autopairs)
    -- endwise from: https://github.com/windwp/nvim-autopairs/wiki/Endwise
    -- autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))

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

function M.setup_project()
  lvim.builtin.project.active = myvim.plugins.project.active
  if not myvim.plugins.project.active then
    return
  end
  lvim.builtin.project.patterns = myvim.root_markers
  lvim.builtin.project.silent_chdir = true
  lvim.builtin.project.detection_methods = { "pattern", "lsp" }
end

function M.setup_dap()
  lvim.builtin.dap.active = myvim.plugins.dap.active
  if not myvim.plugins.dap.active then
    return
  end
  lvim.builtin.dap.on_config_done = function()
    local dap = require "dap"
    dap.defaults.fallback.terminal_win_cmd = "botright 50vsplit new"
    require("dap.ext.vscode").load_launchjs()

    -- disable default keymaps
    for _, key in ipairs { "d", "s", "C" } do
      lvim.builtin.which_key.mappings.d[key] = nil
    end
  end
end

function M.setup()
  M.setup_treesitter()
  M.setup_autopair()
  M.setup_project()
  M.setup_dap()
end

return M
