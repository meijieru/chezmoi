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

  lvim.builtin.cmp.cmdline.enable = true

  lvim.builtin.cmp.formatting.duplicates = vim.tbl_extend("force", lvim.builtin.cmp.formatting.duplicates, {
    nvim_lsp = 1,
    copilot = 1,
    cmp_tabnine = 0,
    path = 0,
    buffer = 0,
  })
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

  local function load_neogen()
    if myvim.plugins.neogen.active then
      local _, neogen = safe_load "neogen"
      return neogen
    end
    return nil
  end
  local map_modes = { "i", "s" }

  -- we don't use tab for cmp
  local status_luasnip_ok, luasnip = safe_load "luasnip"
  if not status_luasnip_ok then
    return
  end
  local methods = require("lvim.core.cmp").methods
  lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
    local neogen = load_neogen()
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
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
  -- disable keymap
  for _, key in ipairs { "<C-J>", "<C-K>", "<Down>", "<Up>" } do
    lvim.builtin.cmp.mapping[key] = nil
  end
end

function M.setup_lsp()
  lvim.lsp.float.border = "rounded"
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, myvim.lsp.lvim.skipped_servers)
end

function M.setup()
  M.setup_cmp()
  M.setup_lsp()
end

return M
