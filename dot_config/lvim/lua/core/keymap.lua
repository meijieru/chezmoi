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

local escape = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- HACK
function _G.enhance_align()
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
  local mappings = {
    w = { ":HopWordAC<CR>", "Forward Words" },
    b = { ":HopWordBC<CR>", "Backward Words" },
    j = { ":HopLineStartAC<CR>", "Forward Lines" },
    k = { ":HopLineStartBC<CR>", "Backward Lines" },
    s = { ":HopPattern<CR>", "Search Patterns" },
  }
  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader><leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }
  which_key.register(mappings, opts)
end

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
function _G.format_range_operator()
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
  vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
  vim.api.nvim_set_keymap("v", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
end

function M.setup_gitsigns()
  which_key.register {
    ["]c"] = { "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", "Next Hunk", expr = true },
    ["[c"] = { "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", "Prev Hunk", expr = true },
    -- FIXME(meijieru): hunk text obj
    -- ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    -- ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  }
end

function M.setup_lvim()
  -- disable some defaults mappings
  for _, key in ipairs { "insert_mode", "normal_mode", "term_mode", "visual_mode", "visual_block_mode", "command_mode" } do
    lvim.keys[key] = {}
  end
  for _, key in ipairs { "/" } do
    lvim.builtin.which_key.vmappings[key] = nil
  end
  for _, key in ipairs { "w", "q", "/", "c", "f" } do
    lvim.builtin.which_key.mappings[key] = nil
  end
  lvim.builtin.which_key.mappings["s"] = nil

  lvim.builtin.which_key.mappings["f"] = {
    name = "Find",
    b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffer" },
    -- FIXME(meijieru): duplicate with lsp block
    -- FIXME(meijieru): function, bufTag
    d = {
      name = "Document-Wise Find",
      d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Diagnostics" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols" },
    },
    w = {
      name = "Workspace-Wise Find",
      d = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Diagnostics" },
      s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Symbols" },
    },
    c = { "<cmd>Telescope command_history<cr>", "Find Commands History" },
    s = { "<cmd>Telescope search_history<cr>", "Find Search History" },
    S = {
      "<cmd>lua require'telescope'.extensions.luasnip.luasnip{}<cr>",
      "Find snippets",
    },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope frecency<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    P = { "<cmd>Telescope projects<cr>", "Projects" },
    p = { "<cmd>lua require('telescope.builtin').resume()<cr>", "Find Previous" },
    t = { "<cmd>lua require('telescope').extensions.asynctasks.all()<cr>", "Find Tasks" },
    l = { "<cmd>lua require('telescope.builtin').loclist()<cr>", "Find Loclist" },
    q = { "<cmd>lua require('telescope.builtin').quickfix()<cr>", "Find QuickFix" },
  }

  lvim.builtin.which_key.mappings.g.j = nil
  lvim.builtin.which_key.mappings.g.k = nil
  lvim.builtin.which_key.mappings.g.d = nil
  lvim.builtin.which_key.mappings.g.v = { "<cmd>:Gvdiff<cr>", "Git Diff" }
  lvim.builtin.which_key.mappings.g.g = { "<cmd>call auxlib#toggle_fugitive()<cr>", "Toggle git status" }

  lvim.builtin.which_key.mappings["un"] = { ":UndotreeToggle<cr>", "UndotreeToggle" }

  lvim.builtin.which_key.mappings["dT"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" }
end

function M.setup_asynctasks()
  local mappings = {
    ["<F5>"] = { ":AsyncTask file-run<cr>", "File Run" },
    ["<F6>"] = { ":AsyncTask file-build<cr>", "File Build" },
    ["<f7>"] = { ":AsyncTask project-run<cr>", "Project Run" },
    ["<f8>"] = { ":AsyncTask project-build<cr>", "Project Build" },
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

  mapx.nnoremap("<F1>", "<cmd>call auxlib#toggle_colorcolumn()<cr>", "Toggle Colorcolumn")
  mapx.nnoremap("m<space>", "<cmd>delmarks!<cr>", "Delete All Marks")
  mapx.nnoremap("-", "<cmd>NvimTreeOpen<cr>", "Open Directory")
  -- TODO(meijieru)
  -- ["<leader>tq"] = ":call QuickFixToggle()<CR>",

  mapx.vnoremap("<", "<gv")
  mapx.vnoremap(">", ">gv")

  mapx.cnoremap("<c-h>", "<left>")
  mapx.cnoremap("<c-j>", "<down>")
  mapx.cnoremap("<c-k>", "<up>")
  mapx.cnoremap("<c-l>", "<right>")
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

  mapx.nmap("]t", '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>', "Next Trouble")
  mapx.nmap("[t", '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>', "Previous Trouble")
end

function M.post_setup()
  -- NOTE: run with VimEnter
  Log:debug "Keymaps post_setup"
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

return M
