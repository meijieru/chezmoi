-- default mappings: ~/.config/astronvim/lua/astronvim/utils/lsp.lua

return function(maps)
  local to_disable = {
    n = {
      ["<leader>ld"] = false,
      ["<leader>li"] = false,
      ["<leader>lI"] = false,
      ["<leader>ll"] = false,
      ["<leader>lL"] = false,
      ["<leader>lR"] = false,
      ["<leader>lh"] = false,
      ["<leader>lG"] = false,
    },

    v = {
      ["<leader>lf"] = false,
    },
  }
  maps = vim.tbl_deep_extend("force", maps, to_disable)

  maps.n["<leader>ld"] = {
    function() require("telescope.builtin").diagnostics { bufnr = 0 } end,
    desc = "Document diagnostics",
  }
  maps.n["<leader>lD"].desc = "Workspace Diagnostics"
  maps.n["<leader>lS"] =
    { function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols" }

  if maps.n["<leader>uH"] ~= nil then
    maps.n["<leader>uh"] = maps.n["<leader>uH"]
    maps.n["<leader>uH"] = nil
  end

  return maps
end
