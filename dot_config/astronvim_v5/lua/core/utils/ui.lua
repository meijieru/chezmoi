local M = {}

local utils = require("core.utils")

local function range(lhs, rhs)
  local res = {}
  for i = lhs, rhs - 1 do
    res[#res + 1] = i
  end
  return res
end

function M.toggle_quickfix()
  local quickfix_exist = vim.iter(vim.fn.getwininfo()):any(function(win)
    return win["quickfix"] == 1
  end)
  if quickfix_exist then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

function M.toggle_loclist()
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid == 0 then
    vim.cmd.lopen()
  else
    vim.cmd.lclose()
  end
end

function M.toggle_colorcolumn(first_column, second_column)
  vim.validate({
    first_column = { first_column, "number", true },
    second_column = { second_column, "number", true },
  })
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
          else
            vim.notify(
              string.format("Unknow path shorten method: %s", method),
              vim.log.levels.ERROR,
              { title = "qftf" }
            )
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

return M
