local wezterm = require("wezterm")
local mux = wezterm.mux

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Edge Dark (base16)"
  else
    return "Edge Light (base16)"
  end
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
local font_rules = {
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
}

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

local config = wezterm.config_builder()

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { left = 0, right = 0, top = 5, bottom = 0 }
config.enable_scroll_bar = false

config.exit_behavior = "Close"
config.keys = mykeys

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  -- flickring on Intel IntegratedGpu
  if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" and gpu.name:find("Intel") == nil then
    config.webgpu_preferred_adapter = gpu
    config.front_end = "WebGpu"
    break
  end
end

config.line_height = 0.95
config.font_size = 13.0
config.font_rules = font_rules
config.font = font_with_fallback({
  normal_font,
})
config.default_prog = { "wsl.exe", "~", "-d", "archlinux" }

return config
