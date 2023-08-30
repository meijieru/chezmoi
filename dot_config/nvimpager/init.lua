local joinpath = vim.fs.joinpath

local HOME = os.getenv("HOME")
local XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME") or joinpath(HOME, ".config")
local XDG_DATA_HOME = os.getenv("XDG_DATA_HOME") or joinpath(HOME, ".local/share")
local runtime_dir = joinpath(XDG_DATA_HOME, "nvimpager")
local config_dir = joinpath(XDG_CONFIG_HOME, "nvimpager")
-- Reuse nvim lazy.nvim
local lazy_dir = joinpath(XDG_DATA_HOME, "nvim", "lazy", "lazy.nvim")
local plugins_dir = joinpath(runtime_dir, "lazy")
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
    branch = "main",
    opts = {
      auto_install = true,
    },
    lazy = false,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = false } } },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },
}
local opts = {
  defaults = {
    lazy = true,
  },
  install = {
    missing = true,
    colorscheme = { colorscheme },
  },
  ui = {
    border = "rounded",
  },
  root = plugins_dir,
  lockfile = joinpath(config_dir, "lazy-lock.json"),
  performance = {
    rtp = {
      reset = false,
    },
  },
  readme = {
    root = joinpath(runtime_dir, "lazy", "readme"),
  },
}

lazy.setup(plugins, opts)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start)
  end,
})

vim.o.background = "light"
vim.o.termguicolors = true
vim.g.mapleader = " "

-- imcompatible with nvimpager's setting
-- vim.o.scrolloff = 8
-- vim.o.sidescrolloff = 8

vim.cmd.colorscheme(colorscheme)
