local config = {}

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

return config
