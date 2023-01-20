local home_dir = os.getenv("HOME")
local envs = {
  LUNARVIM_RUNTIME_DIR = home_dir .. "/.local/share/lunarvim",
  LUNARVIM_CONFIG_DIR = home_dir .. "/.config/lvim",
  LUNARVIM_CACHE_DIR = home_dir .. "/.cache/lvim",
  LVIM_DEV_MODE = 1,
}
for key, val in pairs(envs) do
  vim.loop.os_setenv(key, val)
end

local lvim_init = envs.LUNARVIM_RUNTIME_DIR .. "/lvim/init.lua"
vim.cmd.source(lvim_init)
