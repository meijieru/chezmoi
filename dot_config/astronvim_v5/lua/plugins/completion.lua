local get_icon = require("astroui").get_icon
local list_insert_unique = require("astrocore").list_insert_unique

local function remove_select(list)
  return vim.tbl_filter(function(val)
    return not vim.tbl_contains({ "select_next", "select_prev" }, val)
  end, list)
end

local spec = {

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        keymap = {
          -- TODO(meijieru): word/line accept
          ["<Tab>"] = remove_select(opts.keymap["<Tab>"]),
          ["<S-Tab>"] = remove_select(opts.keymap["<S-Tab>"]),
          ["<C-J>"] = { "fallback" },
          ["<C-K>"] = { "fallback" },
        },
        cmdline = {
          completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
          },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal",
          },
        },
        completion = {
          menu = {
            auto_show = true,
            border = "rounded",
            winhighlight = "Normal:Normal",
          },
          documentation = {
            window = {
              border = "rounded",
              winhighlight = "Normal:Normal",
            },
          },
        },
        appearance = {
          kind_icons = {
            Copilot = get_icon("Copilot", 0, true),
          },
        },
      })
    end,
  },
}

return spec
