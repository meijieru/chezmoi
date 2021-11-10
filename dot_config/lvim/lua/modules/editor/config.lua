local config = {}

function config.hop()
  require("hop").setup()
end

function config.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

function config.lastplace()
    require("nvim-lastplace").setup {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    }
  end

return config
