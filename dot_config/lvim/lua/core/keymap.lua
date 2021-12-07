local M = {}

local Log = require "lvim.core.log"
local utils = require "core.utils"

utils.load_pack("which-key.nvim", { skip_packer = true })
local status_ok, which_key = utils.safe_load "which-key"
if not status_ok then
  return M
end

local status_ok, mapx = utils.safe_load "mapx"
if not status_ok then
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

function M.ensure_loaded_wrapper(package, command)
  return function()
    utils.load_pack(package)
    return vim.api.nvim_replace_termcodes(command, true, true, true)
  end
end

function M.setup_easy_align()
  local label = "EasyAlign"
  local func = M.ensure_loaded_wrapper("vim-easy-align", "<Plug>(EasyAlign)")
  mapx.nmap("ga", func, mapx.expr, label)
  mapx.xmap("ga", func, mapx.expr, label)
end

function _G.set_terminal_keymaps()
  -- TODO(meijieru): `vim-terminal-help` like `drop`
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
  mapx.nname("<leader><leader>", "Hop")
  local mappings = {
    w = { ":HopWordAC<CR>", "Forward Words" },
    b = { ":HopWordBC<CR>", "Backward Words" },
    j = { ":HopLineStartAC<CR>", "Forward Lines" },
    k = { ":HopLineStartBC<CR>", "Backward Lines" },
    s = { ":HopPattern<CR>", "Search Patterns" },
  }
  local opts = {
    mode = "n",
    prefix = "<leader><leader>",
    silent = true,
    noremap = true,
    nowait = true,
  }
  which_key.register(mappings, opts)

  -- stylua: ignore start
  mapx.nnoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.nnoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('t', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
  -- stylua: ignore end
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
    mapx.nnoremap(_keymap, M.ensure_loaded_wrapper("aerial.nvim", "<cmd>Telescope aerial<cr>"), mapx.expr, _doc)
  else
    mapx.nnoremap(_keymap, "<cmd>Telescope lsp_document_symbols<cr>", _doc)
  end
end

function M.setup_gitsigns()
  mapx.nnoremap("]c", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", mapx.expr, "Next Hunk")
  mapx.nnoremap("[c", "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", mapx.expr, "Prev Hunk")
  mapx.onoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
  mapx.xnoremap("ih", ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>', "Hunk")
end

function M.setup_lvim()
  -- disable some defaults mappings
  for _, key in ipairs { "insert_mode", "normal_mode", "term_mode", "visual_mode", "visual_block_mode", "command_mode" } do
    lvim.keys[key] = {}
  end
  for _, key in ipairs { "/" } do
    lvim.builtin.which_key.vmappings[key] = nil
  end
  for _, key in ipairs { "w", "q", "/", "c", "f", "h", "s", "b", "T" } do
    lvim.builtin.which_key.mappings[key] = nil
  end

  lvim.builtin.which_key.mappings.g.j = nil
  lvim.builtin.which_key.mappings.g.k = nil
  lvim.builtin.which_key.mappings.g.d = nil

  -- lsp
  lvim.builtin.which_key.mappings.l.s = nil
  lvim.lsp.buffer_mappings.normal_mode["gr"] = {
    "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<cr>",
    "Goto References",
  }
end

function M.setup_find()
  local function smart_default(cmd, expr)
    return function()
      local word = vim.fn.expand(expr or "<cword>")
      if #word > 1 then
        -- meaningful word
        vim.cmd(string.format("Telescope %s default_text=%s", cmd, word))
      else
        vim.cmd("Telescope " .. cmd)
      end
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
  mapx.nnoremap("<leader>fg", smart_default "live_grep", "Grep")
  mapx.nnoremap("<leader>fh", smart_default "help_tags", "Find Help")
  mapx.nnoremap("<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
  mapx.nnoremap("<leader>fl", "<cmd>Telescope loclist<cr>", "Find Loclist")
  mapx.nnoremap("<leader>fn", "<cmd>Telescope notify<cr>", "Notifications")
  mapx.nnoremap("<leader>fp", "<cmd>Telescope resume<cr>", "Find Previous")
  mapx.nnoremap("<leader>fq", "<cmd>Telescope quickfix<cr>", "Find QuickFix")
  mapx.nnoremap("<leader>fs", "<cmd>Telescope search_history<cr>", "Find Search History")
  mapx.nnoremap("<leader>ft", "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "Find Tasks")

  mapx.vnoremap("<leader>*", '"zy:Telescope live_grep default_text=<C-r>z<cr>', "Grep")
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

  mapx.nnoremap("<F1>", "<cmd>lua require('modules.ui.utils').toggle_colorcolumn()<cr>", "Toggle Colorcolumn")
  mapx.nnoremap("m<space>", "<cmd>delmarks!<cr>", "Delete All Marks")
  mapx.nnoremap("-", "<cmd>NvimTreeOpen<cr>", "Open Directory")

  mapx.vnoremap("<", "<gv")
  mapx.vnoremap(">", ">gv")

  mapx.cnoremap("<C-h>", "<Left>")
  mapx.cnoremap("<C-j>", "<Down>")
  mapx.cnoremap("<C-k>", "<Up>")
  mapx.cnoremap("<C-l>", "<Right>")
end

function M.setup_trouble()
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
end

function M.setup_git()
  local function git_diff()
    local wininfo = vim.fn.getwininfo()
    if #wininfo == 1 then
      vim.cmd "Gvdiff"
    else
      vim.cmd "Gtabedit | Gdiffsplit"
    end
  end

  mapx.nnoremap("<leader>gd", git_diff, "Git Diff")
  mapx.nnoremap("<leader>gg", "<cmd>call auxlib#toggle_fugitive()<cr>", "Toggle Status")
end

-- NOTE: run with VimEnter
function M.post_setup()
  Log:warn "Keymaps post_setup is deprecated"
end

function M.setup_toggle()
  mapx.vname("<leader>t", "Toggle")
  mapx.nnoremap("<leader>tq", "<cmd>call QuickFixToggle()<cr>", "Quickfix")
  mapx.nnoremap("<leader>tl", "<cmd>call auxlib#toggle_loclist()<cr>", "LocList")
  mapx.nnoremap("<leader>te", "<cmd>lua require('modules.completion.lsp').toggle_diagnostics()<cr>", "Diagnostic")
  mapx.nnoremap("<leader>ta", "<cmd>AerialToggle!<cr>", "Aerial")
  mapx.nnoremap("<leader>tu", "<cmd>UndotreeToggle<cr>", "Undotree")
end

function M.setup_treesitter()
  mapx.vname("<leader>T", "Treesitter")
  mapx.nnoremap("<leader>Tc", "<cmd>TSConfigInfo<cr>", "Config Info")
  mapx.nnoremap("<leader>Tm", "<cmd>TSModuleInfo<cr>", "Module Info")
  mapx.nnoremap("<leader>Tp", "<cmd>TSPlaygroundToggle<cr>", "Playground")
end

M.setup_lvim()
M.setup_basic()
-- M.setup_trouble()
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

return M
