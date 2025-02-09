return {
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  {
    "dropbar.nvim",
    enabled = vim.fn.has "nvim-0.10" == 1,
  },

  { import = "astrocommunity.utility.noice-nvim" },
  {
    "noice.nvim",
    opts = {
      messages = {
        view_search = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
    },
  },

  { import = "astrocommunity.quickfix.quicker-nvim" },
  { import = "astrocommunity.quickfix.nvim-bqf" },
  {
    "nvim-bqf",
    opts = function(_, opts)
      opts.auto_resize_height = false
      return opts
    end,
  },

  { import = "astrocommunity.colorscheme.nordic-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  {
    "catppuccin",
    opts = {
      color_overrides = {
        latte = {
          base = "#FAFAFA",
        },
      },
      integrations = {
        blink_cmp = true,
        fidget = true,
      },
    },
  },

  -- { import = "astrocommunity.file-explorer.oil-nvim" },
  {
    "stevearc/oil.nvim",
    lazy = not vim.startswith(vim.fn.argv()[1] or "", "oil-ssh://"),
    opts = {
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      -- NOTE: `g\` for toggling trash
      delete_to_trash = true,
      keymaps = {
        ["."] = "actions.open_cmdline",
      },
      win_options = {
        -- https://github.com/stevearc/oil.nvim/issues/57
        concealcursor = "nc",
      },
    },
    keys = function(_, _)
      return {
        { "-", function() require("oil").open() end, desc = "Open parent directory" },
      }
    end,
  },

  { import = "astrocommunity.test.neotest" },
  {
    "neotest",
    opts = function(_, opts)
      opts.consumers = {
        overseer = require "neotest.consumers.overseer",
      }

      local animated_icons = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      opts.icons = {
        passed = " ",
        running = " ",
        failed = " ",
        unknown = " ",
        running_animated = vim.tbl_map(function(s) return s .. " " end, animated_icons),
        non_collapsible = " ",
        collapsed = "",
        expanded = "",
        child_prefix = " ",
        final_child_prefix = " ",
        child_indent = " ",
        final_child_indent = " ",
      }
      opts.quickfix = { open = false }
      opts.output = {
        open_on_run = false,
      }

      return opts
    end,
    -- TODO(meijieru): slow down python startup
    enabled = false,
  },

  {
    "vimpostor/vim-lumen",
    lazy = false,
    -- NOTE(meijieru): revisit after https://github.com/neovim/neovim/issues/19362
    enabled = false,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        override_vim_notify = false,
      },
    },
    lazy = true,
    event = { "VeryLazy" },
  },
}
