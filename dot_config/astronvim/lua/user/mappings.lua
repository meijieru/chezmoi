-- default mappings: ~/.config/astronvim/lua/astronvim/mappings.lua

local map = vim.keymap.set
local keymap_utils = require "core.utils.keymap"
local normal_command = keymap_utils.normal_command
local lua_normal_command = keymap_utils.lua_normal_command

local utils = require "astronvim.utils"
local is_available = utils.is_available
local get_icon = utils.get_icon

local function smart_default(cmd, expr)
  return function()
    local word = vim.fn.expand(expr or "<cword>")
    if #word > 1 and not (vim.tbl_contains({ 2, 3 }, #word) and string.find(word, '[",()]')) then
      -- meaningful word, exclude word with short len & contains [,()]
      vim.cmd(string.format("Telescope %s default_text=%s", cmd, word))
    else
      vim.cmd("Telescope " .. cmd)
    end
  end
end

local function visual_search(cmd)
  return function()
    local utils = require "core.utils"
    local content = utils.get_visual_selection()
    if content == nil then return end
    local command = string.format("Telescope %s default_text=%s", cmd, vim.fn.escape(content, " ()"))
    vim.cmd(command)
  end
end

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
  if next(line) == nil or not is_commented(line[1]) then return end

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

local to_disable = {
  n = {
    -- Standard Operations
    -- ["j"] = false,
    -- ["k"] = false,
    ["<leader>w"] = false,
    ["<leader>q"] = false,
    ["<leader>n"] = false,
    ["<C-s>"] = false,
    ["<C-q>"] = false,
    ["|"] = false,
    ["\\"] = false,

    ["<leader>b"] = false,
    ["<leader>bb"] = false,
    ["<leader>bc"] = false,
    ["<leader>bC"] = false,
    ["<leader>bd"] = false,
    ["<leader>b\\"] = false,
    ["<leader>b|"] = false,
    ["<leader>bl"] = false,
    ["<leader>bp"] = false,
    ["<leader>br"] = false,
    ["<leader>bs"] = false,
    ["<leader>bse"] = false,
    ["<leader>bsr"] = false,
    ["<leader>bsp"] = false,
    ["<leader>bsi"] = false,
    ["<leader>bsm"] = false,

    ["<leader>c"] = false,
    ["<leader>C"] = false,
    [">b"] = false,
    ["<b"] = false,

    ["<leader>/"] = false,

    ["]g"] = false,
    ["[g"] = false,
    ["<leader>gl"] = false,
    ["<leader>gL"] = false,
    ["<leader>gp"] = false,
    ["<leader>gh"] = false,
    ["<leader>gr"] = false,
    ["<leader>gs"] = false,
    ["<leader>gS"] = false,
    ["<leader>gu"] = false,
    ["<leader>gd"] = false,
    ["<leader>gt"] = false,

    ["<leader>o"] = false,

    ["<C-h>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-l>"] = false,
    ["<C-Up>"] = false,
    ["<C-Down>"] = false,
    ["<C-Left>"] = false,
    ["<C-Right>"] = false,

    ["<leader>lS"] = false,

    -- Telescope
    ["<leader>f'"] = false,
    ["<leader>f/"] = false,
    ["<leader>fa"] = false,
    ["<leader>fb"] = false,
    ["<leader>fc"] = false,
    ["<leader>fC"] = false,
    ["<leader>ff"] = false,
    ["<leader>fF"] = false,
    ["<leader>fh"] = false,
    ["<leader>fk"] = false,
    ["<leader>fm"] = false,
    ["<leader>fo"] = false,
    ["<leader>fr"] = false,
    ["<leader>ft"] = false,
    ["<leader>fw"] = false,
    ["<leader>fW"] = false,

    -- Terminal
    ["<F7>"] = false,
    ["<C-'>"] = false,

    -- Custom menu for modification of the user experience
    ["<leader>uc"] = false,
    ["<leader>uC"] = false,
    ["<leader>ug"] = false,
    ["<leader>ul"] = false,
    ["<leader>uL"] = false,
    ["<leader>un"] = false,
    ["<leader>uN"] = false,
    ["<leader>up"] = false,
    ["<leader>ut"] = false,
    ["<leader>uu"] = false,
    ["<leader>uy"] = false,
    ["<leader>uh"] = false,

    -- Debug
    ["<leader>dE"] = false,
  },

  v = {
    ["<leader>/"] = false,

    -- Indent
    ["<S-Tab>"] = false,
    ["<Tab>"] = false,

    -- Debug
    ["<leader>dE"] = false,
  },

  t = {
    -- Terminal
    ["<F7>"] = false,
    ["<C-'>"] = false,

    -- Improved Terminal Navigation
    ["<C-h>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-l>"] = false,
  },
}

local mappings = {
  n = {
    -- Git
    dp = {
      function()
        if vim.o.diff then
          vim.cmd.diffput()
        else
          require("gitsigns").stage_hunk()
        end
      end,
      desc = "Diff Put | Stage Hunk",
    },
    dP = {
      function() require("gitsigns").undo_stage_hunk() end,
      desc = "Undo Stage Hunk",
    },
    ["do"] = {
      function()
        if vim.o.diff then
          vim.cmd.diffget()
        else
          require("gitsigns").reset_hunk()
        end
      end,
      desc = "Diff Get | Reset Hunk",
    },

    ["<leader>gd"] = { normal_command "DiffviewOpen", desc = "Diff View" },
    ["<leader>gh"] = { normal_command "DiffviewFileHistory", desc = "Diff History" },
    ["<leader>gH"] = { normal_command "DiffviewFileHistory %", desc = "Diff History (for current file)" },
    ["<leader>gg"] = { function() require("core.utils.git").toggle_fugitive() end, desc = "Toggle Status" },
    ["<leader>gl"] = { normal_command "Git blame", desc = "Git Blame" },
    ["<leader>gL"] = { normal_command "Gitsigns toggle_current_line_blame", desc = "Current Line Blame" },
    ["<leader>gt"] = {
      keymap_utils.chain("Gitsigns toggle_deleted", "Gitsigns toggle_word_diff"),
      desc = "Toggle Inline Diff",
    },
    ["<leader>gy"] = {
      function() require("gitlinker").get_buf_range_url "n" end,
      desc = "Copy Permanent Link",
    },

    -- Next / Prev
    ["]"] = {
      name = "Next",
      ["e"] = {
        function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end,
        "Next Error",
      },
      ["q"] = { normal_command "cnext", "Next Quickfix" },
      ["l"] = { normal_command "lnext", "Next Loclist" },
      ["c"] = {
        function()
          for _ = 1, vim.v.count1 do
            if vim.o.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              require("gitsigns.actions").next_hunk()
            end
          end
        end,
        "Next Change | Hunk",
      },
    },
    ["["] = {
      name = "Previous",
      ["e"] = {
        function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
        "Previous Error",
      },
      ["q"] = { normal_command "cprev", "Previous Quickfix" },
      ["l"] = { normal_command "lprev", "Previous Loclist" },
      ["c"] = {
        function()
          for _ = 1, vim.v.count1 do
            if vim.o.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              require("gitsigns.actions").prev_hunk()
            end
          end
        end,
        "Previous Change | Hunk",
      },
    },

    -- Better window movement
    ["<A-h>"] = { "<C-w>h", desc = "Left Window" },
    ["<A-j>"] = { "<C-w>j", desc = "Down Window" },
    ["<A-k>"] = { "<C-w>k", desc = "Up Window" },
    ["<A-l>"] = { "<C-w>l", desc = "Right Window" },

    -- Other
    ["m<space>"] = { normal_command "delmarks!", desc = "Delete All Marks" },
    ["g?"] = { normal_command "WhichKey", desc = "WhichKey" },

    -- Telescope
    -- trick: <c-space> convert it as fuzzy
    ["<c-p>"] = { normal_command "Telescope commands", desc = "Commands Palette" },
    ["<leader>*"] = { smart_default "live_grep", desc = "Grep" },
    ["<leader>b"] = { normal_command "Telescope buffers", desc = "Find Buffer" },
    ["<leader>/"] = { normal_command "Telescope search_history", desc = "Find Search History" },
    ["<leader>fc"] = { normal_command "Telescope command_history", desc = "Find Commands History" },
    ["<leader>ff"] = { normal_command "Telescope find_files", desc = "Find File" },
    ["<leader>fh"] = { smart_default "help_tags", desc = "Find Help" },
    ["<leader>fm"] = { smart_default "man_pages", desc = "Find man" },
    ["<leader>fk"] = { normal_command "Telescope keymaps", desc = "Keymaps" },
    ["<leader>fb"] = { smart_default "current_buffer_fuzzy_find", desc = "Grep Buffer" },
    ["<leader>fl"] = { normal_command "Telescope loclist", desc = "Find Loclist" },
    ["<leader>fp"] = { normal_command "Telescope projects", desc = "Projects" },
    ["<leader>fq"] = { normal_command "Telescope quickfix", desc = "Find QuickFix" },
    ["<leader>ft"] = { normal_command "OverseerRun", desc = "Find Tasks" },
    ["<leader>fj"] = { normal_command "Telescope jumplist", desc = "Find JumpList" },
    ["<leader>fr"] = { normal_command "Telescope oldfiles", desc = "Open Recent File" },
    ["<leader>fR"] = { normal_command "Telescope registers", desc = "Find Registers" },

    -- Terminal
    ["<C-t>"] = { normal_command "ToggleTerm", desc = "Toggle terminal" },

    -- Debug
    ["<leader>de"] = { function() require("dapui").eval() end, desc = "Evaluate" },

    -- Custom menu for modification of the user experience
    ["<leader>uc"] = { normal_command "ColorizerToggle", desc = "Colorizer" },
    ["<leader>uu"] = { normal_command "OverseerToggle", desc = "Overseer" },
    ["<leader>uq"] = { function() require("core.utils.ui").toggle_quickfix() end, desc = "Quickfix" },
    ["<leader>ul"] = { function() require("core.utils.ui").toggle_loclist() end, desc = "Loclist" },

    -- Treesitter
    ["<leader>T"] = {
      name = get_icon "ActiveTS" .. " Treesitter",
      c = { normal_command "TSConfigInfo", "Config Info" },
      m = { normal_command "TSModuleInfo", "Module Info" },
      t = { normal_command "InspectTree", "Playground" },
      s = { normal_command "TSUpdate", "Update Treesitter Parser" },
      h = { normal_command "Inspect", "Highlight Info" },
    },
  },

  v = {
    ["<"] = { "<gv" },
    [">"] = { ">gv" },

    ["<leader>"] = {
      ["*"] = { visual_search "live_grep", "Grep" },
      f = {
        h = { visual_search "help_tags", "Find Help" },
        b = { visual_search "current_buffer_fuzzy_find", "Grep Buffer" },
      },
    },

    -- Git
    ["<leader>gy"] = {
      function() require("gitlinker").get_buf_range_url "v" end,
      desc = "Copy Permanent Link",
    },

    -- Debug
    ["<leader>de"] = { function() require("dapui").eval() end, desc = "Evaluate" },
  },

  t = {
    ["<A-q>"] = { [[<C-\><C-n>]], desc = "Terminal normal mode" },
    ["<A-h>"] = { normal_command "wincmd h", desc = "Terminal left window navigation" },
    ["<A-j>"] = { normal_command "wincmd j", desc = "Terminal down window navigation" },
    ["<A-k>"] = { normal_command "wincmd k", desc = "Terminal up window navigation" },
    ["<A-l>"] = { normal_command "wincmd l", desc = "Terminal right window navigation" },
  },

  o = {
    u = { commented_lines_textobject, desc = "Commented Lines Textobject", silent = true },
  },
}

local function direct_set()
  --- TODO(meijieru): smart-split mappings
  map({ "i", "c" }, "<C-k>", "<Up>")
  map({ "i", "c" }, "<C-j>", "<Down>")
  map({ "i", "c" }, "<C-h>", "<Left>")
  map({ "i", "c" }, "<C-l>", "<Right>")

  map(
    { "n", "i" },
    "<F1>",
    lua_normal_command "require('core.utils.ui').toggle_colorcolumn()",
    { desc = "Toggle Colorcolumn" }
  )
end

return function(maps)
  maps = vim.tbl_deep_extend("force", maps, to_disable)
  maps = vim.tbl_deep_extend("force", maps, mappings)

  if maps.n["<leader>ls"] then maps.n["<leader>ls"].desc = "Document symbols" end
  maps.n["<leader>ll"] = {
    function()
      if is_available "dropbar.nvim" then
        require("dropbar.api").pick()
      elseif is_available "aerial.nvim" then
        require("aerial").toggle()
      else
        vim.notify("No dropbar or aerial.nvim installed", vim.log.levels.ERROR)
      end
    end,
    desc = "Navigate",
  }

  if is_available "neo-tree.nvim" then
    maps.n["<leader>s"] = { normal_command "Neotree document_symbols toggle", desc = "Symbols" }
  end

  maps.v["<leader>g"] = maps.n["<leader>g"]
  maps.v["<leader>f"] = maps.n["<leader>f"]

  -- Debug
  maps.n["<leader>dd"] = maps.n["<leader>ds"]
  maps.n["<leader>ds"] = nil

  direct_set()

  return maps
end
