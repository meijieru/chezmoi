local Log = require "core.log"
if vim.api.nvim_create_user_command == nil then
  Log:info "Skip customized commands"
  return
end

local dap_utils = require "core.utils.dap"
vim.api.nvim_create_user_command("MyDapStoreBreakpoints", dap_utils.store, { desc = "Save DAP breakpoints" })
vim.api.nvim_create_user_command("MyDapLoadBreakpoints", dap_utils.load, { desc = "Load DAP breakpoints" })

vim.api.nvim_create_user_command("UpdateAll", function()
  vim.cmd "TSUpdate"
  require("lazy").sync { show = true }
end, {
  desc = "Update plugins & lsp & treesitter parsers",
})
