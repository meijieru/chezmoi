local on_windows = vim.loop.os_uname().version:match("Windows")
local function join_paths(...)
  local path_sep = on_windows and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

local HOME = os.getenv("HOME")
local XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME") or join_paths(HOME, ".config")
local XDG_DATA_HOME = os.getenv("XDG_DATA_HOME") or join_paths(HOME, ".local/share")
local runtime_dir = join_paths(XDG_DATA_HOME, "nvimpager")
local config_dir = join_paths(XDG_CONFIG_HOME, "nvimpager")
-- Reuse lvim lazy.nvim
local lazy_dir = join_paths(XDG_DATA_HOME, "lunarvim", "site", "pack", "lazy", "opt", "lazy.nvim")
local plugins_dir = join_paths(runtime_dir, "site", "pack", "lazy", "opt")
local runtimes = { config_dir, lazy_dir }
for _, dir in ipairs(runtimes) do
  if not vim.tbl_contains(vim.opt.rtp:get(), dir) then
    vim.opt.rtp:append(dir)
  end
end

local lazy_available, lazy = pcall(require, "lazy")
if not lazy_available then
  vim.notify("skipping loading plugins until lazy.nvim is installed", "warn")
  return
end

local colorscheme = "everforest"

local plugins = {
  { "sainnhe/everforest", lazy = false },
  {
    "ibhagwan/smartyank.nvim",
    event = { "VeryLazy" },
    opts = {
      highlight = {
        higroup = "Search",
        timeout = 200,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      })
    end,
  },
  {
    "ggandor/leap.nvim",
    event = { "VeryLazy" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
local opts = {
  install = {
    missing = true,
    colorscheme = { colorscheme },
  },
  ui = {
    border = "rounded",
  },
  root = plugins_dir,
  lockfile = join_paths(config_dir, "lazy-lock.json"),
  performance = {
    rtp = {
      reset = false,
    },
  },
  readme = {
    root = join_paths(runtime_dir, "lazy", "readme"),
  },
}

lazy.setup(plugins, opts)

vim.o.background = "light"
vim.o.termguicolors = true
vim.g.mapleader = " "

-- imcompatible with nvimpager's setting
-- vim.o.scrolloff = 8
-- vim.o.sidescrolloff = 8

vim.cmd.colorscheme(colorscheme)
