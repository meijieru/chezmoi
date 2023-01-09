local function keymap_config()
  local keymap = require "core.keymap"

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close" })
  -- https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
  vim.keymap.set("n", "dt", keymap.chain("Gtabedit", "normal dv"), { buffer = true, desc = "Tab Diff" })

  vim.keymap.set("n", "D", function()
    local info = require("core.utils.git").get_info_under_cursor()

    if info then
      if #info.paths > 0 then
        vim.cmd(("DiffviewOpen --selected-file=%s"):format(vim.fn.fnameescape(info.paths[1])))
      elseif info.commit ~= "" then
        vim.cmd(("DiffviewOpen %s^!"):format(info.commit))
      end
    end
  end, {
    buffer = true,
    desc = "Diff View",
  })
end

keymap_config()
