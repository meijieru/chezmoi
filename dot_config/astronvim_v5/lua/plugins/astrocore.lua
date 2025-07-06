-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- default mappings:
-- ~/.local/share/nvim/lazy/AstroNvim/lua/astronvim/plugins/_astrocore_mappings.lua
-- ~/.local/share/nvim/lazy/AstroNvim/lua/astronvim/plugins/_astrolsp_mappings.lua
-- ~/.local/share/nvim/lazy/AstroNvim/lua/astronvim/plugins/snacks.lua

_G.qftf = require("core.utils.ui").qftf

local keymap_utils = require("core.utils.keymap")
local normal_command = keymap_utils.normal_command
local lua_normal_command = keymap_utils.lua_normal_command

local is_available = require("astrocore").is_available
local get_icon = require("astroui").get_icon

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    ---@type AstroCoreMappings
    local maps = opts.mappings
    ---@type AstroCoreMappings
    local original_maps_to_modify = {
      n = {
        ["<Leader>w"] = false,
        ["<Leader>q"] = false,
        ["<Leader>Q"] = false,
        ["<Leader>n"] = false,
        ["<C-S>"] = false,
        ["<C-Q>"] = false,
        ["|"] = false,
        ["\\"] = false,

        ["<Leader>b"] = false,
        ["<Leader>bb"] = false,
        ["<Leader>bc"] = false,
        ["<Leader>bC"] = false,
        ["<Leader>bd"] = false,
        ["<Leader>bD"] = false,
        ["<Leader>b\\"] = false,
        ["<Leader>b|"] = false,
        ["<Leader>bl"] = false,
        ["<Leader>bp"] = false,
        ["<Leader>br"] = false,
        ["<Leader>bs"] = false,
        ["<Leader>bse"] = false,
        ["<Leader>bsr"] = false,
        ["<Leader>bsp"] = false,
        ["<Leader>bsi"] = false,
        ["<Leader>bsm"] = false,

        ["<Leader>c"] = false,
        ["<Leader>C"] = false,
        [">b"] = false,
        ["<b"] = false,

        ["<Leader>/"] = false,

        ["]g"] = false,
        ["[g"] = false,
        ["<Leader>gt"] = false,

        ["<Leader>o"] = false,

        ["<C-H>"] = false,
        ["<C-J>"] = false,
        ["<C-K>"] = false,
        ["<C-L>"] = false,
        ["<C-Up>"] = false,
        ["<C-Down>"] = false,
        ["<C-Left>"] = false,
        ["<C-Right>"] = false,

        ["<Leader>ls"] = false,
        ["<Leader>lS"] = false,
        ["<Leader>lD"] = { desc = "Workspace Diagnostics" },

        -- Picker
        ["<Leader>fa"] = false,
        ["<Leader>fb"] = false,
        ["<Leader>fc"] = false,
        ["<Leader>fC"] = false,
        ["<Leader>ff"] = false,
        ["<Leader>fF"] = false,
        ["<Leader>fO"] = false,
        ["<Leader>fs"] = false,
        ["<Leader>ft"] = false,

        -- Terminal
        ["<Leader>tn"] = false,

        -- Custom menu for modification of the user experience
        ["<Leader>uc"] = false,
        ["<Leader>uC"] = false,
        ["<Leader>ug"] = false,
        ["<Leader>u>"] = false,
        ["<Leader>ul"] = false,
        ["<Leader>uL"] = false,
        ["<Leader>un"] = false,
        ["<Leader>uN"] = false,
        ["<Leader>up"] = false,
        ["<Leader>ut"] = false,
        ["<Leader>uu"] = false,
        ["<Leader>uy"] = false,
        ["<Leader>uz"] = false,
        ["<Leader>uZ"] = false,
        ["<Leader>ua"] = false,
        ["<Leader>ur"] = false,
        ["<Leader>uR"] = false,
        ["<Leader>uf"] = false,
        ["<Leader>uF"] = false,

        -- Debug
        ["<Leader>dE"] = false,
        ["<Leader>dd"] = maps.n["<Leader>ds"],
        ["<Leader>ds"] = false,

        ["<Leader>lI"] = false,
      },
      i = {
        ["<C-S>"] = false,
      },
      x = {
        ["<C-S>"] = false,
      },
      v = {
        ["<Leader>/"] = false,
      },
      t = {
        ["<C-H>"] = false,
        ["<C-J>"] = false,
        ["<C-K>"] = false,
        ["<C-L>"] = false,
      },
    }
    ---@type AstroCoreMappings
    local new_maps = {
      -- first key is the mode
      n = {
        -- Git
        dp = {
          function()
            if vim.o.diff then
              vim.cmd.diffput()
            else
              require("gitsigns").stage_hunk()
            end
          end,
          desc = "Diff Put | Stage Hunk | Undo Stage Hunk",
        },
        ["do"] = {
          function()
            if vim.o.diff then
              vim.cmd.diffget()
            else
              require("gitsigns").reset_hunk()
            end
          end,
          desc = "Diff Get | Reset Hunk",
        },

        ["<Leader>gb"] = {
          function()
            require("snacks").picker.git_branches({
              win = {
                input = {
                  keys = {
                    ["<C-T>"] = { "diffview_branch", mode = { "i", "n" } },
                  },
                },
              },
            })
          end,
          desc = "Git branches",
        },
        ["<Leader>gc"] = {
          function()
            require("snacks").picker.git_log({
              win = {
                input = {
                  keys = {
                    ["<C-T>"] = { "diffview_commit", mode = { "i", "n" } },
                  },
                },
              },
            })
          end,
          desc = "Git commits (repository)",
        },
        ["<Leader>gC"] = {
          function()
            require("snacks").picker.git_log({
              current_file = true,
              follow = true,
              win = {
                input = {
                  keys = {
                    ["<C-T>"] = { "diffview_commit", mode = { "i", "n" } },
                  },
                },
              },
            })
          end,
          desc = "Git commits (current file)",
        },
        ["<Leader>gd"] = { normal_command("DiffviewOpen"), desc = "Diff View" },
        ["<Leader>gh"] = { normal_command("DiffviewFileHistory"), desc = "Diff History" },
        ["<Leader>gH"] = { normal_command("DiffviewFileHistory %"), desc = "Diff History (current file)" },
        ["<Leader>gg"] = {
          function()
            require("core.utils.git").toggle_fugitive()
          end,
          desc = "Toggle Status",
        },
        ["<Leader>gl"] = {
          function()
            if is_available("gitsigns.nvim") then
              require("gitsigns").blame()
            elseif is_available("fugitive") then
              vim.cmd("Git blame")
            else
              vim.notify("No available method for git blame", vim.log.levels.ERROR)
            end
          end,
          desc = "Git Blame",
        },
        ["<Leader>gL"] = { normal_command("Gitsigns toggle_current_line_blame"), desc = "Current Line Blame" },
        ["<Leader>gt"] = {
          keymap_utils.chain("Gitsigns toggle_deleted", "Gitsigns toggle_word_diff"),
          desc = "Toggle Inline Diff",
        },
        ["<Leader>gm"] = {
          function()
            require("snacks").picker.git_status()
          end,
          desc = "Modified Files",
        },

        -- Next / Prev
        ["]c"] = {
          function()
            for _ = 1, vim.v.count1 do
              if vim.o.diff then
                vim.cmd.normal({ "]c", bang = true })
              elseif is_available("mini.diff") then
                require("mini.diff").goto_hunk("next")
              elseif is_available("gitsigns.nvim") then
                require("gitsigns").nav_hunk("next")
              elseif is_available("vim-signify") then
                vim.cmd([[execute "normal! \<Plug>(signify-next-hunk)"]])
              else
                vim.notify("No available method for next hunk", vim.log.levels.ERROR)
              end
            end
          end,
          desc = "Next Change | Hunk",
        },
        ["[c"] = {
          function()
            for _ = 1, vim.v.count1 do
              if vim.o.diff then
                vim.cmd.normal({ "[c", bang = true })
              elseif is_available("mini.diff") then
                require("mini.diff").goto_hunk("prev")
              elseif is_available("gitsigns.nvim") then
                require("gitsigns").nav_hunk("prev")
              elseif is_available("vim-signify") then
                vim.cmd([[execute "normal! \<Plug>(signify-prev-hunk)"]])
              else
                vim.notify("No available method for prev hunk", vim.log.levels.ERROR)
              end
            end
          end,
          desc = "Previous Change | Hunk",
        },

        -- Better window movement
        ["<A-h>"] = { "<C-W>h", desc = "Left Window" },
        ["<A-j>"] = { "<C-W>j", desc = "Down Window" },
        ["<A-k>"] = { "<C-W>k", desc = "Up Window" },
        ["<A-l>"] = { "<C-W>l", desc = "Right Window" },

        -- Other
        ["m<space>"] = { normal_command("delmarks!"), desc = "Delete All Marks" },
        ["g?"] = { normal_command("WhichKey"), desc = "WhichKey" },

        -- Picker
        -- trick: <c-space> convert it as fuzzy
        ["<C-S-P>"] = {
          function()
            require("snacks").picker.commands()
          end,
          desc = "Commands Palette",
        },
        ["<Leader>*"] = {
          function()
            require("snacks").picker.grep_word()
          end,
          desc = "Grep Word",
        },
        ["<Leader>b"] = {
          function()
            require("snacks").picker.buffers()
          end,
          desc = "Find Buffers",
        },
        ["<Leader>/"] = {
          function()
            require("snacks").picker.search_history()
          end,
          desc = "Find Search History",
        },
        ["<Leader>:"] = {
          function()
            require("snacks").picker.command_history()
          end,
          desc = "Find Commands History",
        },
        ["<Leader>ff"] = {
          function()
            require("snacks").picker.smart({ multi = { "buffers", { source = "files", hidden = true } } })
          end,
          desc = "Find Files",
        },
        ["<Leader>fc"] = {
          function()
            require("snacks").picker.lines()
          end,
          desc = "Grep Lines",
        },
        ["<Leader>fb"] = {
          function()
            require("snacks").picker.grep_buffers()
          end,
          desc = "Grep Buffers Lines",
        },
        ["<Leader>fl"] = {
          function()
            require("snacks").picker.loclist()
          end,
          desc = "Find Loclist",
        },
        ["<Leader>fq"] = {
          function()
            require("snacks").picker.qflist()
          end,
          desc = "Find QuickFix",
        },
        ["<Leader>fu"] = {
          function()
            require("snacks").picker.undo()
          end,
          desc = "Find Undos",
        },
        ["<Leader>ft"] = { normal_command("OverseerRun"), desc = "Find Tasks" },
        ["<Leader>fw"] = { desc = "Grep" },
        ["<Leader>fW"] = { desc = "Grep in All" },

        -- Debug
        ["<Leader>de"] = {
          function()
            require("dapui").eval()
          end,
          desc = "Evaluate",
        },

        -- Custom menu for modification of the user experience
        ["<Leader>uc"] = {
          function()
            vim.cmd.HighlightColors("Toggle")
          end,
          desc = "Toggle color highlight",
        },
        ["<Leader>uu"] = { normal_command("OverseerToggle left"), desc = "Overseer" },
        ["<Leader>uq"] = {
          function()
            require("core.utils.ui").toggle_quickfix()
          end,
          desc = "Quickfix",
        },
        ["<Leader>ul"] = {
          function()
            require("core.utils.ui").toggle_loclist()
          end,
          desc = "Loclist",
        },

        -- Treesitter
        ["<Leader>T"] = get_icon("ActiveTS") .. " Treesitter",
        ["<Leader>Tc"] = { normal_command("TSConfigInfo"), desc = "Config Info" },
        ["<Leader>Tm"] = { normal_command("TSModuleInfo"), desc = "Module Info" },
        ["<Leader>Tt"] = { normal_command("InspectTree"), desc = "Playground" },
        ["<Leader>Ts"] = { normal_command("TSUpdate"), desc = "Update Treesitter Parser" },
        ["<Leader>Th"] = { normal_command("Inspect"), desc = "Highlight Info" },

        -- Lang
        ["<Leader>ll"] = {
          function()
            if is_available("dropbar.nvim") then
              require("dropbar.api").pick()
            elseif is_available("aerial.nvim") then
              require("aerial").nav_toggle()
            else
              vim.notify("No dropbar or aerial.nvim installed", vim.log.levels.ERROR)
            end
          end,
          desc = "Navigate",
        },

        -- TODO(meijieru): more lsp use snacks
        ["gO"] = {
          function()
            require("snacks").picker.lsp_symbols()
          end,
          desc = "Document Symbols",
        },
        ["grr"] = {
          function()
            require("snacks").picker.lsp_references()
          end,
          desc = "References",
        },
        ["gri"] = {
          function()
            require("snacks").picker.lsp_implementations()
          end,
          desc = "Implementations",
        },

        ["<F1>"] = {
          lua_normal_command("require('core.utils.ui').toggle_colorcolumn()"),
          desc = "Toggle Colorcolumn",
        },

        ["<Leader>z"] = {
          function()
            require("snacks").toggle.zen():toggle()
          end,
          desc = "Zen Mode",
        },
      },

      v = {
        ["<"] = { "<gv" },
        [">"] = { ">gv" },

        ["<Leader>*"] = {
          function()
            require("snacks").picker.grep_word()
          end,
          desc = "Grep Selection",
        },
        ["<Leader>g"] = maps.n["<Leader>g"],
        ["<Leader>f"] = maps.n["<Leader>f"],

        -- Debug
        ["<Leader>de"] = {
          function()
            require("dapui").eval()
          end,
          desc = "Evaluate",
        },
      },

      t = {
        -- Improved Terminal Navigation
        ["<A-q>"] = { [[<C-\><C-N>]], desc = "Terminal normal mode" },
        ["<A-h>"] = { normal_command("wincmd h"), desc = "Terminal left window navigation" },
        ["<A-j>"] = { normal_command("wincmd j"), desc = "Terminal down window navigation" },
        ["<A-k>"] = { normal_command("wincmd k"), desc = "Terminal up window navigation" },
        ["<A-l>"] = { normal_command("wincmd l"), desc = "Terminal right window navigation" },
      },

      o = {
        u = { "gc", desc = "Commented Lines", remap = true },
      },

      i = {
        ["<C-K>"] = { "<Up>" },
        ["<C-J>"] = { "<Down>" },
        ["<C-H>"] = { "<Left>" },
        ["<C-L>"] = { "<Right>" },
        ["<F1>"] = {
          lua_normal_command("require('core.utils.ui').toggle_colorcolumn()"),
          desc = "Toggle Colorcolumn",
        },
      },

      c = {
        ["<C-K>"] = { "<Up>" },
        ["<C-J>"] = { "<Down>" },
        ["<C-H>"] = { "<Left>" },
        ["<C-L>"] = { "<Right>" },
      },
    }

    ---@type AstroCoreOpts
    local override = {
      features = {
        ---@type AstroCoreDiagnosticsFeature
        diagnostics = { virtual_text = true, virtual_lines = false },
        -- TODO(meijieru): current_line is not working
        -- diagnostics = { virtual_text = { current_line = true }, virtual_lines = { current_line = true } },
      },
      rooter = {
        autochdir = true,
        detector = {
          "lsp",
          { "WORKSPACE" }, -- known project root files, higher priorities
          { ".git", "_darcs", ".hg", ".bzr", ".svn" },
          { "MakeFile", "package.json" }, -- other known project root files
        },
        ignore = {
          servers = { "ciderlsp" },
        },
      },
      options = {
        opt = {
          relativenumber = false,
          spell = false,
          showtabline = 1,
          shiftwidth = 4,
          tabstop = 4,
          showbreak = "↳ ",
          grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]],
          grepformat = "%f:%l:%c:%m",
          background = "light",
          splitkeep = "screen",
          -- for click handler of `luukvbaal/statuscol.nvim`
          mousemodel = "extend",
          qftf = "{info -> v:lua._G.qftf(info, 'shorten')}",
          swapfile = false,
          clipboard = "",
          fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
          diffopt = vim.fn.has("nvim-0.12") == 1 and vim.list_extend(vim.opt.diffopt:get(), { "inline:char" }) or nil,
          exrc = true,
        },
        g = {
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },

      autocmds = {
        q_close_windows = false,
        -- TODO(meijieru): enable for oil.nvim
        neotree_start = false,
        neovide_init = {
          {
            event = "UIEnter",
            desc = "Set neovide related",
            callback = function()
              if require("core.utils").is_neovide() then
                require("core.utils.env").neovide_setup()
              end
            end,
          },
        },
      },

      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = vim.tbl_deep_extend("force", maps, original_maps_to_modify, new_maps),
    }
    return vim.tbl_deep_extend("force", opts, override)
  end,
}
