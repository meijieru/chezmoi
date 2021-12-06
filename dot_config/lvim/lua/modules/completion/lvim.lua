local M = {}

function M.setup_cmp()
  local cmp = require "cmp"

  lvim.builtin.cmp.formatting.duplicates.buffer = 0
  lvim.builtin.cmp.confirm_opts = {
    behavior = cmp.ConfirmBehavior.Insert,
    select = false,
  }
  lvim.builtin.cmp.formatting.kind_icons = myvim.kind_icons

  local template, source_names =
    "(%s)", {
      nvim_lsp = "LSP",
      emoji = "Emoji",
      path = "Path",
      calc = "Calc",
      cmp_tabnine = "TabN",
      vsnip = "Snip",
      luasnip = "Snip",
      buffer = "Buf",
      nvim_lua = "Nlua",
      copilot = "Copl",
    }
  lvim.builtin.cmp.formatting.source_names = vim.tbl_map(function(val)
    return string.format(template, val)
  end, source_names)
end

function M.setup_trouble()
  if not lvim.builtin.telescope.active then
    return
  end
  local function _open_with_trouble(prompt_bufnr, _mode)
    -- defer trouble loading
    local trouble = require "trouble.providers.telescope"
    return trouble.open_with_trouble(prompt_bufnr, _mode)
  end

  lvim.builtin.telescope.defaults.mappings.i["<C-t>"] = _open_with_trouble
  lvim.builtin.telescope.defaults.mappings.n["<C-t>"] = _open_with_trouble
end

function M.setup()
  M.setup_trouble()
  M.setup_cmp()
end

return M
