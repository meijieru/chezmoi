return {

  { import = "astrocommunity.code-runner.overseer-nvim" },
  {
    "overseer.nvim",
    opts = {
      strategy = { "toggleterm", open_on_start = false },
      templates = { "builtin", "myplugin.global_tasks" },
      task_list = {
        bindings = {
          ["q"] = "<cmd>close<cr>",
          ["<c-x>"] = "OpenSplit",
        },
      },
      component_aliases = {
        status_only = {
          "on_exit_set_status",
          "on_complete_notify",
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      form = {
        win_opts = {
          winblend = 0,
        },
      },
    },
  },
}
