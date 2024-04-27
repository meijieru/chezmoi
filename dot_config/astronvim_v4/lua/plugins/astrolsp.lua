-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- default mappings:
-- ~/.local/share/nvim/lazy/AstroNvim/lua/astronvim/plugins/_astrolsp_mappings.lua

---@param opts AstroLSPOpts
local function opts_func(_, opts)
  opts.formatting.format_on_save.enabled = false
  opts.formatting.timeout_ms = 2000

  opts.servers = myvim.plugins.lsp.servers_from_system

  local maps = opts.mappings
  local to_remap = {
    n = {
      -- ["<Leader>ld"] = false,
      ["<Leader>la"] = false,
      ["<Leader>lr"] = false,
      ["<Leader>li"] = false,
      ["<Leader>lI"] = false,
      ["<Leader>ll"] = false,
      ["<Leader>lL"] = false,
      ["<Leader>lR"] = false,
      ["<Leader>lh"] = false,

      ["<Leader>lD"] = { desc = "Workspace Diagnostics" },

      ["<Leader>ld"] = {
        function() require("telescope.builtin").diagnostics { bufnr = 0 } end,
        desc = "Document diagnostics",
      },
      ["<Leader>lS"] = vim.tbl_deep_extend("force", maps.n["<Leader>lG"], { desc = "Workspace symbols" }),
      ["<Leader>lG"] = false,
    },

    v = {
      ["<Leader>lf"] = false,
      ["<Leader>la"] = false,
    },
  }
  maps = vim.tbl_deep_extend("force", maps, to_remap)

  -- -- TODO(meijieru): revisit
  -- maps.n["<Leader>lS"] = {
  --   function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
  --   desc = "Workspace symbols",
  --   cond = "workspace/symbol",
  -- }

  opts.mappings = maps
  return opts
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = opts_func,
}
