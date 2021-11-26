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

  -- TODO(meijieru): convert to lua
  vim.cmd [[
    function! s:toggle_term_runner(opts)
      lua require("site.bundle.asynctasks").runner(vim.fn.eval("a:opts.cmd"), vim.fn.eval("a:opts.cwd"))
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
  require("colorizer").setup()
end

function config.filtype()
  require("filetype").setup {
    function_literal = {
      -- TODO(meijieru): set template ft
      -- template = function () end
    },
  }
end

function config.telescope_frecency()
  require("telescope").load_extension "frecency"
end

return config
