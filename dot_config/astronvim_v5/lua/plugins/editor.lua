return {

  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.motion.vim-matchup" },

  { import = "astrocommunity.motion.flash-nvim" },
  {
    "flash.nvim",
    opts = { modes = { search = { enabled = false } } },
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
