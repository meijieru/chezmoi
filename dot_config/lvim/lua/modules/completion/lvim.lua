local M = {}

local utils = require "core.utils"

function M.setup_cmp()
  lvim.builtin.cmp.active = myvim.plugins.cmp.active
  if not myvim.plugins.cmp.active then
    return
  end

  local status_cmp_ok, cmp_mapping = utils.safe_load "cmp.config.mapping"
  if not status_cmp_ok then
    return
  end

  lvim.builtin.cmp.cmdline.enable = true

  lvim.builtin.cmp.formatting.duplicates = vim.tbl_extend("force", lvim.builtin.cmp.formatting.duplicates, {
    nvim_lsp = 1,
    copilot = 1,
    cmp_tabnine = 0,
    path = 0,
    buffer = 0,
  })
  lvim.builtin.cmp.formatting.kind_icons = myvim.kind_icons

  local template, source_names =
    "(%s)", {
      nvim_lsp = "LSP",
      emoji = "Emoji",
      path = "Path",
      calc = "Calc",
      cmp_tabnine = "TabN",
      vsnip = "Snip",
      luasnip = "Snip",
      buffer = "Buf",
      nvim_lua = "Nlua",
      copilot = "Copl",
      treesitter = "TS",
    }
  lvim.builtin.cmp.formatting.source_names = vim.tbl_map(function(val)
    return string.format(template, val)
  end, source_names)

  local neogen = utils.require_on_index "neogen"
  local luasnip = utils.require_on_index "luasnip"

  for _, key in ipairs { "<C-J>", "<C-K>", "<C-D>", "<C-E>", "<C-F>", "<C-Y>", "<Down>", "<Up>" } do
    lvim.builtin.cmp.mapping[key] = nil
  end

  lvim.builtin.cmp.mapping["<C-D>"] = cmp_mapping.scroll_docs(8)
  lvim.builtin.cmp.mapping["<C-U>"] = cmp_mapping.scroll_docs(-8)

  -- we don't use tab for cmp
  local map_modes = { "i", "s" }
  lvim.builtin.cmp.mapping["<Tab>"] = cmp_mapping(function(fallback)
    local methods = require("lvim.core.cmp").methods
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif methods.jumpable(1) then
      luasnip.jump(1)
    elseif neogen and neogen.jumpable() then
      neogen.jump_next()
    else
      fallback()
    end
  end, map_modes)
  lvim.builtin.cmp.mapping["<S-Tab>"] = cmp_mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif neogen and neogen.jumpable(-1) then
      neogen.jump_prev()
    else
      fallback()
    end
  end, map_modes)
end

function M.setup_lsp()
  -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
  local ok, wf = pcall(require, "vim.lsp._watchfiles")
  if ok then
    -- disable lsp watcher. Too slow on linux
    wf._watchfunc = function()
      return function() end
    end
  end

  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, myvim.lsp.lvim.skipped_servers)
  lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(val)
    if vim.tbl_contains(myvim.lsp.lvim.ensured_servers, val) then
      return false
    else
      return true
    end
  end, lvim.lsp.automatic_configuration.skipped_servers)

  lvim.lsp.automatic_configuration.skipped_filetypes = vim.tbl_filter(function(val)
    if vim.tbl_contains(myvim.lsp.lvim.ensured_filetypes, val) then
      return false
    else
      return true
    end
  end, lvim.lsp.automatic_configuration.skipped_filetypes)
end

function M.setup()
  M.setup_cmp()
  M.setup_lsp()
end

return M
