local M = {}

function M.setup_treesitter()
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
  -- TODO(meijieru): check later
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
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        ["iC"] = "@conditional.inner",
        ["aC"] = "@conditional.outer",
        ["i,"] = "@parameter.inner",
        ["a,"] = "@parameter.outer",
        ["ia"] = "@assignment.inner",
        ["aa"] = "@assignment.outer",
        -- ["ik"] = "@assignment.lhs",
        -- ["ak"] = "@assignment.rhs",
      },
    },
  }
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
  end
end

function M.setup_comment()
  -- until https://github.com/numToStr/Comment.nvim/issues/22
  lvim.builtin.comment.on_config_done = function(_)
    ---Textobject for adjacent commented lines
    local function commented_lines_textobject()
      local U = require "Comment.utils"
      local cl = vim.api.nvim_win_get_cursor(0)[1] -- current line
      local range = { srow = cl, scol = 0, erow = cl, ecol = 0 }
      local ctx = {
        ctype = U.ctype.linewise,
        range = range,
      }
      local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
      local ll, rr = U.unwrap_cstr(cstr)
      local padding = true
      local is_commented = U.is_commented(ll, rr, padding)

      local line = vim.api.nvim_buf_get_lines(0, cl - 1, cl, false)
      if next(line) == nil or not is_commented(line[1]) then
        return
      end

      local rs, re = cl, cl -- range start and end
      repeat
        rs = rs - 1
        line = vim.api.nvim_buf_get_lines(0, rs - 1, rs, false)
      until next(line) == nil or not is_commented(line[1])
      rs = rs + 1
      repeat
        re = re + 1
        line = vim.api.nvim_buf_get_lines(0, re - 1, re, false)
      until next(line) == nil or not is_commented(line[1])
      re = re - 1

      vim.fn.execute("normal! " .. rs .. "GV" .. re .. "G")
    end

    vim.keymap.set(
      "o",
      "gc",
      commented_lines_textobject,
      { silent = true, desc = "Textobject for adjacent commented lines" }
    )
    vim.keymap.set(
      "o",
      "u",
      commented_lines_textobject,
      { silent = true, desc = "Textobject for adjacent commented lines" }
    )
  end
end

function M.setup()
  M.setup_treesitter()
  M.setup_autopair()
  M.setup_project()
  M.setup_dap()
  M.setup_comment()
end

return M
