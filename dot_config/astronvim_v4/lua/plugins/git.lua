return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    event = "User AstroGitFile",
  },

  { import = "astrocommunity.git.gitlinker-nvim" },
  {
    "gitlinker.nvim",
    opts = {
      callbacks = {
        ["direct.meijieru.com"] = function(url_data)
          url_data.host = "gitea.meijieru.com"
          return require("gitlinker.hosts").get_gitea_type_url(url_data)
        end,
      },
    },
    -- TODO(meijieru): use own config
    -- event = "User AstroGitFile",
  },

  { import = "astrocommunity.git.diffview-nvim" },
  {
    "diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        view = {
          default = {
            winbar_info = true,
          },
          merge_tool = {
            layout = "diff3_mixed",
            winbar_info = true,
          },
          file_history = {
            winbar_info = true,
          },
        },
        keymaps = {
          file_panel = {
            ["cc"] = "<cmd>Git commit<cr>",
            ["q"] = "<cmd>tabclose<cr>",
          },
          file_history_panel = {
            ["q"] = "<cmd>tabclose<cr>",
          },
        },
      })
    end,
  },
}
