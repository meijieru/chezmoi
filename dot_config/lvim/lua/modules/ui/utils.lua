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

local function range(lhs, rhs)
  local res = {}
  for i = lhs, rhs - 1 do
    res[#res + 1] = i
  end
  return res
end

function M.toggle_colorcolumn(first_column, second_column)
  vim.validate {
    first_column = { first_column, "number", true },
    second_column = { second_column, "number", true },
  }
  first_column = first_column or 81
  second_column = second_column or 121

  if vim.o.colorcolumn == "" then
    local columns = range(second_column, 1000)
    table.insert(columns, 1, first_column)
    vim.o.colorcolumn = table.concat(columns, ",")
  else
    vim.o.colorcolumn = ""
  end
end

return M
