local wezterm = require("wezterm")

local function font_with_fallback(name, params)
  local names = {
    name,
    "JetBrainsMono NF",
    "Microsoft Yahei",
  }
  return wezterm.font_with_fallback(names, params)
end

return {
  hide_tab_bar_if_only_one_tab = true,
  enable_tab_bar = false,

  font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("Victor Mono", { weight = "Bold", italic = true }),
    },
    {
      intensity = "Bold",
      font = font_with_fallback("JetBrains Mono", { weight = "Bold" }),
    },
    {
      italic = true,
      font = font_with_fallback("Victor Mono", { weight = "Medium", italic = true }),
      -- font = font_with_fallback("Victor Mono", { weight = "Semibold", italic = true }),
    },
    {
      intensity = "Normal",
      font = font_with_fallback("JetBrains Mono", { weight = "Regular" }),
    },
  },
  font = font_with_fallback(
    "JetBrains Mono"
    -- "Victor Mono"
    -- "VictorMono NF"
    -- "FiraCode NF"
    -- "Cascadia Code"
  ),
  font_size = 13.0,
  line_height = 0.95,
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  default_prog = { "wsl.exe", "~", "-d", "archlinux" },

  color_scheme = "OneHalfLight",

  -- window_decorations = "NONE",
  window_padding = { left = 5, right = 0, top = 0, bottom = 0 },

  window_background_image = "D:\\document\\nextcloud\\picture\\comic\\eva\\EVA_OneHalfLight.jpg",
  window_background_image_hsb = {
    brightness = 1.0,
    hue = 1.0,
    saturation = 1.0,
  },

  window_background_opacity = 1.0,
  text_background_opacity = 0.90,

  exit_behavior = "Close",
  -- keys = {
  --   { key = "LeftArrow", mods = "SHIFT", action = "ActivateTabRelative=-1" },
  --   { key = "RightArrow", mods = "SHIFT", action = "ActivateTabRelative=1" },
  -- },
}
