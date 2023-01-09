local M = {}

local Log = require "core.log"
local utils = require "core.utils"

utils.load_pack("which-key.nvim", { skip_packer = true })
local status_whichkey_ok, which_key = utils.safe_load "which-key"
if not status_whichkey_ok then
  return M
end

utils.load_pack("mapx.nvim", { skip_packer = true })
local status_mapx_ok, mapx = utils.safe_load "mapx"
if not status_mapx_ok then
  return M
end
mapx.setup { global = false, whichkey = true, debug = false }

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

local function _ensure_package_command(package, command)
  return function()
    utils.load_pack(package)
    return vim.api.nvim_replace_termcodes(command, true, true, true)
  end
end

function M.setup_easy_align()
  local label = "EasyAlign"
  local func = _ensure_package_command("vim-easy-align", "<Plug>(EasyAlign)")
  mapx.nmap("ga", func, mapx.expr, label)
  mapx.xmap("ga", func, mapx.expr, label)
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

function M.setup_hop()
  if not myvim.plugins.hop.active then
    return
  end
  local prefix = "<leader><leader>"
  mapx.nname(prefix, "Hop")
  local mappings = {
    w = { "<cmd>HopWordAC<CR>", "Forward Words" },
    b = { "<cmd>HopWordBC<CR>", "Backward Words" },
    j = { "<cmd>HopLineStartAC<CR>", "Forward Lines" },
    k = { "<cmd>HopLineStartBC<CR>", "Backward Lines" },
    s = { "<cmd>HopPattern<CR>", "Search Patterns" },
    l = { "<cmd>HopLineStartMW<CR>", "Windows Lines" },
  }
  for key, val in pairs(mappings) do
    mapx.nnoremap(prefix .. key, val[1], mapx.silent, val[2])
  end

  if myvim.plugins.hop.enable_ft then
    local function hint_char1(opts)
      return string.format("<cmd>lua require'hop'.hint_char1({%s, current_line_only = true})<cr>", opts)
    end
    mapx.nnoremap("f", hint_char1 "direction = require'hop.hint'.HintDirection.AFTER_CURSOR")
    mapx.nnoremap("F", hint_char1 "direction = require'hop.hint'.HintDirection.BEFORE_CURSOR")
    mapx.onoremap("f", hint_char1 "direction = require'hop.hint'.HintDirection.AFTER_CURSOR, inclusive_jump = true")
    mapx.onoremap("F", hint_char1 "direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, inclusive_jump = true")
    mapx.onoremap("t", hint_char1 "direction = require'hop.hint'.HintDirection.AFTER_CURSOR")
    mapx.onoremap("T", hint_char1 "direction = require'hop.hint'.HintDirection.BEFORE_CURSOR")
  end
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
            utils.load_pack "aerial.nvim"
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

function M.setup_gitsigns()
  mapx.onoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
  mapx.xnoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
  mapx.nnoremap("<leader>gt", M.chain("Gitsigns toggle_deleted", "Gitsigns toggle_word_diff"), "Toggle Inline Diff")
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

  mapx.nname("<leader>f", "Find")
  mapx.nnoremap("<leader>fC", "<cmd>Telescope commands<cr>", "Commands")
  mapx.nnoremap("<leader>fM", "<cmd>Telescope man_pages<cr>", "Man Pages")
  mapx.nnoremap("<leader>fP", "<cmd>Telescope projects<cr>", "Projects")
  mapx.nnoremap("<leader>fR", "<cmd>Telescope registers<cr>", "Registers")
  mapx.nnoremap("<leader>fS", "<cmd>lua require'telescope'.extensions.luasnip.luasnip{}<cr>", "Find snippets")
  mapx.nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>", "Find Buffer")
  mapx.nnoremap("<leader>fc", "<cmd>Telescope command_history<cr>", "Find Commands History")
  mapx.nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>", "Find File")
  mapx.nnoremap("<leader>*", smart_default "live_grep", "Grep")
  mapx.nnoremap("<leader>fh", smart_default "help_tags", "Find Help")
  mapx.nnoremap("<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
  mapx.nnoremap("<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Grep Buffer")
  mapx.nnoremap("<leader>fL", "<cmd>Telescope loclist<cr>", "Find Loclist")
  mapx.nnoremap("<leader>fn", "<cmd>Telescope notify<cr>", "Notifications")
  mapx.nnoremap("<leader>fp", "<cmd>Telescope resume<cr>", "Find Previous")
  mapx.nnoremap("<leader>fq", "<cmd>Telescope quickfix<cr>", "Find QuickFix")
  mapx.nnoremap("<leader>fs", "<cmd>Telescope search_history<cr>", "Find Search History")
  mapx.nnoremap("<leader>ft", "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "Find Tasks")
  mapx.nnoremap("<leader>fj", "<cmd>Telescope jumplist<cr>", "Find JumpList")

  mapx.vname("<leader>f", "Find")
  mapx.vnoremap("<leader>*", visual_search "live_grep", "Grep")
  mapx.vnoremap("<leader>fh", visual_search "help_tags", "Find Help")
  local _keymap, _label = "<leader>fr", "Open Recent File"
  if myvim.plugins.telescope_frecency.active then
    mapx.nnoremap(_keymap, "<cmd>Telescope frecency<cr>", _label)
  else
    mapx.nnoremap(_keymap, "<cmd>Telescope oldfiles<cr>", _label)
  end
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
    if vim.fn.filereadable(cfile) == 1 or string.match(cfile, "[a-z]*://[^ >,;]*") ~= nil then
      vim.cmd(string.format("silent !xdg-open %s", cfile))
      return
    elseif is_github(cfile) then
      vim.cmd(string.format("silent !xdg-open https://github.com/%s", cfile))
      return
    end
    vim.notify(string.format("url %s invalid", cfile), "error")
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
        "Hunk",
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
        "Hunk",
      },
    },
  }

  for _, func in ipairs { mapx.nnoremap, mapx.inoremap } do
    func("<F1>", "<cmd>lua require('core.utils.ui').toggle_colorcolumn()<cr>", "Toggle Colorcolumn")
  end
  mapx.nnoremap("m<space>", "<cmd>delmarks!<cr>", "Delete All Marks")
  mapx.nnoremap("g?", "<cmd>WhichKey<cr>", "WhichKey")
  mapx.nnoremap("gx", system_open, "Open the file under cursor with system app")
  -- mapx.nnoremap(
  --   "dg",
  --   "&diff ? '<cmd>diffget<cr>' : '<cmd>lua require\"core.keymap\".not_impl()<CR>'",
  --   mapx.expr,
  --   "Diff Get"
  -- )

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
  mapx.vname("<leader>d", "Debug")
  mapx.vnoremap("<leader>de", "<Cmd>lua require('dapui').eval()<cr>", "Eval Expression")
  mapx.nnoremap("<leader>de", "<Cmd>lua require('dapui').eval()<cr>", "Eval Expression")
  mapx.nnoremap("<leader>df", "<Cmd>lua require('dapui').float_element()<cr>", "Float Element")
  mapx.nnoremap("<leader>dd", "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor")
  mapx.nnoremap("<leader>dD", "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect")
  if myvim.plugins.dap_telescope.active then
    mapx.nnoremap("<leader>ds", "<Cmd>Telescope dap configurations<cr>", "Start")
    mapx.nnoremap("<leader>dC", "<Cmd>Telescope dap commands<cr>", "Commands")
    mapx.nnoremap("<leader>dl", "<Cmd>Telescope dap list_breakpoints<cr>", "List Breakpoints")
  end
  if myvim.plugins.dap_virtual_text.active then
    mapx.nnoremap("<leader>dV", "<Cmd>DapVirtualTextToggle<cr>", "Toggle Virtual Text")
  end
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
  for _, key in ipairs { "d", "j", "k", "g" } do
    lvim.builtin.which_key.mappings.g[key] = nil
  end

  which_key.register {
    ["<leader>g"] = {
      name = "Git",
      -- d = { fugitive_diff, "Git Diff" },
      d = { "<cmd>DiffviewOpen<cr>", "Diff View" },
      h = { "<cmd>DiffviewFileHistory<cr>", "Diff History" },
      H = { "<cmd>DiffviewFileHistory %<cr>", "Diff History (for current file)" },
      g = { require("core.utils.ui").toggle_fugitive, "Toggle Status" },
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
      t = { "<cmd>Twilight<cr>", "Toggle Twilight" },
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

function M.setup_visual_multi()
  vim.keymap.set("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", { desc = "VM Add Cursor Down" })
  vim.keymap.set("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", { desc = "VM Add Cursor Up" })
  vim.keymap.set("n", "<C-n>", "<Plug>(VM-Find-Under)", { desc = "VM Find Under" })
  vim.keymap.set("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", { desc = "VM Find Under" })
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
  M.setup_hop()
  M.setup_lsp()
  M.setup_gitsigns()
  M.setup_asynctasks()
  M.setup_sniprun()
  M.setup_zenmode()
  M.setup_dap()
  M.setup_git()
  M.setup_find()
  M.setup_treesitter()
  M.setup_visual_multi()
  M.setup_ufo()
  M.setup_explorer()
  M.setup_package_management()
end

M.setup()

return M
