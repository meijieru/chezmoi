local M = {}

local Log = require "lvim.core.log"
local safe_load = require("core.utils").safe_load

vim.cmd [[packadd which-key.nvim]]
local status_ok, which_key = safe_load "which-key"
if not status_ok then
  return M
end

local status_ok, mapx = safe_load "mapx"
if not status_ok then
  return M
end
mapx.setup { global = false, whichkey = true, debug = false }

local function escape(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- HACK
local function enhance_align()
  if not packer_plugins["vim-easy-align"].loaded then
    vim.cmd [[packadd vim-easy-align]]
  end
  return escape "<Plug>(EasyAlign)"
end

function M.setup_easy_align()
  local label = "EasyAlign"
  mapx.nmap("ga", enhance_align, mapx.expr, label)
  mapx.xmap("ga", enhance_align, mapx.expr, label)
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

  mapx.nnoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.nnoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('t', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
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
  for _, key in ipairs { "w", "q", "/", "c", "f", "h" } do
    lvim.builtin.which_key.mappings[key] = nil
  end
  lvim.builtin.which_key.mappings["s"] = nil
  lvim.builtin.which_key.mappings["b"] = nil

  lvim.builtin.which_key.mappings["f"] = {
    name = "Find",
    b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffer" },
    -- FIXME(meijieru): function, bufTag
    d = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols" },
    w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    c = { "<cmd>Telescope command_history<cr>", "Find Commands History" },
    s = { "<cmd>Telescope search_history<cr>", "Find Search History" },
    S = {
      "<cmd>lua require'telescope'.extensions.luasnip.luasnip{}<cr>",
      "Find snippets",
    },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    n = { "<cmd>lua require('telescope').extensions.notify.notify()<cr>", "Notifications" },
    r = { "<cmd>Telescope frecency<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    P = { "<cmd>Telescope projects<cr>", "Projects" },
    p = { "<cmd>lua require('telescope.builtin').resume()<cr>", "Find Previous" },
    t = { "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "Find Tasks" },
    l = { "<cmd>lua require('telescope.builtin').loclist()<cr>", "Find Loclist" },
    q = { "<cmd>lua require('telescope.builtin').quickfix()<cr>", "Find QuickFix" },
  }
  mapx.nnoremap('<leader>fg', "'<cmd>Telescope live_grep<cr>' . expand('<cword>')", mapx.expr, "Grep")

  lvim.builtin.which_key.mappings.g.j = nil
  lvim.builtin.which_key.mappings.g.k = nil
  lvim.builtin.which_key.mappings.g.d = nil

  lvim.builtin.which_key.mappings["u"] = { "<cmd>UndotreeToggle<cr>", "Undotree" }

  -- lsp
  lvim.lsp.buffer_mappings.normal_mode["gr"] = {
    "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<cr>",
    "Goto References",
  }
end

function M.setup_asynctasks()
  local mappings = {
    ["<F5>"] = { "<cmd>AsyncTask file-run<cr>", "File Run" },
    ["<F6>"] = { "<cmd>AsyncTask file-build<cr>", "File Build" },
    ["<f7>"] = { "<cmd>AsyncTask project-run<cr>", "Project Run" },
    ["<f8>"] = { "<cmd>AsyncTask project-build<cr>", "Project Build" },
    ["<f10>"] = { "<cmd>call QuickFixToggle()<cr>", "Toggle Quickfix" },
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

function M.post_setup()
  -- NOTE: run with VimEnter
  Log:debug "Keymaps post_setup"
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

M.setup_lvim()
M.setup_basic()
M.setup_trouble()
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

return M
