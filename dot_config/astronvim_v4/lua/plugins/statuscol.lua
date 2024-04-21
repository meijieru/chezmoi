if true then return end

return {
  { import = "astrocommunity.bars-and-lines.statuscol-nvim" },
  {
    "statuscol.nvim",
    event = "BufReadPost",
    lazy = vim.fn.argv()[1] == nil,
    opts = function(_, _)
      local builtin = require "statuscol.builtin"
      local opts = {
        setopt = true,
        -- https://github.com/luukvbaal/statuscol.nvim/issues/72#issuecomment-1593828496
        ft_ignore = { "Overseer*" },
        bt_ignore = { "nofile", "prompt" },
        segments = {
          -- {
          --   sign = { namespace = { "gitsign" }, maxwidth = 1, colwidth = 1, auto = false },
          --   click = "v:lua.ScSa",
          -- },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { namespace = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa",
          },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      }
      return opts
    end,
  },
}
