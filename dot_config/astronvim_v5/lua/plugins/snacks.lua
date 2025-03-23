local normal_command = require("core.utils.keymap").normal_command

local is_available = require("astrocore").is_available

local function get_header()
  local cutty_cat = {
    "  ⟋|､",
    " (°､ ｡ 7",
    " |､  ~ヽ",
    " じしf_,)〳",
  }

  if is_available "pokemon.nvim" then return require("pokemon").header() end
  return cutty_cat
end

local function schedule_cmd(value)
  vim.schedule(function() vim.cmd(value) end)
end

return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    ---@class snacks.picker.Config
    local picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },

      layout = {
        preset = "default",
        layout = {
          backdrop = false,
        },
      },

      win = {
        input = {
          keys = {
            -- `<Ctrl-/>` to toggle help input, interpretted by terminal
            ["<C-_>"] = { "toggle_help_input", mode = { "i" } },
            ["g?"] = { "toggle_help_input", mode = { "n" } },
            ["<C-J>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-K>"] = { "history_back", mode = { "i", "n" } },
          },
        },
      },

      actions = {
        diffview_commit = function(picker, item)
          schedule_cmd("DiffviewOpen " .. item.commit .. "^!")
          picker:close()
        end,
        diffview_branch = function(picker, item)
          schedule_cmd("DiffviewOpen " .. item.branch)
          picker:close()
        end,
      },
    }

    -- TODO(meijieru): <cr> to restore in snacks.picker.undo
    opts.picker = vim.tbl_deep_extend("force", opts.picker or {}, picker)

    local get_icon = require("astroui").get_icon
    ---@class snacks.dashboard.Config
    local dashboard = {
      preset = {
        header = table.concat(get_header(), "\n"),
        keys = {
          { key = "n", action = normal_command "enew", icon = get_icon("FileNew", 0, true), desc = "New File" },
          { key = "l", action = "<Leader>Sl", icon = get_icon("Refresh", 0, true), desc = "Last Session" },
          { key = "q", action = normal_command "quit", icon = get_icon("Quit", 0, true), desc = "Quit" },
        },
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 1, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 1,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function() return require("snacks").git.get_root() ~= nil end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    }
    opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, dashboard)

    local on_open = opts.zen.on_open
    local on_close = opts.zen.on_close
    ---@class snacks.zen.Config
    local zen = {
      on_open = function(win)
        on_open(win)
        if is_available "nvim-scrollbar" then vim.cmd "ScrollbarToggle" end
      end,
      on_close = function(win)
        on_close(win)
        if is_available "nvim-scrollbar" then vim.cmd "ScrollbarToggle" end
      end,
    }
    opts.zen = vim.tbl_deep_extend("force", opts.zen or {}, zen)

    ---@class snacks.notifier.Config
    local notifier = {
      timeout = 5000,
      level = vim.log.levels.INFO,
    }
    opts.notifier = vim.tbl_deep_extend("force", opts.notifier or {}, notifier)

    return opts
  end,
}
