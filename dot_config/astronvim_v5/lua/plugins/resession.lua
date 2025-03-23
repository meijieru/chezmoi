return {
  "stevearc/resession.nvim",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>Si"] = {
          function()
            vim.notify(
              vim.inspect(require("resession").get_current_session_info()),
              vim.log.levels.INFO,
              { title = "Session Info" }
            )
          end,
          desc = "Session Info",
        }
        maps.n["<Leader>Su"] = { function() require("resession").detach() end, desc = "Detach this session" }
      end,
    },
  },
}
