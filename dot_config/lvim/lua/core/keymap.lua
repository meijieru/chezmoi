local M = {}
local which_key = require "which-key"

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
  vim.api.nvim_set_keymap("n", "ga", "v:lua.enhance_align()", { expr = true })
  vim.api.nvim_set_keymap("x", "ga", "v:lua.enhance_align()", { expr = true })
end

function _G.set_terminal_keymaps()
  -- TODO(meijieru): `vim-terminal-help` like `drop`
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<M-q>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<M-l>", [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
function M.setup_terminal()
  vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
end

function M.setup_sniprun()
  vim.api.nvim_set_keymap("v", "gr", "<Plug>SnipRun", { silent = true })
  vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRunOperator", { silent = true })
  vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
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

  lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  }
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

function M.post_setup()
  M.setup_sniprun()
end

function M.setup_basic()
  local mappings = {
    ["<f1>"] = { "<cmd>call auxlib#toggle_colorcolumn()<cr>", "Toggle colorcolumn" },
  }
  which_key.register(mappings, {})
end

M.setup_lvim()
M.setup_basic()
M.setup_easy_align()
M.setup_terminal()
M.setup_hop()
M.setup_lsp()
M.setup_gitsigns()
M.setup_asynctasks()
-- TODO(meijieru): more keymap
-- ["m<space>"] = { "<cmd>delmarks!<cr>" },

return M
