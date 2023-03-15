local wezterm = require("wezterm")
local mux = wezterm.mux

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "OneHalfDark"
  else
    return "OneHalfLight"
  end
end

local mykeys = {
  { key = "{", mods = "SHIFT|ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "}", mods = "SHIFT|ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(mykeys, {
    key = tostring(i),
    mods = "CTRL|ALT",
    action = wezterm.action({ ActivateTab = i - 1 }),
  })
end

local function font_with_fallback(fonts, params)
  if #fonts ~= 1 then
    error("Only support one")
  end
  local names = {
    fonts[1],
    -- "JetBrainsMono NF",
    "Microsoft Yahei",
    { family = "Symbols Nerd Font Mono", scale = 0.8 },
  }

  return wezterm.font_with_fallback(names, params)
end

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local normal_font = "JetBrains Mono"

return {
  hide_tab_bar_if_only_one_tab = false,
  enable_tab_bar = true,

  font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback({
        {
          family = "Victor Mono",
          -- disable ligature due to mixed fonts, it cause uneven fonts
          harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
        },
      }, {
        weight = "Bold",
        italic = true,
      }),
    },
    {
      intensity = "Bold",
      font = font_with_fallback({ normal_font }, { weight = "Bold" }),
    },
    {
      italic = true,
      font = font_with_fallback({
        {
          family = "Victor Mono",
          harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
        },
      }, {
        weight = "Medium",
        -- weight = "Semibold",
        italic = true,
      }),
    },
    {
      intensity = "Normal",
      font = font_with_fallback({ normal_font }, { weight = "Regular" }),
    },
  },
  font = font_with_fallback({
    normal_font,
  }),
  font_size = 13.0,
  line_height = 0.95,
  -- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  default_prog = { "wsl.exe", "~", "-d", "archlinux" },

  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

  -- window_decorations = "NONE",
  window_padding = { left = 5, right = 0, top = 0, bottom = 0 },

  window_background_image = "D:\\document\\cloud_storage\\nextcloud\\picture\\comic\\eva\\EVA_OneHalfLight.jpg",
  window_background_image_hsb = {
    brightness = 1.0,
    hue = 1.0,
    saturation = 1.0,
  },

  window_background_opacity = 1.0,
  text_background_opacity = 0.90,

  exit_behavior = "Close",
  keys = mykeys,
}
