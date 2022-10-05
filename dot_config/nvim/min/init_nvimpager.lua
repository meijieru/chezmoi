local on_windows = vim.loop.os_uname().version:match("Windows")
local function join_paths(...)
  local path_sep = on_windows and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

local function load_pack(dir)
  vim.cmd.packadd(dir)
end

local HOME = os.getenv("HOME")
local XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME") or join_paths(HOME, ".config")
local XDG_DATA_HOME = os.getenv("XDG_DATA_HOME") or join_paths(HOME, ".local/share")
local base_dir = join_paths(XDG_DATA_HOME, "lunarvim/site")
local package_root = base_dir .. "/pack"
local nvimpager_dir = join_paths(XDG_CONFIG_HOME, "nvimpager")
local compile_path = join_paths(nvimpager_dir, "plugin", "packer_compiled.lua")
local runtimes = { base_dir, nvimpager_dir }
for _, dir in ipairs(runtimes) do
  if not vim.tbl_contains(vim.opt.rtp:get(), dir) then
    vim.opt.rtp:append(dir)
  end
end

vim.o.packpath = vim.o.runtimepath
vim.cmd.packadd("packer.nvim")

local _, packer = pcall(require, "packer")
packer.startup({
  function(use)
    use({
      "meijieru/edge.nvim",
      opt = true,
      requires = { "rktjmp/lush.nvim", opt = true },
    })
    use({ "sainnhe/edge", opt = true })
    use({
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true, additional_vim_regex_highlighting = false },
        })
      end,
    })
    use({ "bronson/vim-visual-star-search" })
    use({
      "phaazon/hop.nvim",
      cmd = {
        "HopLineStart",
        "HopLineStartAC",
        "HopLineStartBC",
        "HopWord",
        "HopWordAC",
        "HopWordBC",
        "HopPattern",
        "HopChar1",
        "HopChar2",
      },
      module = { "hop" },
      config = function()
        require("hop").setup()
      end,
    })
  end,
  config = {
    package_root = package_root,
    compile_path = compile_path,
    log = { level = "debug" },
  },
})
if vim.fn.filereadable(compile_path) == 0 then
  packer.compile()
end

vim.o.clipboard = "unnamedplus"
vim.o.background = "light"
vim.g.mapleader = " "
-- imcompatible with nvimpager's setting
-- vim.o.scrolloff = 8
-- vim.o.sidescrolloff = 8

load_pack("lush.nvim")
load_pack("edge.nvim")
vim.cmd.colorscheme("edge_lush")

-- prevent load tpipeline
vim.g.loaded_tpipeline = 1

--- keymap
load_pack("mapx.nvim")
local mapx = require("mapx")
local function setup_hop()
  local prefix = "<leader><leader>"
  mapx.nname(prefix, "Hop")
  local mappings = {
    w = { "<cmd>HopWordAC<CR>", "Forward Words" },
    b = { "<cmd>HopWordBC<CR>", "Backward Words" },
    j = { "<cmd>HopLineStartAC<CR>", "Forward Lines" },
    k = { "<cmd>HopLineStartBC<CR>", "Backward Lines" },
    s = { "<cmd>HopPattern<CR>", "Search Patterns" },
  }
  for key, val in pairs(mappings) do
    mapx.nnoremap(prefix .. key, val[1], mapx.silent, val[2])
  end

  -- stylua: ignore start
  mapx.nnoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.nnoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>")
  mapx.onoremap('t', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
  mapx.onoremap('T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
  -- stylua: ignore end
end
setup_hop()

--- autocmd
local gid = vim.api.nvim_create_augroup("lua_highlight", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = gid,
  pattern = { "*" },
  callback = function()
    require("vim.highlight").on_yank({ higroup = "Search", timeout = 200 })
  end,
})
