local M = {}

function M.hop()
  require("hop").setup()
end

function M.matchup()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
  -- enable ds%, cs%
  vim.g.matchup_surround_enabled = true
end

function M.lastplace()
  require("nvim-lastplace").setup {
    lastplace_ignore_buftype = myvim.ignores.buftype,
    lastplace_ignore_filetype = myvim.ignores.filetype,
    lastplace_open_folds = true,
  }
end

function M.dap_virtual_text()
  require("nvim-dap-virtual-text").setup {
    enabled = true,
  }
end

function M.visual_multi()
  local vm_maps = {}
  vm_maps["Select Operator"] = ""
  vm_maps["Undo"] = "u"
  vm_maps["Redo"] = "<C-r>"
  vm_maps["Reselect Last"] = "gs"
  -- useful default mappings
  -- \\z for normal everywhere
  -- ] for goto next
  -- [ for goto prev

  vim.g.VM_default_mappings = false
  vim.g.VM_maps = vm_maps
end

function M.aerial()
  local opts = {
    -- Priority list of preferred backends for aerial
    -- backends = { "lsp", "treesitter", "markdown" },
    backends = { "treesitter", "markdown", "lsp" },

    layout = {
      max_width = 40,
      min_width = 40,
    },

    lsp = {
      -- Set to false to not update the symbols when there are LSP errors
      update_when_errors = false,
    },

    -- A list of all symbols to display. Set to false to display all symbols.
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Struct",
    },
  }
  local icons = { Collapsed = "" }
  for _, name in ipairs(opts.filter_kind) do
    icons[name] = myvim.kind_icons[name]
    icons[name .. "Collapsed"] = string.format("%s %s", myvim.kind_icons[name], icons.Collapsed)
  end
  opts.icons = icons
  require("aerial").setup(opts)

  -- NOTE: doesn't take effect as this func is called after lsp setup
  -- lvim.lsp.on_attach_callback = function(client, bufnr)
  --   require("aerial").on_attach(client, bufnr)
  -- end
  require("telescope").load_extension "aerial"
end

function M.spellsitter()
  require("spellsitter").setup()
end

function M.neogen()
  require("neogen").setup { enabled = true }
end

function M.oscyank()
  vim.g.oscyank_silent = true
  vim.cmd [[
    " autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
  ]]
end

function M.ufo()
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ("  %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
  end

  require("ufo").setup {
    fold_virt_text_handler = handler,
  }
end

function M.auto_session()
  require("auto-session").setup {
    log_level = "info",
    auto_session_suppress_dirs = { "~/" },
  }
end

function M.session_lens()
  require("session-lens").setup {}
end

require("modules.editor.lvim").setup()

return M
