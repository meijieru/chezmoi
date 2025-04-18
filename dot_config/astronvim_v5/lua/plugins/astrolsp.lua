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

      ["<Leader>uY"] = false,
      ["<Leader>uf"] = false,
      ["<Leader>uF"] = false,
      ["<Leader>u?"] = false,

      ["<Leader>la"] = false,
      ["<Leader>lA"] = false,
      ["<Leader>lr"] = false,
      ["<Leader>ll"] = false,
      ["<Leader>lL"] = false,
      ["<Leader>lR"] = false,
      ["<Leader>lh"] = false,
      ["<Leader>lG"] = false,

      ["<Leader>ld"] = {
        function()
          require("snacks").picker.diagnostics_buffer()
        end,
        desc = "Document diagnostics",
      },
      ["grs"] = {
        function()
          require("snacks").picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
    },

    v = {
      ["<Leader>lf"] = false,
    },

    x = {
      ["<Leader>la"] = false,
    },
  }
  maps = vim.tbl_deep_extend("force", maps or {}, to_remap)

  maps.n["gd"][1] = function()
    require("snacks").picker.lsp_definitions()
  end
  maps.n["gD"][1] = function()
    require("snacks").picker.lsp_declarations()()
  end
  maps.n["gy"][1] = function()
    require("snacks").picker.lsp_type_definitions()
  end

  opts.mappings = maps
  return opts
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = opts_func,
}
