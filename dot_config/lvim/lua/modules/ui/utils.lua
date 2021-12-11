local M = {}

local utils = require "core.utils"
local Log = require "core.log"

local function is_used_colorschemes(colors)
  return vim.tbl_contains(colors, lvim.colorscheme)
end

local function load_colorscheme(url)
  utils.load_pack(utils.get_plugin_dir(url), { skip_packer = true })
end

function M.use_colorschemes(plugins, url, colors, extras)
  vim.validate {
    plugins = { plugins, "table" },
    url = { url, "string" },
    extras = { extras, "table", true },
  }

  local opts = { opt = true }
  if extras then
    opts = vim.tbl_extend("error", opts, extras)
  end

  plugins[url] = opts
  if is_used_colorschemes(colors) then
    for _, dep in ipairs(opts.requires or {}) do
      load_colorscheme(dep)
    end
    load_colorscheme(url)

    -- packer always call the setup
    -- if opts.setup then
    --   opts.setup()
    -- end
    if opts.config then
      Log:warn "Config not called"
    end
  end
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
