local M = {}

function M.leap()
  require("leap").add_default_mappings()
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

function M.neotest()
  local animated_icons = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
      },
      require "neotest-plenary",
      require "neotest-jest" {
        cwd = require("neotest-jest").root,
      },
    },
    consumers = {
      overseer = require "neotest.consumers.overseer",
    },
    summary = {
      mappings = {
        expand = "l",
        expand_all = "L",
        jumpto = { "gf", "<CR>" },
      },
    },
    icons = {
      passed = " ",
      running = " ",
      failed = " ",
      unknown = " ",
      running_animated = vim.tbl_map(function(s)
        return s .. " "
      end, animated_icons),
      non_collapsible = " ",
      collapsed = "",
      expanded = "",
      child_prefix = " ",
      final_child_prefix = " ",
      child_indent = " ",
      final_child_indent = " ",
    },
    quickfix = { open = false },
    output = {
      open_on_run = false,
    },
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
    backends = { "lsp", "treesitter", "markdown", "man" },

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

  local ft_map = {
    ["neotest-summary"] = "",
  }
  require("ufo").setup {
    fold_virt_text_handler = handler,
    provider_selector = function(_, filetype, _)
      return ft_map[filetype]
    end,
  }
end

require("modules.editor.lvim").setup()

return M
