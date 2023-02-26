local function keymap_config()
  local to_disable = {
    -- duplicate with rd
    "rk",
    "rx",
  }
  for _, key in ipairs(to_disable) do
    vim.keymap.del("n", key, { buffer = 0 })
  end

  local utils = require "core.utils"
  local status_whichkey_ok, which_key = utils.safe_load "which-key"
  if not status_whichkey_ok then
    return
  end
  local keymap = require "core.keymap"

  which_key.register({
    q = { "<cmd>close<cr>", "Close" },
    -- Enable whichkey for rebase
    r = { "<Nop>" },
    -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
    dt = { keymap.chain("Gtabedit", "normal dv"), "Tab Diff" },
    D = {
      function()
        local info = require("core.utils.git").get_info_under_cursor()
        if info then
          if #info.paths > 0 then
            vim.cmd(("DiffviewOpen --selected-file=%s"):format(vim.fn.fnameescape(info.paths[1])))
          elseif info.commit ~= "" then
            vim.cmd(("DiffviewOpen %s^!"):format(info.commit))
          end
        end
      end,
      "Diff View",
    },
  }, {
    buffer = 0,
  })

  -- Annotate vim-fugitive mapping
  which_key.register({
    s = { "Stage" },
    u = { "Unstage" },
    ["."] = { "<cmd> <cfile>" },
    ["-"] = { "Stage or Unstage" },
    ["="] = { "Toggle inline diff for current" },
    U = { "Unstage everything" },
    X = { "Discard Change" },
    r = {
      name = "Rebase",
      i = { "Interactive" },
      f = { "Autosquash" },
      u = { "Interactive against @{upstream}" },
      p = { "Interactive against @{push}" },
      r = { "Continue" },
      s = { "Skip the current commit & Continue" },
      a = { "Abort rebase" },
      e = { "Edit rebase todo list" },
      w = { "Interactive, reword current" },
      m = { "Interactive, edit current" },
      d = { "Interactive, drop current" },
      ["<Space>"] = "<cmd>Git rebase ",
      ["?"] = { "Help" },
    },
    c = {
      name = "Commit & Stash",
      c = { "Create a commit" },
      a = { "Amend and reword the last" },
      e = { "Amend the last" },
      w = { "Reword the last" },
      v = {
        name = "Verbose",
        c = { "Create a commit with -v" },
        a = { "Amend the last commit with -v" },
      },
      f = { "Fixup" },
      F = { "Fixup and rebase" },
      s = { "Squash" },
      S = { "Squash and rebase" },
      A = { "Squash and reword" },
      ["<Space>"] = "<cmd>Git commit",
      r = {
        name = "Revert",
        c = { "Revert current" },
        n = { "Revert current, no commit" },
        ["<Space>"] = "<cmd>Git revert",
      },
      R = {
        name = "Amend & Reset Author",
        a = { "Amend and reword the last" },
        e = { "Amend the last" },
        w = { "Reword the last" },
      },
      m = {
        name = "Merge",
        ["<Space>"] = "<cmd>Git merge",
      },
      o = {
        name = "Checkout",
        o = { "Check out the commit under the cursor" },
        ["<Space>"] = "<cmd>Git checkout",
        ["?"] = { "Help" },
      },
      b = {
        name = "Branch",
        ["<Space>"] = "<cmd>Git branch",
        ["?"] = { "Help" },
      },
      z = {
        name = "Stash",
        z = { "Push stash. Pass a [count] of 1 to add `--include-untracked` or 2 to add `--all`" },
        w = { "Push stash, keep-index" },
        s = { "Push staged" },
        A = { "Apply top or @{count}" },
        a = { "Apply top or @{count}, preserving the index" },
        P = { "Pop top or @{count}" },
        p = { "Pop top or @{count}, preserving the index" },
        v = { "Show top or @{count}" },
        ["<Space>"] = "<cmd>Git stash",
        ["?"] = { "Help" },
      },
      ["?"] = { "Help" },
    },
  }, {
    buffer = 0,
  })
end

keymap_config()
