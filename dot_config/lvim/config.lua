--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

vim.g.root_markers = { ".svn", ".git", ".root", ".project", ".env", ".vim" }

local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.did_load_filetypes = 1
end

disable_distribution_plugins()

-- speed up startup
-- $ANACONDA_HOME should be set in shell
local anaconda_home = os.getenv "ANACONDA_HOME"
if anaconda_home ~= nil then
  vim.g.python_host_prog = anaconda_home .. "/bin/python2"
  vim.g.python3_host_prog = anaconda_home .. "/bin/python3"
else
  vim.g.python_host_prog = "/usr/bin/python2"
  vim.g.python3_host_prog = "/usr/bin/python3"
end

function _G._my_load_vimscript(path)
  vim.cmd("source " .. vim.fn.expand "~/.config/lvim/" .. path)
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
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.telescope.active = true
lvim.builtin.bufferline.active = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
lvim.lsp.null_ls.setup = {
  root_dir = require("lspconfig").util.root_pattern(unpack(vim.g.root_markers)),
}
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "yapf" },
  { exe = "prettier" },
  { exe = "stylua", args = { "--search-parent-directories" } },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "black" },
--   {
--     exe = "eslint_d",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "javascriptreact" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  {
    "sainnhe/gruvbox-material",
    setup = function()
      vim.g.gruvbox_material_enable_italic = false
      vim.g.gruvbox_material_disable_italic_comment = true
    end,
    disable = false,
  },
  {
    "sainnhe/edge",
    setup = function()
      vim.g.edge_enable_italic = false
      vim.g.edge_disable_italic_comment = true
    end,
    disable = false,
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gvdiff",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    ft = { "fugitive" },
    fn = { "FugitiveGitDir" },
    disable = false,
  },
  {
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neogit").setup {}
    end,
    disable = true,
  },

  { "tpope/vim-unimpaired" },
  { "tpope/vim-surround", keys = { "c", "d", "y", "S" } },
  -- { "tpope/vim-abolish" },  -- FIXME(meijieru): remove due to use too less
  { "tpope/vim-repeat" },
  -- { 'tpope/vim-commentary'}, -- remove due to `Comment.nvim`
  -- { "tpope/vim-vinegar" }, -- remove due to `nvim-tree.lua` already have it
  { "tpope/vim-sleuth" },
  { "tpope/vim-rsi" },
  { "tpope/vim-eunuch" },

  { "p00f/nvim-ts-rainbow" },
  { "bronson/vim-visual-star-search" },
  -- { "godlygeek/tabular"},  -- FIXME(meijieru): check

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        char = "|",
        buftype_exclude = { "terminal" },
        filetype_exclude = { "help", "terminal", "dashboard" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = false,
        context_patterns = {
          "def",
          "class",
          "return",
          "function",
          "method",
          "^if",
          "^while",
          "^for",
          "^try",
          "^with",
        },
      }
    end,
    disable = false,
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.cmd [[
                map <Leader><leader>w :HopWordAC<CR>
                map <Leader><leader>b :HopWordBC<CR>
                map <Leader><leader>j :HopLineAC<CR>
                map <Leader><leader>k :HopLineBC<CR>
                map <Leader><leader>s :HopPattern<CR>
            ]]
    end,
    disable = false,
  },
  { "mg979/vim-visual-multi" },

  { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" },

  {
    "skywind3000/asynctasks.vim",
    requires = {
      "skywind3000/asyncrun.vim",
      { "GustavoKatel/telescope-asynctasks.nvim", disable = not lvim.builtin.telescope.active },
    },
    setup = function()
      _my_load_vimscript "./site/bundle/asynctasks.vim"
    end,
  },
  {
    "Chiel92/vim-autoformat",
    cmd = { "Autoformat" },
    setup = function()
      _my_load_vimscript "./site/bundle/autoformat.vim"
    end,
  },

  -- FIXME(meijieru): indent
  { "dccmx/google-style.vim", disable = true },
  { "Vimjas/vim-python-pep8-indent", disable = true },

  { "plasticboy/vim-markdown", ft = { "markdown" }, disable = true },

  { "wakatime/vim-wakatime" },

  { "kana/vim-textobj-user" },
  { "kana/vim-textobj-indent" },
  { "jceb/vim-textobj-uri" },
  { "sgur/vim-textobj-parameter", ft = { "lua" }, enable = false },

  { "mbbill/undotree" },

  -- FIXME(meijieru): check
  -- Plug 'ludovicchabant/vim-gutentags'
  -- Plug 'skywind3000/gutentags_plus'
  -- Plug 'lervag/vimtex', { 'for': ['tex'] }

  {
    "dstein64/vim-startuptime",
    cmd = { "StartupTime" },
    setup = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      }
    end,
  },
  { "vimpostor/vim-tpipeline" },

  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      }
    end,
    disable = false,
  },

  {
    "michaelb/sniprun",
    run = { "bash install.sh" },
    config = function()
      require("sniprun").setup {
        display = {
          -- "Classic", --# display results in the command-line  area
          "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)
          "VirtualTextErr", --# display error results as virtual text
          "TempFloatingWindow", --# display results in a floating window
          -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
          -- "Terminal",                --# display results in a vertical split
          -- "NvimNotify",              --# display with the nvim-notify plugin
          -- "Api"                      --# return output to a programming interface
        },
        selected_interpreters = { "Lua_nvim" }, --# use those instead of the default for the current filetype
        repl_enable = { "Python3_original" }, --# enable REPL-like behavior for the given interpreters
        repl_disable = {}, --# disable REPL-like behavior for the given interpreters
      }
      vim.api.nvim_set_keymap("v", "r", "<Plug>SnipRun", { silent = true })
      vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRunOperator", { silent = true })
      vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
    end,
    disable = false,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    disable = false,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        auto_resize_height = false,
      }
    end,
    disable = false,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {}
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable" },
    config = function()
      require("twilight").setup {}
    end,
  },

  { "nathom/filetype.nvim" },
  {
    "andymass/vim-matchup",
    after = "nvim-treesitter",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
  },
}

require "keymap"
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
vim.cmd [[
  autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
]]

require "machine_specific"
