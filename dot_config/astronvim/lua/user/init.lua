require "user.defaults"
require "user.machine_specific"

return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
  },

  colorscheme = "catppuccin",

  lsp = {
    formatting = {
      format_on_save = {
        enabled = false,
      },
      timeout_ms = 2000, -- default format timeout
    },
  },

  lazy = {
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          -- "rplugin",
          -- "shada",
          -- "spellfile",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  },

  heirline = {
    attributes = {
      mode = { bold = true },
    },
    separators = {
      -- left = { "", " " },
      -- right = { " ", "" },
      left = { "", " " },
      right = { " ", "" },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
    local ok, wf = pcall(require, "vim.lsp._watchfiles")
    if ok then
      -- disable lsp watcher. Too slow on linux
      wf._watchfunc = function()
        return function() end
      end
    end

    require "user.polish.autocmds"
    require "user.polish.commands"
  end,
}
