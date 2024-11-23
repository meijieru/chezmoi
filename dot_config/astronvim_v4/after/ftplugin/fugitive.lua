--- TODO(meijieru): disable some keymaps
local function keymap_config()
  -- local to_disable = {
  --   -- duplicate with rd
  --   "rk",
  --   "rx",
  -- }
  -- for _, key in ipairs(to_disable) do
  --   vim.keymap.del("n", key, { buffer = 0 })
  -- end
  --
  local wk_avail, wk = pcall(require, "which-key")
  if not wk_avail then return end
  local keymap_utils = require "core.utils.keymap"

  wk.add({
    { "q", "<cmd>close<cr>", desc = "Close" },
    -- Enable whichkey for rebase
    { "r", "<Nop>" },
    -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
    { "dt", keymap_utils.chain("Gtabedit", "normal dv"), desc = "Tab Diff" },
    {
      "D",
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
      desc = "Diff View",
    },
  }, {
    buffer = 0,
  })

  -- Annotate vim-fugitive mapping
  wk.add({
    { "-", desc = "Stage or Unstage" },
    { ".", desc = "<cmd> <cfile>" },
    { "=", desc = "Toggle inline diff for current" },
    { "U", desc = "Unstage everything" },
    { "X", desc = "Discard Change" },
    { "c", group = "Commit & Stash" },
    { "c<Space>", desc = "<cmd>Git commit" },
    { "c?", desc = "Help" },
    { "cA", desc = "Squash and reword" },
    { "cF", desc = "Fixup and rebase" },
    { "cR", group = "Amend & Reset Author" },
    { "cRa", desc = "Amend and reword the last" },
    { "cRe", desc = "Amend the last" },
    { "cRw", desc = "Reword the last" },
    { "cS", desc = "Squash and rebase" },
    { "ca", desc = "Amend and reword the last" },
    { "cb", group = "Branch" },
    { "cb<Space>", desc = "<cmd>Git branch" },
    { "cb?", desc = "Help" },
    { "cc", desc = "Create a commit" },
    { "ce", desc = "Amend the last" },
    { "cf", desc = "Fixup" },
    { "cm", group = "Merge" },
    { "cm<Space>", desc = "<cmd>Git merge" },
    { "co", group = "Checkout" },
    { "co<Space>", desc = "<cmd>Git checkout" },
    { "co?", desc = "Help" },
    { "coo", desc = "Check out the commit under the cursor" },
    { "cr", group = "Revert" },
    { "cr<Space>", desc = "<cmd>Git revert" },
    { "crc", desc = "Revert current" },
    { "crn", desc = "Revert current, no commit" },
    { "cs", desc = "Squash" },
    { "cv", group = "Verbose" },
    { "cva", desc = "Amend the last commit with -v" },
    { "cvc", desc = "Create a commit with -v" },
    { "cw", desc = "Reword the last" },
    { "cz", group = "Stash" },
    { "cz<Space>", desc = "<cmd>Git stash" },
    { "cz?", desc = "Help" },
    { "czA", desc = "Apply top or @{count}" },
    { "czP", desc = "Pop top or @{count}" },
    { "cza", desc = "Apply top or @{count}, preserving the index" },
    { "czp", desc = "Pop top or @{count}, preserving the index" },
    { "czs", desc = "Push staged" },
    { "czv", desc = "Show top or @{count}" },
    { "czw", desc = "Push stash, keep-index" },
    { "czz", desc = "Push stash. Pass a [count] of 1 to add `--include-untracked` or 2 to add `--all`" },
    { "r", group = "Rebase" },
    { "r<Space>", desc = "<cmd>Git rebase " },
    { "r?", desc = "Help" },
    { "ra", desc = "Abort rebase" },
    { "rd", desc = "Interactive, drop current" },
    { "re", desc = "Edit rebase todo list" },
    { "rf", desc = "Autosquash" },
    { "ri", desc = "Interactive" },
    { "rm", desc = "Interactive, edit current" },
    { "rp", desc = "Interactive against @{push}" },
    { "rr", desc = "Continue" },
    { "rs", desc = "Skip the current commit & Continue" },
    { "ru", desc = "Interactive against @{upstream}" },
    { "rw", desc = "Interactive, reword current" },
    { "s", desc = "Stage" },
    { "u", desc = "Unstage" },
  }, {
    buffer = 0,
  })
end

keymap_config()
