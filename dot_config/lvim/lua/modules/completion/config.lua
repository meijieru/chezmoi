local config = {}

function config.telescope_luasnip()
  require("telescope").load_extension "luasnip"
end

function config.trouble()
  require("trouble").setup {
    use_lsp_diagnostic_signs = true,
  }
end

if lvim.builtin.telescope.active then
  local function _open_with_trouble(prompt_bufnr, _mode)
    -- defer trouble loading
    local trouble = require "trouble.providers.telescope"
    return trouble.open_with_trouble(prompt_bufnr, _mode)
  end

  lvim.builtin.telescope.defaults.mappings.i["<C-t>"] = _open_with_trouble
  lvim.builtin.telescope.defaults.mappings.n["<C-t>"] = _open_with_trouble
end

return config
