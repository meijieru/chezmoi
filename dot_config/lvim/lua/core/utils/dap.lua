local M = {}

function M.store()
  local breakpoints = require "dap.breakpoints"
  local bps = {}
  local breakpoints_by_buf = breakpoints.get()
  for buf, buf_bps in pairs(breakpoints_by_buf) do
    bps[tostring(buf)] = buf_bps
  end
  local fp = io.open("/tmp/breakpoints.json", "w")
  fp:write(vim.json.encode(bps))
  fp:close()
end

function M.load()
  local breakpoints = require "dap.breakpoints"
  local fp = io.open("/tmp/breakpoints.json", "r")
  local content = fp:read "*a"
  local bps = vim.json.decode(content)
  for buf, buf_bps in pairs(bps) do
    for _, bp in pairs(buf_bps) do
      local line = bp.line
      local opts = {
        condition = bp.condition,
        log_message = bp.logMessage,
        hit_condition = bp.hitCondition,
      }
      breakpoints.set(opts, tonumber(buf), line)
    end
  end
end

return M
