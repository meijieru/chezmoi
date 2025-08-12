local is_available = require("astrocore").is_available

return {
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  -- FIXME(meijieru): should be enabled, but https://github.com/AstroNvim/astrocommunity/blob/155e7216fda0e313a8271973623921ddef704fca/lua/astrocommunity/utility/noice-nvim/init.lua?plain=1#L55
  -- { import = "astrocommunity.utility.noice-nvim" },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
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
        hover = {
          enabled = false,
        },
      },

      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = is_available("inc-rename.nvim"), -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    event = "VeryLazy",
    enabled = myvim.plugins.noice.enabled,
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
      custom_highlights = function(colors)
        return {
          -- disable float since we have border
          NormalFloat = { bg = colors.base, fg = colors.text },
          FloatBorder = { bg = colors.base, fg = colors.text },
        }
      end,
      color_overrides = {
        latte = {
          base = "#FAFAFA",
        },
      },
      integrations = {
        snacks = {
          enabled = true,
          indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
        },
      },
    },
  },

  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  {
    "olimorris/onedarkpro.nvim",
    opts = {
      options = {
        cursorline = true,
        highlight_inactive_windows = false,
        terminal_colors = true,
      },
      highlights = {
        -- too much red
        ["@variable"] = {},
        ["@variable.builtin"] = { fg = "${red}", italic = true },
        ["@parameter"] = { fg = "${red}" },
        -- disable float since we have border
        NormalFloat = {},
        FloatBorder = {},
      },
      styles = {
        comments = "italic",
        keywords = "italic",
        constants = "italic",
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
        ["gy"] = "actions.yank_entry",
      },
      win_options = {
        -- https://github.com/stevearc/oil.nvim/issues/57
        concealcursor = "nc",
      },
    },
    keys = function(_, _)
      return {
        {
          "-",
          function()
            require("oil").open()
          end,
          desc = "Open parent directory",
        },
      }
    end,
  },

  { import = "astrocommunity.test.neotest" },
  {
    "neotest",
    opts = function(_, opts)
      opts.consumers = {
        overseer = require("neotest.consumers.overseer"),
      }

      local animated_icons = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      opts.icons = {
        passed = " ",
        running = " ",
        failed = " ",
        unknown = " ",
        running_animated = vim.tbl_map(function(s)
          return s .. " "
        end, animated_icons),
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
    "ColaMint/pokemon.nvim",
    config = function()
      local number_candidates = {
        "0025",
        "0039",
        "0104",
        "0105",
        "0116",
        "0131",
        "0006.3",
        "0735.1",
        "0196.1",
        "0628.2",
      }
      local number
      math.randomseed(os.time())
      if math.random() > 0.5 then
        number = "random"
      else
        number = number_candidates[math.random(#number_candidates)]
      end
      require("pokemon").setup({
        number = number,
        size = "tiny",
      })
    end,
    enabled = false,
  },
}
