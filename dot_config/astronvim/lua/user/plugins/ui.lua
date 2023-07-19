return {
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },

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
      },
    },
  },

  { import = "astrocommunity.debugging.nvim-bqf" },
  {
    "nvim-bqf",
    opts = function(_, opts)
      opts.auto_resize_height = false
      return opts
    end,
  },

  { import = "astrocommunity.colorscheme.catppuccin" },
  {
    "catppuccin",
    opts = {
      color_overrides = {
        latte = {
          base = "#FAFAFA",
        },
      },
    },
  },

  { import = "astrocommunity.file-explorer.oil-nvim" },
  {
    "oil.nvim",
    opts = {
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      delete_to_trash = true,
      trash_command = "trash-put",
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
    -- TODO(meijieru): lazy load
    lazy = false,
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
}
