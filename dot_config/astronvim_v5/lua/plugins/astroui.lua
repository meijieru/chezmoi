-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "onelight",
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",

      ActiveTS = "",
      VimIcon = "",
      GitAdd = "",
      GitChange = "",
      GitDelete = "",
      GitSignTopDelete = "▔",
      Quit = "",
      Copilot = "",
    },

    status = {
      attributes = {
        mode = { bold = true },
      },
      separators = {
        -- left = { "", " " },
        -- right = { " ", "" },
        left = { "", " " },
        right = { " ", "" },
      },
    },
  },
}
