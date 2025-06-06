return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local codecompanion = {
      static = {
        processing = false,
      },
      update = {
        "User",
        pattern = "CodeCompanionRequest*",
        callback = function(self, args)
          if args.match == "CodeCompanionRequestStarted" then
            self.processing = true
          elseif args.match == "CodeCompanionRequestFinished" then
            self.processing = false
          end
          vim.cmd("redrawstatus")
        end,
      },
      {
        condition = function(self)
          return self.processing
        end,
        provider = " ",
        hl = { fg = "fg", bg = "bg" },
      },
    }

    opts.tabline = nil
    local status = require("astroui.status")
    local hl = require("astroui.status.hl")
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode(),
      status.component.file_info({
        filetype = {},
        filename = false,
        file_modified = {},
        surround = { separator = "left" },
      }),
      status.component.git_branch(),
      status.component.git_diff(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.diagnostics(),
      codecompanion,
      status.component.treesitter({
        str = { str = "", padding = { left = 0, right = 0 }, show_empty = true },
        surround = { separator = "none" },
      }),
      status.component.lsp({
        lsp_progress = false,
        lsp_client_names = {
          icon = { padding = { right = 1 } },
        },
        surround = { separator = "none" },
      }),
      status.component.nav({
        ruler = {
          pad_ruler = { line = 2, col = 2 },
          hl = { bold = true, fg = "bg" },
          padding = { left = 1, right = 1 },
        },
        scrollbar = false,
        percentage = false,
        surround = { color = hl.mode_bg },
        update = {
          "ModeChanged",
          "CursorMoved",
          "CursorMovedI",
          "BufEnter",
        },
      }),
    }
    return opts
  end,
}
