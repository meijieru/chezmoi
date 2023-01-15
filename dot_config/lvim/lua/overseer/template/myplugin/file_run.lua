local helper = require "overseer.template.myplugin.helper"

--- Run with runner
---@param runner string | table
---@return function
local function run_with(runner)
  vim.validate { runner = { runner, { "table", "string" } } }
  return function(file)
    if type(runner) == "string" then
      return { runner, file }
    elseif type(runner) == "table" then
      vim.list_extend(runner, { file })
    end
  end
end

--- Remove the extension
---@param file string
---@return table
local function remove_extension(file)
  return { helper.remove_extension(file) }
end

local filetype_to_cmd = {
  python = function(file)
    return run_with "python"(file), { env = { PYTHONPATH = vim.loop.cwd() } }
  end,
  sh = run_with "sh",
  zsh = run_with "zsh",
  bash = run_with "bash",
  javascript = run_with "node",
  lua = run_with "luajit",
  perl = run_with "perl",
  c = remove_extension,
  cpp = remove_extension,
  go = remove_extension,
}

local function builder()
  local file = vim.fn.expand "%"
  local cmd, extra = filetype_to_cmd[vim.bo.filetype](file)
  return vim.tbl_deep_extend("force", {
    cmd = cmd,
    components = vim.list_extend({
      "default",
    }, helper.get_output_component()),
  }, extra or {})
end

return {
  name = "file-run",
  builder = builder,
  condition = {
    filetype = vim.tbl_keys(filetype_to_cmd),
  },
  desc = "run single file",
}