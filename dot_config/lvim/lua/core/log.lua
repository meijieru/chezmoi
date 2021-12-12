local status_log_ok, lvim_log = pcall(require, "lvim.core.log")
if status_log_ok then
  return lvim_log
end

local M = {}

local function notify_wrapper(method)
  return function(self, msg, ...)
    vim.notify(msg, method, ...)
  end
end

for _, method in ipairs { "info", "warn", "error", "debug", "trace" } do
  M[method] = notify_wrapper(method)
end
return M
