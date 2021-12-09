local config = {}

function config.imtoggle()
  require("imtoggle").setup { enable = false }
end

function config.neogit()
  require("neogit").setup {}
end

function config.asynctasks()
  vim.g.asynctasks_term_reuse = 1
  vim.g.asynctasks_term_pos = "toggleterm"

  vim.g.asyncrun_rootmarks = myvim.root_markers
  vim.g.asyncrun_open = 10
  vim.g.asyncrun_status = ""

  vim.cmd [[
    function! s:toggle_term_runner(opts)
      lua require("site.bundle.asynctasks").runner(vim.fn.eval("a:opts"))
    endfunction

    let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
    let g:asyncrun_runner.toggleterm = function('s:toggle_term_runner')
  ]]
end

function config.startuptime()
  vim.g.startuptime_tries = 10
end

function config.sniprun()
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
end

function config.colorizer()
  require("colorizer").setup({
    "*", -- Highlight all files, but customize some others.
    css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
    lua = { names = false }, -- Disable parsing "names" like Blue or Gray
  }, {
    -- default_options
    mode = "background",
  })
end

function config.filtype()
  require("filetype").setup {
    overrides = {
      extensions = {
        tl = "teal",
      },
      literal = {
        [".tasks"] = "dosini",
      },
      complex = {
        -- [".git/index"] = "fugitive",
      },
    },
  }
end

function config.telescope_frecency()
  require("telescope").load_extension "frecency"
end

function config.vim_test()
  local strategy = "neovim"
  -- FIXME: doesn't take effect
  vim.g["test#strategy"] = { nearest = strategy, file = strategy, suite = strategy }
  vim.g["test#neovim#term_position"] = "vert botright 60"
end

function config.vim_ultest()
  vim.g.ultest_use_pty = 1
  vim.g.ultest_pass_sign = ""
  vim.g.ultest_fail_sign = ""
  vim.g.ultest_running_sign = ""
  vim.g.ultest_not_run_sign = ""
end

local function setup_drop()
  vim.fn.setenv("VIM_EXE", "lvim")
  vim.g.terminal_edit = "edit"
end

setup_drop()
require("modules.tools.lvim").setup()

return config
