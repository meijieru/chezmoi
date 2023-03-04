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

local function normal_command(command)
  return string.format("<cmd>%s<cr>", command)
end

local function lua_normal_command(command)
  return normal_command(string.format("lua %s", command))
end

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
      ["g"] = { normal_command "Neogen", "Generate Doc" },
      ["d"] = { normal_command "Telescope diagnostics bufnr=0", "Document Diagnostics" },
      ["D"] = { normal_command "Telescope diagnostics", "Workspace Diagnostics" },
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

function M.setup_neotest()
  if not myvim.plugins.neotest.active then
    return
  end
  which_key.register {
    ["<leader>u"] = {
      name = "Neotest",
      t = {
        function()
          require("neotest").summary.toggle()
        end,
        "Toggle Neotest",
      },
      u = {
        function()
          require("neotest").run.run { vim.api.nvim_buf_get_name(0) }
        end,
        "Run File",
      },
      n = {
        function()
          require("neotest").run.run()
        end,
        "Run Nearest",
      },
      l = {
        function()
          require("neotest").run.run_last()
        end,
        "Run Last",
      },
      d = {
        function()
          require("neotest").run.run { strategy = "dap" }
        end,
        "Run DAP",
      },
      o = {
        function()
          require("neotest").output.open { short = true }
        end,
        "Short Summary",
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
    ["<c-p>"] = { normal_command "Telescope commands", "Commands Palette" },
  }
  which_key.register {
    ["<leader>"] = {
      -- trick: <c-space> convert it as fuzzy
      ["*"] = { smart_default "live_grep", "Grep" },
      b = { normal_command "Telescope buffers", "Find Buffer" },
      ["/"] = { normal_command "Telescope search_history", "Find Search History" },
      f = {
        name = "Find",
        s = { lua_normal_command "require('telescope').extensions.luasnip.luasnip()", "Find snippets" },
        c = { normal_command "Telescope command_history", "Find Commands History" },
        f = { normal_command "Telescope find_files", "Find File" },
        h = { smart_default "help_tags", "Find Help" },
        m = { smart_default "man_pages", "Man Pages" },
        k = { normal_command "Telescope keymaps", "Keymaps" },
        b = { smart_default "current_buffer_fuzzy_find", "Grep Buffer" },
        l = { normal_command "Telescope loclist", "Find Loclist" },
        n = { lua_normal_command "require('telescope').extensions.notify.notify()", "Notifications" },
        p = { normal_command "Telescope resume", "Find Previous" },
        P = { normal_command "Telescope projects", "Projects" },
        q = { normal_command "Telescope quickfix", "Find QuickFix" },
        t = { normal_command "OverseerRun", "Find Tasks" },
        j = { normal_command "Telescope jumplist", "Find JumpList" },
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
        R = { normal_command "Telescope registers", "Registers" },
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

function M.setup_tasks()
  if myvim.plugins.overseer.active then
    local mappings = {
      ["<F5>"] = { normal_command "OverseerRun file-run", "File Run" },
      ["<F6>"] = { normal_command "OverseerRun file-build", "File Build" },
      ["<F8>"] = { normal_command "OverseerRun make", "Project Build" },
    }
    which_key.register(mappings, { silent = true })
  end
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
      ["d"] = { lua_normal_command "vim.diagnostic.goto_next()", "Diagnostic" },
      ["q"] = { normal_command "cnext", "Quickfix" },
      ["l"] = { normal_command "lnext", "Loclist" },
      ["b"] = { normal_command "bprevious", "Buffer" },
      ["t"] = { normal_command "tabnext", "Tab" },
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
      ["d"] = { lua_normal_command "vim.diagnostic.goto_prev()", "Diagnostic" },
      ["q"] = { normal_command "cprev", "Quickfix" },
      ["l"] = { normal_command "lprev", "Loclist" },
      ["b"] = { normal_command "bnext", "Buffer" },
      ["t"] = { normal_command "tabprevious", "Tab" },
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
        "Change | Hunk",
      },
    },
  }

  for _, func in ipairs { mapx.nnoremap, mapx.inoremap } do
    func("<F1>", lua_normal_command "require('core.utils.ui').toggle_colorcolumn()", "Toggle Colorcolumn")
  end
  mapx.nnoremap("m<space>", normal_command "delmarks!", "Delete All Marks")
  mapx.nnoremap("g?", normal_command "WhichKey", "WhichKey")
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
  mapx.nnoremap("<leader>z", normal_command "ZenMode", "ZenMode")
end

function M.setup_dap()
  for _, key in ipairs { "d", "s", "C" } do
    lvim.builtin.which_key.mappings.d[key] = nil
  end
  local keymaps = {
    name = "Debug",
    e = { lua_normal_command "require('dapui').eval()", "Eval Expression" },
    f = { lua_normal_command "require('dapui').float_element()<cr>", "Float Element" },
    d = { lua_normal_command "require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    D = { lua_normal_command "require'dap'.disconnect()<cr>", "Disconnect" },
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
    keymaps.V = { normal_command "DapVirtualTextToggle", "Toggle Virtual Text" }
  end
  which_key.register { ["<leader>d"] = keymaps }
  mapx.vnoremap("<leader>de", lua_normal_command "require('dapui').eval()<cr>", "Eval Expression")
end

function M.setup_git()
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
      d = { normal_command "DiffviewOpen", "Diff View" },
      h = { normal_command "DiffviewFileHistory", "Diff History" },
      H = { normal_command "DiffviewFileHistory %", "Diff History (for current file)" },
      g = { lua_normal_command "require('core.utils.ui').toggle_fugitive()", "Toggle Status" },
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
      --- Defined in LunarVim
      q = { normal_command "call QuickFixToggle()", "Quickfix" },
      l = { normal_command "call auxlib#toggle_loclist()", "LocList" },
      d = { lua_normal_command "require('core.utils.lsp').toggle_diagnostics()", "Diagnostic" },
      a = { normal_command "AerialToggle!", "Aerial" },
      c = { normal_command "ColorizerToggle", "Colorizer" },
      b = { normal_command "TableModeToggle", "Table Mode" },
      z = { normal_command "Twilight", "Toggle Twilight" },
      t = { normal_command "OverseerToggle", "Toggle Overseer" },
    },
  }
end

function M.setup_treesitter()
  mapx.nname("<leader>T", "Treesitter")
  mapx.nnoremap("<leader>Tc", normal_command "TSConfigInfo", "Config Info")
  mapx.nnoremap("<leader>Tm", normal_command "TSModuleInfo", "Module Info")
  mapx.nnoremap("<leader>Tp", normal_command "TSPlaygroundToggle", "Playground")
  if vim.inspect_pos ~= nil then
    mapx.nnoremap("<leader>Th", normal_command "Inspect", "Highlight Info")
  else
    mapx.nnoremap("<leader>Th", normal_command "TSHighlightCapturesUnderCursor", "Highlight Info")
  end
  mapx.nnoremap("<leader>Ts", normal_command "TSUpdate", "Update Treesitter Parser")
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
    ["<leader>pm"] = { normal_command "Mason", "Mason" },
  }
end

function M.setup()
  M.setup_basic()
  M.setup_toggle()
  M.setup_easy_align()
  M.setup_terminal()
  M.setup_lsp()
  M.setup_tasks()
  M.setup_sniprun()
  M.setup_zenmode()
  M.setup_dap()
  M.setup_git()
  M.setup_find()
  M.setup_treesitter()
  M.setup_neotest()
  M.setup_ufo()
  M.setup_explorer()
  M.setup_package_management()
end

M.setup()

return M
