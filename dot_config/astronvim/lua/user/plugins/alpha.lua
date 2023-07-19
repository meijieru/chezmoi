local is_available = require("astronvim.utils").is_available

local cutty_cat = {
  "  ⟋|､",
  " (°､ ｡ 7",
  " |､  ~ヽ",
  " じしf_,)〳",
}
local alpha_theme_name = "theta"

local function get_alpha_header()
  if is_available "pokemon.nvim" then return require("pokemon").header() end
  return cutty_cat
end

local alpha_opts_func_map = {
  dashboard = function(_, opts)
    opts.section.header.val = get_alpha_header()

    local button, get_icon = require("astronvim.utils").alpha_button, require("astronvim.utils").get_icon
    opts.section.buttons.val = {
      button("SPC f f", get_icon("Search", 2, true) .. "Find file"),
      button("SPC f p", get_icon("Git", 2, true) .. "Find project"),
      button("SPC *", get_icon("WordFile", 2, true) .. "Live grep"),
    }

    return opts
  end,
  theta = function()
    local theme = require "alpha.themes.theta"
    local get_icon = require("astronvim.utils").get_icon
    local button = require("alpha.themes.dashboard").button
    theme.header.val = get_alpha_header()
    theme.buttons.val = vim.iter(theme.buttons.val):slice(1, 3):totable()
    vim.list_extend(theme.buttons.val, {
      button("SPC f f", get_icon("Search", 2, true) .. "Find file"),
      button("SPC f p", get_icon("Git", 2, true) .. "Find project"),
      button("SPC *", get_icon("WordFile", 2, true) .. "Live grep"),
    })
    return theme
  end,
}

return {
  {
    "goolord/alpha-nvim",
    opts = alpha_opts_func_map[alpha_theme_name],
    config = function(_, opts) require("alpha").setup(opts.config) end,
  },

  {
    "ColaMint/pokemon.nvim",
    config = function()
      local number_candidates = {
        "0025",
        "0039",
        "0104",
        "0105",
        "0116",
        "0131",
        "0006.3",
        "0735.1",
        "0196.1",
        "0628.2",
      }
      local number
      math.randomseed(os.time())
      if math.random() > 0.5 then
        number = "random"
      else
        number = number_candidates[math.random(#number_candidates)]
      end
      require("pokemon").setup {
        number = number,
        size = "tiny",
      }
    end,
    enabled = false,
  },
}
