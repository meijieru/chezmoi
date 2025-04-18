local constants = require("overseer.constants")
local helper = require("overseer.template.myplugin.helper")

local function gcc_build(file)
  return { "gcc", "-O2", "-Wall", file, "-o", helper.remove_extension(file), "-lstdc++", "-lm", "-msse3" }
end

local filetype_to_cmd = {
  c = gcc_build,
  cpp = gcc_build,
}

local function builder()
  local file = vim.fn.expand("%")
  local cmd, extra = filetype_to_cmd[vim.bo.filetype](file)
  return vim.tbl_deep_extend("force", {
    cmd = cmd,
    strategy = "terminal",
    components = {
      "default",
    },
  }, extra or {})
end

return {
  name = "file-build",
  builder = builder,
  condition = {
    filetype = vim.tbl_keys(filetype_to_cmd),
  },
  tags = { constants.TAG.BUILD },
  desc = "build single file",
}
