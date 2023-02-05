local utils = require "core.utils"
local Log = require "core.log"

if utils.is_vscode() then
  Log:info "In vscode frontend"
  myvim.plugins.wakatime.active = false
  myvim.plugins.imtoggle.active = false
  myvim.plugins.cmp.active = false
end

if utils.is_neovide() then
  Log:info "In neovide frontend"
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"
  myvim.plugins.wakatime.active = false
end
