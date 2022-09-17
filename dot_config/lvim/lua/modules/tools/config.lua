local config = {}
local Log = require "core.log"

function config.diffview()
  require("diffview").setup {}
end

function config.gitlinker()
  require("gitlinker").setup {
    callbacks = {
      ["direct.meijieru.com"] = function(url_data)
        url_data.host = "gitea.meijieru.com"
        return require("gitlinker.hosts").get_gitea_type_url(url_data)
      end,
    },
    -- https://github.com/ruifm/gitlinker.nvim/issues/48
    -- mappings = nil,
  }
end

function config.imtoggle()
  require("imtoggle").setup {
    enable = true,
  }
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

function config.telescope_frecency()
  require("telescope").load_extension "frecency"
end

local function setup_drop()
  vim.fn.setenv("VIM_EXE", "nvim")
  vim.g.terminal_edit = "edit"

  local bin_dir = join_paths(get_config_dir(), "bin")
  local PATH = os.getenv "PATH"
  if not string.find(PATH, bin_dir) then
    Log:debug(string.format("Append %s to $PATH", bin_dir))
    vim.fn.setenv("PATH", PATH .. ":" .. bin_dir)
  end
end

setup_drop()
require("modules.tools.lvim").setup()

return config
