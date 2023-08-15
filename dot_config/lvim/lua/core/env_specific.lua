local utils = require "core.utils"
local Log = require "core.log"

if utils.is_vscode() then
  Log:debug "In vscode frontend"
  myvim.plugins.wakatime.active = false
  myvim.plugins.imtoggle.active = false
  myvim.plugins.cmp.active = false
end

if utils.is_neovide() then
  Log:debug "In neovide frontend"
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"
  myvim.plugins.wakatime.active = false

  -- FIXME(meijieru): until fixed upstream
  myvim.plugins.imtoggle.active = false
end

if utils.is_wsl() then
  Log:debug "In wsl"

  -- -- error on utf-8, use win32yank instead
  -- vim.g.clipboard = {
  --   name = "WslClipboard",
  --   copy = {
  --     ["+"] = "clip.exe",
  --     ["*"] = "clip.exe",
  --   },
  --   paste = {
  --     ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --     ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --   },
  --   cache_enabled = 0,
  -- }
end
