return {

  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.motion.vim-matchup" },

  -- { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>fu",
        "<cmd>Telescope undo<cr>",
        desc = "Find undos",
      },
    },
    opts = function()
      local actions = require "telescope-undo.actions"
      return {
        mappings = {
          i = {
            ["<cr>"] = actions.restore,
          },
        },
      }
    end,
    config = function(_, config_opts)
      require("telescope").setup {
        extensions = {
          undo = config_opts,
        },
      }
    end,
  },

  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  {
    "zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
    opts = function(_, opts)
      if require("astrocore").is_available "nvim-scrollbar" then
        local on_open = opts.on_open
        local on_close = opts.on_close

        opts.on_open = function()
          on_open()
          vim.cmd "ScrollbarToggle"
        end
        opts.on_close = function()
          on_close()
          vim.cmd "ScrollbarToggle"
        end
      end
      return opts
    end,
  },

  { import = "astrocommunity.motion.flash-nvim" },
  {
    "flash.nvim",
    opts = { modes = { search = { enabled = false } } },
  },

  { import = "astrocommunity.project.project-nvim" },
  {
    "project.nvim",
    opts = function(_, opts)
      opts.ignore_lsp = nil
      opts.detection_methods = { "pattern", "lsp" }
      return opts
    end,
  },

  {
    "danymat/neogen",
    keys = function(_, _)
      return {
        {
          "<leader>lg",
          function() require("neogen").generate { type = "any" } end,
          desc = "Neogen",
        },
      }
    end,
    opts = {
      snippet_engine = "luasnip",
      languages = {
        lua = { template = { annotation_convention = "ldoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        typescriptreact = { template = { annotation_convention = "tsdoc" } },
      },
    },
  },

  -- TODO(meijieru): check community config
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", desc = "VM Add Cursor Down" },
      { "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", desc = "VM Add Cursor Up" },
      { "<C-n>", "<Plug>(VM-Find-Under)", desc = "VM Find Under" },
      { "<C-n>", "<Plug>(VM-Find-Subword-Under)", mode = "x", desc = "VM Find Under" },
    },
    init = function()
      local vm_maps = {}
      vm_maps["Select Operator"] = ""
      vm_maps["Undo"] = "u"
      vm_maps["Redo"] = "<C-r>"
      vm_maps["Reselect Last"] = "gs"
      -- useful default mappings
      -- \\z for normal everywhere
      -- ] for goto next
      -- [ for goto prev

      vim.g.VM_default_mappings = false
      vim.g.VM_maps = vm_maps
    end,
  },

  {
    "ckolkey/ts-node-action",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "<leader>a",
        function() require("ts-node-action").node_action() end,
        desc = "TS Node Action",
      },
    },
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", desc = "EasyAlign", mode = { "n", "x" } },
    },
  },

  {
    "ibhagwan/smartyank.nvim",
    event = { "VeryLazy" },
    opts = {
      highlight = {
        higroup = "Search", -- highlight group of yanked text
        timeout = 200, -- timeout for clearing the highlight
      },
      osc52 = {
        escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
      },
      validate_yank = function() return vim.tbl_contains({ "y", "d" }, vim.v.operator) end,
    },
  },

  { "tpope/vim-rsi", event = { "CmdlineEnter", "InsertEnter" } },
  { "tpope/vim-eunuch", event = "CmdlineEnter" },
}
