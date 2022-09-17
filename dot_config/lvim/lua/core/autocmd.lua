-- Autocommands (https://neovim.io/doc/user/autocmd.html)

local create_autocmd = vim.api.nvim_create_autocmd

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
create_autocmd("BufWritePost", {
  pattern = { "*/.local/share/chezmoi/*" },
  callback = function()
    require("core.utils").chezmoi_apply()
  end,
  desc="Trigger chezmoi apply"
})

-- disable fold
create_autocmd(
  "FileType",
  { pattern = { "alpha", "lspinfo", "aerial", "dapui_scopes" }, command = "setlocal nofoldenable" }
)
