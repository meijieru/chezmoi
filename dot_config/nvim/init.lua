local home_dir = os.getenv("HOME")
local envs = {
  LUNARVIM_CONFIG_DIR = home_dir .. "/.config/lvim",
  LUNARVIM_RUNTIME_DIR = home_dir .. "/.local/share/lunarvim",
}
for key, val in pairs(envs) do
  vim.fn.setenv(key, val)
end

local lvim_init = envs.LUNARVIM_RUNTIME_DIR .. "/lvim/init.lua"
vim.cmd("source " .. lvim_init)
