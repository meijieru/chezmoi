local config = {}

function config.hop()
  require("hop").setup()
  vim.cmd [[
    map <Leader><leader>w :HopWordAC<CR>
    map <Leader><leader>b :HopWordBC<CR>
    map <Leader><leader>j :HopLineAC<CR>
    map <Leader><leader>k :HopLineBC<CR>
    map <Leader><leader>s :HopPattern<CR>
  ]]
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
