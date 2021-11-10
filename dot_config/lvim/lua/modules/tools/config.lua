local config = {}

function config.neogit()
  require("neogit").setup {}
end

function config.asynctasks()
  _my_load_vimscript "./site/bundle/asynctasks.vim"
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

return config
