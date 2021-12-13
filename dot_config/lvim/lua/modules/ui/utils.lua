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

-- https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
  local valid_fmt = "%s │%5d:%-3d│%s %s"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

return M
