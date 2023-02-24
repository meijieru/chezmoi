local M = {}

--- Remove the extension
---@param file string
---@return string
function M.remove_extension(file)
  local tmp = vim.split(file, "%.")
  return table.concat(tmp, ".", 1, #tmp - 1)
end

function M.get_output_component()
  return {}
end

return M
