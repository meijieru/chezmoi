-- Autocommands (https://neovim.io/doc/user/autocmd.html)

local create_autocmd = vim.api.nvim_create_autocmd

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
create_autocmd("BufWritePost", {
  pattern = { "*/.local/share/chezmoi/*" },
  callback = function()
    require("core.utils").chezmoi_apply()
  end,
  desc = "Trigger chezmoi apply",
})

-- disable fold
create_autocmd(
  "FileType",
  { pattern = { "alpha", "lspinfo", "aerial", "dapui_scopes" }, command = "setlocal nofoldenable" }
)

-- diable lvim autocmds
local autocmds = vim.api.nvim_get_autocmds {
  group = "_filetype_settings",
  event = { "FileType" },
  pattern = { "alpha" },
}
for _, autocmd in ipairs(autocmds) do
  vim.api.nvim_del_autocmd(autocmd.id)
end
