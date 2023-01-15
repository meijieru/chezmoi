local M = {}

local Log = require "core.log"
local utils = require "core.utils"

local status_whichkey_ok, which_key = utils.safe_load "which-key"
if not status_whichkey_ok then
  return M
end

local status_mapx_ok, mapx = utils.safe_load "mapx"
if not status_mapx_ok then
  return M
end
require("mapx").setup { global = false, whichkey = true, debug = false }

-- wait for https://github.com/b0o/mapx.nvim/issues/3
function M.chain(...)
  local cmds = { ... }
  local function exe(cmd)
    if type(cmd) == "function" then
      cmd()
    elseif type(cmd) == "string" then
      vim.cmd(cmd)
    else
      Log:error("Unknown cmd type: " .. type(cmd))
    end
  end

  return function()
    vim.tbl_map(exe, cmds)
  end
end

function M.not_impl(msg)
  vim.notify(msg or "Not Implementation PlaceHolder", vim.log.levels.ERROR)
end

function M.setup_easy_align()
  vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign" })
end

function M.setup_terminal()
  local opts = { noremap = true }
  mapx.tnoremap("<M-q>", [[<C-\><C-n>]], opts)
  mapx.tnoremap("<M-h>", [[<C-\><C-n><C-W>h]], opts)
  mapx.tnoremap("<M-j>", [[<C-\><C-n><C-W>j]], opts)
  mapx.tnoremap("<M-k>", [[<C-\><C-n><C-W>k]], opts)
  mapx.tnoremap("<M-l>", [[<C-\><C-n><C-W>l]], opts)

  lvim.builtin.terminal.open_mapping = "<C-t>"
end

function M.setup_sniprun()
  if not myvim.plugins.sniprun.active then
    return
  end
  mapx.vmap("gr", "<Plug>SnipRun", mapx.silent, "SnipRun")
  mapx.nmap("<leader>r", "<Plug>SnipRunOperator", mapx.silent, "SnipRun")
  mapx.nmap("<leader>rr", "<Plug>SnipRun", mapx.silent, "SnipRun")
end

function M.setup_lsp()
  for _, key in ipairs { "gs", "gl" } do
    lvim.lsp.buffer_mappings.normal_mode[key] = nil
  end
  lvim.lsp.buffer_mappings.normal_mode["gd"] = {
    function()
      require("telescope.builtin").lsp_definitions()
    end,
    "Goto Definition",
  }
  lvim.lsp.buffer_mappings.normal_mode["gr"] = {
    function()
      require("telescope.builtin").lsp_references()
    end,
    "Goto References",
  }
  lvim.lsp.buffer_mappings.normal_mode["gI"] = {
    function()
      require("telescope.builtin").lsp_implementations()
    end,
    "Goto Implementation",
  }
  lvim.lsp.buffer_mappings.normal_mode["gt"] = {
    function()
      require("telescope.builtin").lsp_type_definitions()
    end,
    "Goto Type Definitions",
  }

  for _, key in ipairs { "j", "k", "s", "d", "w", "e", "i", "I", "q" } do
    lvim.builtin.which_key.mappings.l[key] = nil
  end
  which_key.register {
    ["<leader>l"] = {
      ["g"] = { "<cmd>Neogen<cr>", "Generate Doc" },
      ["d"] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
      ["D"] = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
      ["s"] = {
        function()
          if myvim.plugins.aerial.active then
            require("telescope").extensions.aerial.aerial()
          else
            require("telescope.builtin").lsp_document_symbols()
          end
        end,
        "Document Symbols",
      },
    },
  }
end

function M.setup_find()
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
      local content = utils.get_visual_selection()
      local command = string.format("Telescope %s default_text=%s", cmd, vim.fn.escape(content, " ()"))
      vim.cmd(command)
    end
  end

  which_key.register {
    ["<leader>"] = {
      -- trick: <c-space> convert it as fuzzy
      ["*"] = { smart_default "live_grep", "Grep" },
      b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
      ["/"] = { "<cmd>Telescope search_history<cr>", "Find Search History" },
      f = {
        name = "Find",
        s = { "<cmd>lua require'telescope'.extensions.luasnip.luasnip{}<cr>", "Find snippets" },
        c = { "<cmd>Telescope command_history<cr>", "Find Commands History" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        h = { smart_default "help_tags", "Find Help" },
        m = { smart_default "man_pages", "Man Pages" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        b = { smart_default "current_buffer_fuzzy_find", "Grep Buffer" },
        l = { "<cmd>Telescope loclist<cr>", "Find Loclist" },
        n = { "<cmd>lua require('telescope').extensions.notify.notify()<cr>", "Notifications" },
        p = { "<cmd>Telescope resume<cr>", "Find Previous" },
        P = { "<cmd>Telescope projects<cr>", "Projects" },
        q = { "<cmd>Telescope quickfix<cr>", "Find QuickFix" },
        t = { "<cmd>OverseerRun<cr>", "Find Tasks" },
        j = { "<cmd>Telescope jumplist<cr>", "Find JumpList" },
        r = {
          function()
            if myvim.plugins.telescope_frecency.active then
              require("telescope").extensions.frecency.frecency()
            else
              vim.cmd "Telescope oldfiles"
            end
          end,
          "Open Recent File",
        },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
      },
    },
  }

  which_key.register({
    ["<leader>"] = {
      ["*"] = { visual_search "live_grep", "Grep" },
      f = {
        name = "Find",
        h = { visual_search "help_tags", "Find Help" },
        b = { visual_search "current_buffer_fuzzy_find", "Grep Buffer" },
      },
    },
  }, {
    mode = "v",
  })
end

function M.setup_asynctasks()
  local mappings = {
    ["<F5>"] = { "<cmd>AsyncTask file-run<cr>", "File Run" },
    ["<F6>"] = { "<cmd>AsyncTask file-build<cr>", "File Build" },
    ["<f7>"] = { "<cmd>AsyncTask project-run<cr>", "Project Run" },
    ["<f8>"] = { "<cmd>AsyncTask project-build<cr>", "Project Build" },
  }
  which_key.register(mappings, { silent = true })
end

function M.setup_basic()
  -- disable some defaults mappings
  for key, _ in pairs(lvim.keys) do
    lvim.keys[key] = {}
  end
  for _, key in ipairs { "/" } do
    lvim.builtin.which_key.vmappings[key] = nil
  end
  for _, key in ipairs { "w", "q", "/", ";", "c", "f", "h", "s", "b", "T" } do
    lvim.builtin.which_key.mappings[key] = nil
  end

  local function system_open()
    local function is_github(str)
      local comps = vim.split(str, "/")
      return #comps == 2
    end

    local cfile = vim.fn.fnameescape(vim.fn.expand "<cfile>")
    if is_github(cfile) then
      cfile = string.format("https://github.com/%s", cfile)
    elseif vim.fn.filereadable(cfile) == 0 and string.match(cfile, "[a-z]*://[^ >,;]*") == nil then
      vim.notify(string.format("url %s invalid", cfile), "error", { title = "system-open" })
      return
    end
    utils.xdg_open(cfile)
  end

  mapx.inoremap("<C-k>", "<Up>")
  mapx.inoremap("<C-j>", "<Down>")
  mapx.inoremap("<C-h>", "<Left>")
  mapx.inoremap("<C-l>", "<Right>")

  -- Better window movement
  mapx.nnoremap("<A-h>", "<C-w>h", "Left Window")
  mapx.nnoremap("<A-j>", "<C-w>j", "Down Window")
  mapx.nnoremap("<A-k>", "<C-w>k", "Up Window")
  mapx.nnoremap("<A-l>", "<C-w>l", "Right Window")

  which_key.register {
    ["]"] = {
      name = "Next",
      ["e"] = {
        function()
          vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
        end,
        "Error",
      },
      ["d"] = { vim.diagnostic.goto_next, "Diagnostic" },
      ["q"] = { "<cmd>cnext<cr>", "Quickfix" },
      ["l"] = { "<cmd>lnext<cr>", "Loclist" },
      ["b"] = { "<cmd>bprevious<cr>", "Buffer" },
      ["t"] = { "<cmd>tabnext<cr>", "Tab" },
      ["c"] = {
        function()
          if vim.o.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            require("gitsigns.actions").next_hunk()
          end
        end,
        "Change | Hunk",
      },
    },
    ["["] = {
      name = "Prev",
      ["e"] = {
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        "Error",
      },
      ["d"] = { vim.diagnostic.goto_prev, "Diagnostic" },
      ["q"] = { "<cmd>cprev<cr>", "Quickfix" },
      ["l"] = { "<cmd>lprev<cr>", "Loclist" },
      ["b"] = { "<cmd>bnext<cr>", "Buffer" },
      ["t"] = { "<cmd>tabprevious<cr>", "Tab" },
      ["c"] = {
        function()
          if vim.o.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            require("gitsigns.actions").prev_hunk()
          end
        end,
        "Change | Hunk",
      },
    },
  }

  for _, func in ipairs { mapx.nnoremap, mapx.inoremap } do
    func("<F1>", "<cmd>lua require('core.utils.ui').toggle_colorcolumn()<cr>", "Toggle Colorcolumn")
  end
  mapx.nnoremap("m<space>", "<cmd>delmarks!<cr>", "Delete All Marks")
  mapx.nnoremap("g?", "<cmd>WhichKey<cr>", "WhichKey")
  mapx.nnoremap("gx", system_open, "Open the file under cursor with system app")
  which_key.register {
    ["<leader>a"] = {
      function()
        require("ts-node-action").node_action()
      end,
      "TS Node Action",
    },
    dp = {
      function()
        if vim.o.diff then
          vim.cmd.diffput()
        else
          require("gitsigns").stage_hunk()
        end
      end,
      "Diff Put | Stage Hunk",
    },
    du = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo Stage Hunk",
    },
    ["do"] = {
      function()
        if vim.o.diff then
          vim.cmd.diffget()
        else
          require("gitsigns").reset_hunk()
        end
      end,
      "Diff Get | Reset Hunk",
    },
  }

  mapx.vnoremap("<", "<gv")
  mapx.vnoremap(">", ">gv")

  mapx.cnoremap("<C-h>", "<Left>")
  mapx.cnoremap("<C-j>", "<Down>")
  mapx.cnoremap("<C-k>", "<Up>")
  mapx.cnoremap("<C-l>", "<Right>")
end

function M.setup_zenmode()
  mapx.nnoremap("<leader>z", "<cmd>ZenMode<cr>", "ZenMode")
end

function M.setup_dap()
  local keymaps = {
    name = "Debug",
    e = { "<Cmd>lua require('dapui').eval()<cr>", "Eval Expression" },
    f = { "<Cmd>lua require('dapui').float_element()<cr>", "Float Element" },
    d = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    D = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    s = {
      function()
        require("telescope").extensions.dap.configurations()
      end,
      "Start",
    },
    C = {
      function()
        require("telescope").extensions.dap.commands()
      end,
      "Commands",
    },
    l = {
      function()
        require("telescope").extensions.dap.list_breakpoints()
      end,
      "List Breakpoints",
    },
  }
  if myvim.plugins.dap_virtual_text.active then
    keymaps.V = { "<Cmd>DapVirtualTextToggle<cr>", "Toggle Virtual Text" }
  end
  which_key.register { ["<leader>d"] = keymaps }
  mapx.vnoremap("<leader>de", "<Cmd>lua require('dapui').eval()<cr>", "Eval Expression")
end

function M.setup_git()
  local function fugitive_diff()
    -- find all window in current tab, ignoring floating_window
    local tabnr = vim.api.nvim_get_current_tabpage()
    local wininfo = vim.tbl_filter(function(info)
      return vim.api.nvim_win_get_config(info.winid).relative == "" and info.tabnr == tabnr
    end, vim.fn.getwininfo())
    if #wininfo == 1 then
      vim.cmd "Gvdiff"
    else
      vim.cmd "Gtabedit | Gdiffsplit"
    end
  end

  -- git
  for _, key in ipairs { "d", "j", "k", "g", "s", "r", "u", "R" } do
    lvim.builtin.which_key.mappings.g[key] = nil
  end

  vim.keymap.set({ "o", "x" }, "ih", function()
    require("gitsigns.actions").select_hunk()
  end, { desc = "Hunk" })

  which_key.register {
    ["<leader>g"] = {
      name = "Git",
      -- d = { fugitive_diff, "Git Diff" },
      d = { "<cmd>DiffviewOpen<cr>", "Diff View" },
      h = { "<cmd>DiffviewFileHistory<cr>", "Diff History" },
      H = { "<cmd>DiffviewFileHistory %<cr>", "Diff History (for current file)" },
      g = { require("core.utils.ui").toggle_fugitive, "Toggle Status" },
      t = { M.chain("Gitsigns toggle_deleted", "Gitsigns toggle_word_diff"), "Toggle Inline Diff" },
      y = {
        function()
          require("gitlinker").get_buf_range_url "n"
        end,
        "Copy Permanent Link",
      },
    },
  }
  which_key.register({
    ["<leader>g"] = {
      name = "Git",
      y = {
        function()
          require("gitlinker").get_buf_range_url "v"
        end,
        "Copy Permanent Link",
      },
    },
  }, {
    mode = "v",
  })
end

function M.setup_toggle()
  which_key.register {
    ["<leader>t"] = {
      name = "Toggle",
      q = { "<cmd>call QuickFixToggle()<cr>", "Quickfix" },
      l = { "<cmd>call auxlib#toggle_loclist()<cr>", "LocList" },
      d = { "<cmd>lua require('core.utils.lsp').toggle_diagnostics()<cr>", "Diagnostic" },
      a = { "<cmd>AerialToggle!<cr>", "Aerial" },
      u = { "<cmd>UndotreeToggle<cr>", "Undotree" },
      c = { "<cmd>ColorizerToggle<cr>", "Colorizer" },
      b = { "<cmd>TableModeToggle<cr>", "Table Mode" },
      z = { "<cmd>Twilight<cr>", "Toggle Twilight" },
      t = { "<cmd>OverseerToggle<cr>", "Toggle Overseer" },
    },
  }
end

function M.setup_treesitter()
  mapx.nname("<leader>T", "Treesitter")
  mapx.nnoremap("<leader>Tc", "<cmd>TSConfigInfo<cr>", "Config Info")
  mapx.nnoremap("<leader>Tm", "<cmd>TSModuleInfo<cr>", "Module Info")
  mapx.nnoremap("<leader>Tp", "<cmd>TSPlaygroundToggle<cr>", "Playground")
  if vim.inspect_pos ~= nil then
    mapx.nnoremap("<leader>Th", "<cmd>Inspect<cr>", "Highlight Info")
  else
    mapx.nnoremap("<leader>Th", "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight Info")
  end
  mapx.nnoremap("<leader>Ts", "<cmd>TSUpdate<cr>", "Update Treesitter Parser")
end

function M.setup_ufo()
  if not myvim.plugins.ufo.active then
    return
  end

  local key_to_function_names = {
    zR = { "openAllFolds", "Open all folds" },
    zM = { "closeAllFolds", "Close all folds" },
    zr = { "openFoldsExceptKinds", "Fold less" },
    zm = { "closeFoldsWith", "Fold more" },
  }
  for key, info in pairs(key_to_function_names) do
    local fname, desc = unpack(info, 1, 2)
    vim.keymap.set("n", key, function()
      require("ufo")[fname]()
    end, { desc = desc })
  end
end

function M.setup_explorer()
  if myvim.plugins.oil.active then
    vim.keymap.set("n", "-", function()
      require("oil").open()
    end, { desc = "Open parent directory" })
  end

  if not myvim.plugins.nvimtree.active then
    lvim.builtin.which_key.mappings.e = nil
  end
end

function M.setup_package_management()
  which_key.register {
    ["<leader>pm"] = { "<cmd>Mason<cr>", "Mason" },
  }
end

function M.setup()
  M.setup_basic()
  M.setup_toggle()
  M.setup_easy_align()
  M.setup_terminal()
  M.setup_lsp()
  M.setup_asynctasks()
  M.setup_sniprun()
  M.setup_zenmode()
  M.setup_dap()
  M.setup_git()
  M.setup_find()
  M.setup_treesitter()
  M.setup_ufo()
  M.setup_explorer()
  M.setup_package_management()
end

M.setup()

return M
