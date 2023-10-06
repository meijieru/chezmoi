-- default autocmds: ~/.config/astronvim/lua/astronvim/autocmds.lua

local api = vim.api
local map = vim.keymap.set
local on = vim.api.nvim_create_autocmd

-- https://www.chezmoi.io/docs/how-to/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
on("BufWritePost", {
  pattern = { "*/.local/share/chezmoi/*" },
  callback = function(env)
    local file = env.file
    local path = require "plenary.path"
    local relpath = path:new(file):make_relative()
    if vim.startswith(file, "fugitive:///") or vim.startswith(relpath, ".git") then return end

    vim.system({ "chezmoi", "apply", "--source-path", file }, { text = true }, function(obj)
      local opts = { title = "Chezmoi Apply" }
      if obj.code == 0 and obj.signal == 0 then
        vim.notify(string.format("Done: %s", relpath), vim.log.levels.INFO, opts)
        return
      end
      local info = table.concat(vim.split(obj.stderr, ":"), ":", 2):gsub("\n$", "")
      vim.notify(info, vim.log.levels.ERROR, opts)
    end)
  end,
  desc = "Trigger chezmoi apply",
})

on("FileType", {
  pattern = { "startuptime", "fugitiveblame" },
  callback = function() map("n", "q", "<cmd>close<cr>", { buffer = 0, desc = "Close" }) end,
})

on("FileType", {
  pattern = { "alpha" },
  callback = function() map("n", "q", "<cmd>quit<cr>", { buffer = 0, desc = "Quit" }) end,
})

on("FileType", {
  pattern = { "alpha", "lspinfo", "aerial", "dapui_scopes" },
  callback = function() api.nvim_set_option_value("foldenable", false, { scope = "local", win = 0 }) end,
  desc = "Disable fold",
})

on("FileType", {
  pattern = { "lua", "json", "markdown" },
  callback = function()
    vim.notify("set tabstop from filetype plugin", vim.log.levels.DEBUG, { title = "Filetype indent" })
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
  desc = "Filetype indent",
})

-- diable autocmds
local autocmds_to_disable = {
  {
    group = "neotree_start",
  },
}
for _, params in ipairs(autocmds_to_disable) do
  local autocmds = api.nvim_get_autocmds(params)
  for _, autocmd in ipairs(autocmds) do
    api.nvim_del_autocmd(autocmd.id)
  end
end
