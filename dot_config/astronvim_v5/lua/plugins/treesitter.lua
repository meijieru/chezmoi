-- Customize Treesitter

-- if true then return {} end

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if opts.ensure_installed ~= "all" then
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "comment", "rst", "regex", "markdown", "markdown_inline", "gitcommit", "yaml" }
      )
    end

    -- TODO(meijieru): migrate to treesitter main branch

    -- opts.textobjects = vim.tbl_deep_extend("force", opts.textobjects, {
    --   select = {
    --     keymaps = {
    --       ["a,"] = { query = "@parameter.outer", desc = "around argument" },
    --       ["i,"] = { query = "@parameter.inner", desc = "inside argument" },
    --       ["aa"] = { query = "@assignment.outer", desc = "around assignment" },
    --       ["ia"] = { query = "@assignment.inner", desc = "inside assignment" },
    --     },
    --   },
    -- })
    -- opts.incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     -- init_selection = "gnn",
    --     node_incremental = ".",
    --     scope_incremental = ";",
    --     node_decremental = ",",
    --   },
    -- }
  end,
}
