local M = {}
local conf = require "modules.editor.config"

M["kylechui/nvim-surround"] = {
  version = "*",
  opts = {},
  event = "User FileOpened",
}
M["tpope/vim-rsi"] = { event = { "CmdlineEnter", "InsertEnter" } }
M["tpope/vim-eunuch"] = { event = "CmdlineEnter" }

M["Darazaki/indent-o-matic"] = {
  -- no need for lazy, very lightweight
  opts = {},
}

M["ibhagwan/smartyank.nvim"] = {
  event = { "VeryLazy" },
  opts = {
    highlight = {
      higroup = "Search", -- highlight group of yanked text
      timeout = 200, -- timeout for clearing the highlight
    },
    osc52 = {
      escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
    },
  },
  enabled = myvim.plugins.smartyank.active,
}

M["kevinhwang91/nvim-ufo"] = {
  event = "User FileOpened",
  dependencies = "kevinhwang91/promise-async",
  config = conf.ufo,
  init = function()
    -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
    local _make_client_capabilities = vim.lsp.protocol.make_client_capabilities
    vim.lsp.protocol.make_client_capabilities = function()
      local capabilities = _make_client_capabilities()
      if capabilities.textDocument.foldingRange ~= nil then
        vim.notify("foldingRange added", "warn", { title = "Ufo Init" })
      end
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      return capabilities
    end
  end,
  enabled = myvim.plugins.ufo.active,
}

M["ggandor/leap.nvim"] = {
  event = { "VeryLazy" },
  dependencies = {
    {
      "ggandor/flit.nvim",
      opts = { labeled_modes = "nv" },
      enabled = (myvim.plugins.leap.active and myvim.plugins.flit.active),
    },
  },
  config = conf.leap,
  enabled = myvim.plugins.leap.active,
}

M["mg979/vim-visual-multi"] = {
  keys = {
    { "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", desc = "VM Add Cursor Down" },
    { "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", desc = "VM Add Cursor Up" },
    { "<C-n>", "<Plug>(VM-Find-Under)", desc = "VM Find Under" },
    { "<C-n>", "<Plug>(VM-Find-Subword-Under)", mode = "x", desc = "VM Find Under" },
  },
  init = conf.visual_multi,
}

M["stevearc/aerial.nvim"] = {
  cmd = { "AerialToggle", "AerialPrev", "AerialNext", "AerialPrevUp", "AerialNextUp" },
  config = conf.aerial,
  enabled = myvim.plugins.aerial.active,
}

M["SmiteshP/nvim-navbuddy"] = {
  lazy = true,
  init = function()
    local augroup = vim.api.nvim_create_augroup("navbuddy", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client.server_capabilities.documentSymbolProvider then
          return
        end
        require("nvim-navbuddy").attach(client, bufnr)
      end,
    })
  end,
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local actions = require "nvim-navbuddy.actions"
    require("nvim-navbuddy").setup {
      lsp = { auto_attach = false },
      window = {
        border = "rounded",
        size = "70%",
        sections = {
          left = { size = "30%" },
        },
      },
      mappings = {
        ["t"] = actions.telescope {},
      },
    }
  end,
  enabled = myvim.plugins.navbuddy.active,
}

M["kana/vim-textobj-indent"] = { event = "VeryLazy", dependencies = { "kana/vim-textobj-user" } }
M["jceb/vim-textobj-uri"] = { event = "VeryLazy", dependencies = { "kana/vim-textobj-user" } }

M["dhruvasagar/vim-table-mode"] = {
  cmd = "TableModeToggle",
}
M["junegunn/vim-easy-align"] = {
  keys = { "<Plug>(EasyAlign)" },
  cmd = "EasyAlign",
}
M["andymass/vim-matchup"] = {
  event = "User FileOpened",
  config = conf.matchup,
  init = function()
    lvim.builtin.treesitter.matchup.enable = true
  end,
}

M["ethanholz/nvim-lastplace"] = {
  event = "BufReadPre",
  config = conf.lastplace,
}

M["theHamsta/nvim-dap-virtual-text"] = {
  dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  cmd = { "DapVirtualTextToggle" },
  opts = {},
  enabled = myvim.plugins.dap_virtual_text.active and myvim.plugins.dap.active,
}
M["nvim-telescope/telescope-dap.nvim"] = {
  lazy = true,
  dependencies = { "mfussenegger/nvim-dap" },
  enabled = myvim.plugins.dap.active and myvim.plugins.telescope.active,
}
M["mfussenegger/nvim-dap-python"] = {
  dependencies = { "mfussenegger/nvim-dap" },
  ft = { "python" },
  enabled = myvim.plugins.dap.active,
}

M["nvim-treesitter/nvim-treesitter-textobjects"] = {
  event = "User FileOpened",
  dependencies = "nvim-treesitter",
}
M["HiPhish/nvim-ts-rainbow2"] = {
  event = "User FileOpened",
  init = function()
    lvim.builtin.treesitter.rainbow = {
      enable = true,
      disable = {},
      hlgroups = {
        "rainbowcol1",
        "rainbowcol2",
        "rainbowcol3",
        "rainbowcol4",
        "rainbowcol5",
        "rainbowcol6",
        "rainbowcol7",
      },
    }
  end,
  enabled = myvim.plugins.rainbow.active,
}

M["danymat/neogen"] = {
  cmd = { "Neogen" },
  dependencies = { "nvim-treesitter" },
  opts = {},
  enabled = myvim.plugins.neogen.active,
}

M["nvim-neotest/neotest"] = {
  lazy = true,
  dependencies = {
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-lua/plenary.nvim",
    "haydenmeade/neotest-jest",
  },
  config = conf.neotest,
  enabled = myvim.plugins.neotest.active,
}

M["rmagatti/auto-session"] = {
  event = "BufReadPre",
  dependencies = { "rmagatti/session-lens", opts = {}, enabled = myvim.plugins.telescope.active },
  opts = {
    log_level = "info",
    auto_session_suppress_dirs = { "~/" },
  },
  enabled = myvim.plugins.auto_session.active,
}

M["ckolkey/ts-node-action"] = {
  event = "User FileOpened",
  dependencies = { "nvim-treesitter" },
}

M["chrisgrieser/nvim-spider"] = {
  lazy = true,
  opts = {},
  enabled = myvim.plugins.spider.active,
}

return M
