return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"
    local snip_status_ok, luasnip = pcall(require, "luasnip")
    if not snip_status_ok then return end

    local mapping = opts.mapping
    for _, key in ipairs { "<C-J>", "<C-K>", "<C-Y>", "<Down>", "<Up>" } do
      mapping[key] = nil
    end

    mapping["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" })
    mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })

    opts.experimental = {
      ghost_text = true,
    }

    return opts
  end,
}
