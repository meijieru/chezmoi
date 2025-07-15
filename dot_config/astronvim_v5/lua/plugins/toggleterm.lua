return {
  "akinsho/toggleterm.nvim",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings

        local termial_related_modes = { maps.n, maps.t, maps.i }
        for _, map_mode in ipairs(termial_related_modes) do
          map_mode["<C-t>"] = map_mode["<F7>"]
          map_mode["<F7>"] = nil
          map_mode["<C-'>"] = nil
        end

        -- Terminal
        if maps.n["<Leader>tp"] then
          local ipython = vim.fn.executable("ipython") == 1 and "ipython"
            or vim.fn.executable("ipython3") == 1 and "ipython3"
          if ipython then
            maps.n["<Leader>tp"] = {
              function()
                require("astrocore").toggle_term_cmd(ipython)
              end,
              desc = "ToggleTerm python",
            }
          end
        end
      end,
    },
  },

  opts = function(_, opts)
    opts.size = 12
    opts.winbar = {
      enabled = true,
    }
    opts.direction = "float"

    -- modify the keymap to toggle the terminal
    opts.on_create = function(t)
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.signcolumn = "no"
      if t.hidden then
        local toggle = function()
          t:toggle()
        end
        vim.keymap.set({ "n", "t", "i" }, "<C-t>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
      end
    end

    return opts
  end,
}
