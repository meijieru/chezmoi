local M = {}

local utils = require "core.utils"
local Log = require "core.log"

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

-- modified from https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
function M.qftf(info, method)
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
        if #fname > limit then
          if method == "shorten" then
            fname = utils.shorten_path(fname, limit)
          elseif method == "trunc" then
            -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
            fname = fname_fmt2:format(fname:sub(1 - limit))
          elseif method == "none" then
            Log:error "NotImplementedError"
          else
            Log:error(string.format("Unknow path shorten method: %s", method))
          end
        end
        fname = fname_fmt1:format(fname)
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

local function _sainnhe_palettes(name)
  name = name:gsub("-", "_")
  local palette
  local configuration = vim.fn[name .. "#get_configuration"]()

  if name == "gruvbox_material" then
    local background = vim.opt.background:get()
    palette = vim.fn[name .. "#get_palette"](background, configuration.palette)
    return {
      bg = palette.bg1[1],
      fg = palette.fg1[1],
    }
  elseif name == "edge" then
    palette = vim.fn[name .. "#get_palette"](configuration.style)
    return { bg = palette.bg1[1], fg = palette.fg[1] }
  elseif name == "everforest" then
    palette = vim.fn[name .. "#get_palette"](configuration.background)
    return { bg = palette.bg1[1], fg = palette.fg[1] }
  end
end

local function _my_palettes(name)
  if name == "edge_lush" then
    local palette = require "edge_lush.palette"
    return vim.tbl_map(function(hsl)
      return tostring(hsl):lower()
    end, {
      bg = palette.bg1,
      fg = palette.grey_dim,
    })
  end
end

--- Get palette for scroll bar
--- @param name string colorscheme
--- @return table | nil
function M.get_scroll_bar_color(name)
  local status, value
  if name == "edge_lush" then
    status, value = pcall(_my_palettes, name)
  else
    status, value = pcall(_sainnhe_palettes, name)
  end
  if status then
    return value
  else
    return nil
  end
end

return M
