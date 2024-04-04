local M = {}

local uv = vim.uv

--- Get plugin base dir.
--- @param url string
--- @return string
function M.get_plugin_dir(url)
  local parts = vim.split(url, "/")
  return parts[#parts]
end

--- Shortens path by turning apple/banana/orange -> a/b/orange
--- @param path string
--- @param len_target number
--- @return string
function M.shorten_path(path, len_target)
  local function count(base, pattern) return select(2, string.gsub(base, pattern, "")) end
  local function shorten_path_step(_path, sep)
    -- ('([^/])[^/]+%/', '%1/', 1)
    return _path:gsub(string.format("([^%s])[^%s]+%%%s", sep, sep, sep), "%1" .. sep, 1)
  end

  local data = path
  local path_separator = package.config:sub(1, 1)
  for _ = 0, count(data, path_separator) do
    if #data > len_target then data = shorten_path_step(data, path_separator) end
  end
  return data
end

--- Check is in vscode gui
--- @return boolean
function M.is_vscode() return vim.g.vscode ~= nil end

--- Check is in neovide gui
--- @return boolean
function M.is_neovide() return vim.g.neovide ~= nil end

--- Check whether in google env
--- @return boolean
function M.is_google()
  vim.notify_once("Not implemented", vim.log.levels.WARN, { title = "is_google" })
  return false
end

--- Check whether in wsl env
--- @return boolean
function M.is_wsl() return vim.fn.has "wsl" == 1 end

--- Check whether in windows env
--- @return boolean
function M.is_windows() return uv.os_uname().version:match "Windows" ~= nil end

--- Get content of current visual selection
--- @return string?
function M.get_visual_selection()
  -- https://github.com/neovim/neovim/pull/13896
  local visual_modes = {
    v = true,
    V = true,
    -- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
  }
  -- Return if not in visual mode
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    vim.notify("not in visual mode", vim.log.levels.ERROR, { title = "get_visual_selection" })
    return
  end

  vim.cmd.normal { '"zy', bang = true }
  local content = vim.fn.getreg "z"
  return content
end

--- Read the content
---@param fpath string file path
---@return string?
function M.read_file(fpath)
  local file = io.open(fpath, "r")
  local contents
  if file then
    contents = file:read "*all"
    file:close()
    return contents
  else
    return
  end
end

--- Read json
---@param fpath string
---@return table?
function M.read_json(fpath)
  local contents = M.read_file(fpath)
  if contents == nil then
    return nil
  else
    return vim.json.decode(contents)
  end
end

return M
