local M = {}

function M.is_used_colorschemes(colors)
  return function()
    return vim.tbl_contains(colors, lvim.colorscheme)
  end
end

function M.use_colorschemes(plugins, url, colors, extras)
  vim.validate {
    plugins = { plugins, "table" },
    url = { url, "string" },
    extras = { extras, "table", true },
  }

  local opts = { cond = M.is_used_colorschemes(colors) }
  if extras then
    opts = vim.tbl_extend("error", opts, extras)
  end
  plugins[url] = opts
end

return M
