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

function M.toggle_fugitive()
  local win_ids = vim.api.nvim_list_wins()
  local wins_to_close = {}
  for _, win_id in ipairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    if vim.startswith(vim.api.nvim_buf_get_name(buf_id), "fugitive://") then
      vim.api.nvim_win_close(win_id, false)
      return
    end

    if vim.bo[buf_id].buftype == "nofile" then
      wins_to_close[#wins_to_close + 1] = win_id
    end
  end

  vim.cmd("Git")
  for _, win_id in ipairs(wins_to_close) do
    vim.api.nvim_win_close(win_id, false)
  end
end

return M
