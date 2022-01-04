local utils = require "core.utils"
local Log = require "core.log"

if utils.is_vscode() then
  Log:info "In vscode frontend"
  myvim.plugins.wakatime.active = false
  myvim.plugins.imtoggle.active = false
  myvim.plugins.cmp.active = false
end
