local api = vim.api
local map = vim.keymap.set
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
  pattern = { "startuptime", "fugitiveblame" },
  callback = function()
    map("n", "q", "<cmd>close<cr>", { buffer = 0, desc = "Close" })
  end,
})

on("FileType", {
  pattern = { "alpha" },
  callback = function()
    map("n", "q", "<cmd>quit<cr>", { buffer = 0, desc = "Quit" })
  end,
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
    api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
    -- TODO(meijieru): revisit when colorscheme has lsp semantic token support
    api.nvim_set_hl(0, "@lsp.type.variable", { link = "@variable" })
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
  local autocmds = api.nvim_get_autocmds(params)
  for _, autocmd in ipairs(autocmds) do
    api.nvim_del_autocmd(autocmd.id)
  end
end
