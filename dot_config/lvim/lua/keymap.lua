local M = {}

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
  local which_key = require "which-key"
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

function M.setup_lvim()
  lvim.builtin.which_key.mappings["d"]["T"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" }

  lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  }

  lvim.builtin.which_key.mappings["S"] = {
    "<cmd>lua require'telescope'.extensions.luasnip.luasnip{}<cr>",
    "Find snippets",
  }
end

function M.setup()
  M.setup_easy_align()
  M.setup_terminal()
  M.setup_sniprun()
  M.setup_hop()
  M.setup_lsp()
end

M.setup_lvim()

return M
