local M = {}

-- Modified from: https://github.com/sindrets/dotfiles/blob/d9cd3a1f1ad48c4c4ac26320a238df103bfcaded/.config/nvim/lua/user/plugins/fugitive.lua

--- Get the script ID of a fugitive script file.
--- @return integer?
local function get_sid()
  local file = "autoload/fugitive.vim"
  local script_entry = vim.api.nvim_exec("filter #vim-fugitive/" .. file .. "# scriptnames", true)
  local sid = vim.split(script_entry, ":")[1]
  return tonumber(sid)
end

--- Get the fugitive context for the item under the cursor.
--- @return table?
function M.get_info_under_cursor()
  if vim.bo.ft ~= "fugitive" then
    return
  end
  local sid = get_sid()

  if sid ~= nil then
    return vim.fn[("<SNR>%d_StageInfo"):format(sid)](vim.api.nvim_win_get_cursor(0)[1])
  end
end

--- find all window in current tab, ignoring floating_window
function M.fugitive_diff()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local wininfo = vim.tbl_filter(function(info)
    return vim.api.nvim_win_get_config(info.winid).relative == "" and info.tabnr == tabnr
  end, vim.fn.getwininfo())
  if #wininfo == 1 then
    vim.cmd "Gvdiff"
  else
    vim.cmd "Gtabedit | Gdiffsplit"
  end
end

return M
