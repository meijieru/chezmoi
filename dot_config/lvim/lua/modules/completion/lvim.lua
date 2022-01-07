local M = {}

local safe_load = require("core.utils").safe_load

function M.setup_cmp()
  lvim.builtin.cmp.active = myvim.plugins.cmp.active
  if not myvim.plugins.cmp.active then
    return
  end

  local status_cmp_ok, cmp = safe_load "cmp"
  if not status_cmp_ok then
    return
  end
  local status_luasnip_ok, luasnip = safe_load "luasnip"
  if not status_luasnip_ok then
    return
  end

  lvim.builtin.cmp.formatting.duplicates = {
    nvim_lsp = 1,
    luasnip = 1,
    copilot = 1,
    cmp_tabnine = 0,
  }
  lvim.builtin.cmp.confirm_opts = {
    behavior = cmp.ConfirmBehavior.Insert,
    select = false,
  }
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
  lvim.builtin.cmp.sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "cmp_tabnine" },
    { name = "buffer" },
    { name = "treesitter" },
  }

  local function load_neogen()
    if myvim.plugins.neogen.active then
      local _, neogen = safe_load "neogen"
      return neogen
    end
    return nil
  end
  local map_modes = { "i", "s" }

  -- we don't use tab for cmp
  local methods = require("lvim.core.cmp").methods
  lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
    local neogen = load_neogen()
    if luasnip.expandable() then
      luasnip.expand()
    elseif methods.jumpable() then
      luasnip.jump(1)
    elseif neogen and neogen.jumpable() then
      neogen.jump_next()
    elseif methods.check_backspace() then
      fallback()
    end
  end, map_modes)
  lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
    local neogen = load_neogen()
    if methods.jumpable(-1) then
      luasnip.jump(-1)
    elseif neogen and neogen.jumpable(-1) then
      neogen.jump_prev()
    else
      fallback()
    end
  end, map_modes)
end

function M.setup_trouble()
  if not myvim.plugins.telescope.active or not myvim.plugins.trouble.active then
    return
  end
  local function _open_with_trouble(prompt_bufnr, _mode)
    -- defer trouble loading
    local trouble = require "trouble.providers.telescope"
    return trouble.open_with_trouble(prompt_bufnr, _mode)
  end

  lvim.builtin.telescope.defaults.mappings.i["<C-t>"] = _open_with_trouble
  lvim.builtin.telescope.defaults.mappings.n["<C-t>"] = _open_with_trouble
end

function M.setup_lsp()
  lvim.lsp.float.border = "rounded"
end

function M.setup()
  M.setup_trouble()
  M.setup_cmp()
  M.setup_lsp()
end

return M
