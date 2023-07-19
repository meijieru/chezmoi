M = {}

function M.normal_command(command) return string.format("<cmd>%s<cr>", command) end

function M.lua_normal_command(command) return M.normal_command(string.format("lua %s", command)) end

function M.chain(...)
  local cmds = { ... }
  local function exe(cmd)
    if type(cmd) == "function" then
      cmd()
    elseif type(cmd) == "string" then
      vim.cmd(cmd)
    else
      vim.notify("Unknown cmd type: " .. type(cmd), vim.log.levels.ERROR)
    end
  end

  return function() vim.tbl_map(exe, cmds) end
end

return M
