local on = vim.api.nvim_create_autocmd

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
on("BufWritePost", {
  pattern = { "*/.local/share/chezmoi/*" },
  callback = function(env)
    require("core.utils").chezmoi_apply(env.file)
  end,
  desc = "Trigger chezmoi apply",
})

on("FileType", {
  pattern = { "alpha", "lspinfo", "aerial", "dapui_scopes" },
  callback = function()
    vim.wo.foldenable = false
  end,
  desc = "Disable fold",
})

-- overwrite highlight
on("Colorscheme", {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
  end,
  desc = "Customize highlight",
})

-- diable lvim autocmds
local autocmds_to_disable = {
  {
    group = "_general_settings",
    event = "TextYankPost",
  },
}
for _, params in ipairs(autocmds_to_disable) do
  local autocmds = vim.api.nvim_get_autocmds(params)
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_del_autocmd(autocmd.id)
  end
end
