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

function _G.set_terminal_keymaps()
  local opts = { noremap = true, buffer = 0 }
  mapx.tnoremap("<M-q>", [[<C-\><C-n>]], opts)
  mapx.tnoremap("<M-h>", [[<C-\><C-n><C-W>h]], opts)
  mapx.tnoremap("<M-j>", [[<C-\><C-n><C-W>j]], opts)
  mapx.tnoremap("<M-k>", [[<C-\><C-n><C-W>k]], opts)
  mapx.tnoremap("<M-l>", [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
function M.setup_terminal()
  vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
end

function M.setup_sniprun()
  mapx.vmap("gr", "<Plug>SnipRun", mapx.silent, "SnipRun")
  mapx.nmap("<leader>r", "<Plug>SnipRunOperator", mapx.silent, "SnipRun")
  mapx.nmap("<leader>rr", "<Plug>SnipRun", mapx.silent, "SnipRun")
end

function M.setup_hop()
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

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
local function format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end
function M.setup_lsp()
  mapx.nnoremap("gm", format_range_operator, "Range Format")
  mapx.vnoremap("gm", format_range_operator, "Range Format")

  local _keymap = "<leader>ls"
  local _doc = "Document Symbols"
  if myvim.plugins.aerial.active then
    mapx.nnoremap(_keymap, _ensure_package_command("aerial.nvim", "<cmd>Telescope aerial<cr>"), mapx.expr, _doc)
  else
    mapx.nnoremap(_keymap, "<cmd>Telescope lsp_document_symbols<cr>", _doc)
  end
  mapx.nnoremap("<leader>lg", "<cmd>Neogen<cr>", "Generate Doc")
  mapx.nnoremap("<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics")
  mapx.nnoremap("<leader>lw", "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics")
  mapx.nnoremap("]e", "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic")
  mapx.nnoremap("[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic")
end

function M.setup_gitsigns()
  mapx.nnoremap("]c", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", mapx.expr, "Next Hunk")
  mapx.nnoremap("[c", "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", mapx.expr, "Prev Hunk")
  mapx.onoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
  mapx.xnoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
  mapx.nnoremap("<leader>gt", M.chain("Gitsigns toggle_deleted", "Gitsigns toggle_word_diff"), "Toggle Inline Diff")
end

function M.setup_lvim()
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

  -- git
  for _, key in ipairs { "d", "j", "k" } do
    lvim.builtin.which_key.mappings.g[key] = nil
  end

  -- lsp
  for _, key in ipairs { "j", "k", "s", "d", "w" } do
    lvim.builtin.which_key.mappings.l[key] = nil
  end
  -- lsp_signature.nvim already did it
  lvim.lsp.buffer_mappings.normal_mode["gs"] = nil
  lvim.lsp.buffer_mappings.normal_mode["gd"] = {
    "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
    "Goto Definition",
  }
  lvim.lsp.buffer_mappings.normal_mode["gr"] = {
    "<cmd>lua require('telescope.builtin').lsp_references()<cr>",
    "Goto References",
  }
  lvim.lsp.buffer_mappings.normal_mode["gI"] = {
    "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>",
    "Goto Implementation",
  }
  -- lvim.lsp.buffer_mappings.normal_mode["gD"] = {
  --   "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>",
  --   "Goto Type Definitions",
  -- }
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
      local command = string.format("Telescope %s default_text=%s", cmd, content:gsub(" ", "\\ "))
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
  mapx.nnoremap({ "<leader>fg", "<leader>*" }, smart_default "live_grep", "Grep")
  mapx.nnoremap("<leader>fh", smart_default "help_tags", "Find Help")
  mapx.nnoremap("<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
  mapx.nnoremap("<leader>fl", "<cmd>Telescope loclist<cr>", "Find Loclist")
  mapx.nnoremap("<leader>fn", "<cmd>Telescope notify<cr>", "Notifications")
  mapx.nnoremap("<leader>fp", "<cmd>Telescope resume<cr>", "Find Previous")
  mapx.nnoremap("<leader>fq", "<cmd>Telescope quickfix<cr>", "Find QuickFix")
  mapx.nnoremap("<leader>fs", "<cmd>Telescope search_history<cr>", "Find Search History")
  mapx.nnoremap("<leader>ft", "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "Find Tasks")
  mapx.nnoremap("<leader>fj", "<cmd>Telescope jumplist<cr>", "Find JumpList")

  mapx.vname("<leader>f", "Find")
  mapx.vnoremap({ "<leader>fg", "<leader>*" }, visual_search "live_grep", "Grep")
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

  mapx.nnoremap("]q", ":cnext<CR>", "Next Quickfix")
  mapx.nnoremap("[q", ":cprev<CR>", "Previous Quickfix")
  mapx.nnoremap("]l", ":lnext<CR>", "Next Loclist")
  mapx.nnoremap("[l", ":lprev<CR>", "Previous Loclist")
  mapx.nnoremap("]b", ":bprevious<CR>", "Next Buffer")
  mapx.nnoremap("[b", ":bnext<CR>", "Previous Buffer")

  for _, func in ipairs { mapx.nnoremap, mapx.inoremap } do
    func("<F1>", "<cmd>lua require('core.utils.ui').toggle_colorcolumn()<cr>", "Toggle Colorcolumn")
  end
  mapx.nnoremap("m<space>", "<cmd>delmarks!<cr>", "Delete All Marks")
  mapx.nnoremap("-", "<cmd>NvimTreeOpen<cr>", "Open Directory")
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

function M.setup_trouble()
  if not myvim.plugins.trouble.active then
    return
  end
  lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<cr>", "Toggle" },
    w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Workspace" },
    d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
    r = { "<cmd>TroubleRefresh<cr>", "Refresh" },
  }

  mapx.nnoremap("]t", '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>', "Next Trouble")
  mapx.nnoremap("[t", '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>', "Previous Trouble")
end

function M.setup_zenmode()
  mapx.nname("<leader>z", "ZenMode")
  mapx.nnoremap("<leader>zz", "<cmd>ZenMode<cr>", "Toggle ZenMode")
  mapx.nnoremap("<leader>zt", "<cmd>Twilight<cr>", "Toggle Twilight")
end

function M.setup_dap()
  mapx.vname("<leader>d", "Debug")
  mapx.vnoremap("<leader>de", "<Cmd>lua require('dapui').eval()<cr>", "Eval Expression")
  mapx.nnoremap("<leader>df", "<Cmd>lua require('dapui').float_element()<cr>", "Float Element")
  mapx.nnoremap("<leader>dT", "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI")
  mapx.nnoremap("<leader>dv", "<Cmd>DapVirtualTextToggle<cr>", "Toggle Virtual Text")
  mapx.nnoremap("<leader>dd", "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor")
  mapx.nnoremap("<leader>dD", "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect")
  if myvim.plugins.dap_telescope.active then
    mapx.nnoremap("<leader>ds", "<Cmd>Telescope dap configurations<cr>", "Start")
    mapx.nnoremap("<leader>dC", "<Cmd>Telescope dap commands<cr>", "Commands")
    mapx.nnoremap("<leader>dl", "<Cmd>Telescope dap list_breakpoints<cr>", "List Breakpoints")
  end
end

function M.setup_git()
  local function git_diff()
    -- find all window in current tab, ignoring floating_window
    local tabnr = vim.fn.tabpagenr()
    local wininfo = vim.tbl_filter(function(info)
      return vim.api.nvim_win_get_config(info.winid).relative == "" and info.tabnr == tabnr
    end, vim.fn.getwininfo())
    if #wininfo == 1 then
      vim.cmd "Gvdiff"
    else
      vim.cmd "Gtabedit | Gdiffsplit"
    end
  end

  mapx.vname("<leader>g", "Git")
  mapx.nnoremap("<leader>gd", git_diff, "Git Diff")
  mapx.nnoremap("<leader>gg", "<cmd>call auxlib#toggle_fugitive()<cr>", "Toggle Status")
  mapx.nnoremap("<leader>gy", "<cmd>lua require'gitlinker'.get_buf_range_url('n')<cr>", "Copy Permanent Link")
  mapx.vnoremap("<leader>gy", "<cmd>lua require'gitlinker'.get_buf_range_url('v')<cr>", "Copy Permanent Link")
end

function M.setup_toggle()
  mapx.nname("<leader>t", "Toggle")
  mapx.nnoremap("<leader>tq", "<cmd>call QuickFixToggle()<cr>", "Quickfix")
  mapx.nnoremap("<leader>tl", "<cmd>call auxlib#toggle_loclist()<cr>", "LocList")
  mapx.nnoremap("<leader>te", "<cmd>lua require('core.utils.lsp').toggle_diagnostics()<cr>", "Diagnostic")
  mapx.nnoremap("<leader>ta", "<cmd>AerialToggle!<cr>", "Aerial")
  mapx.nnoremap("<leader>tu", "<cmd>UndotreeToggle<cr>", "Undotree")
  mapx.nnoremap("<leader>tc", "<cmd>ColorizerToggle<cr>", "Colorizer")
  mapx.nnoremap("<leader>tb", "<cmd>TableModeToggle<cr>", "Table Mode")
end

function M.setup_treesitter()
  mapx.nname("<leader>T", "Treesitter")
  mapx.nnoremap("<leader>Tc", "<cmd>TSConfigInfo<cr>", "Config Info")
  mapx.nnoremap("<leader>Tm", "<cmd>TSModuleInfo<cr>", "Module Info")
  mapx.nnoremap("<leader>Tp", "<cmd>TSPlaygroundToggle<cr>", "Playground")
  mapx.nnoremap("<leader>Th", "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight Info")
end

function M.setup_visual_multi()
  mapx.nmap("<C-Down>", "<Plug>(VM-Add-Cursor-Down)", "VM Add Cursor Down")
  mapx.nmap("<C-Up>", "<Plug>(VM-Add-Cursor-Up)", "VM Add Cursor Up")
  mapx.nmap("<C-n>", "<Plug>(VM-Find-Under)", "VM Find Under")
end

function M.setup()
  M.setup_lvim()
  M.setup_basic()
  M.setup_trouble()
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
end

-- NOTE: run with VimEnter
function M.post_setup()
  Log:warn "Keymaps post_setup is deprecated"
end

M.setup()

return M
