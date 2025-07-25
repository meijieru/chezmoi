local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

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
    { family = "Symbols Nerd Font Mono", scale = 0.75 },
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

-- FIXME(meijieru): ctrl + shift + w sometimes doesn't work
local mykeys = {
  {
    key = "P",
    mods = "CTRL|SHIFT",
    action = act.DisableDefaultAssignment,
  },

  { key = "{", mods = "SHIFT|ALT", action = act({ ActivateTabRelative = -1 }) },
  { key = "}", mods = "SHIFT|ALT", action = act({ ActivateTabRelative = 1 }) },
  {
    key = "Space",
    mods = "SHIFT|ALT",
    action = act.ActivateCommandPalette,
  },
}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(mykeys, {
    key = tostring(i),
    mods = "CTRL|ALT",
    action = act({ ActivateTab = i - 1 }),
  })
end

local config = wezterm.config_builder()

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { left = 0, right = 0, top = 5, bottom = 0 }
config.enable_scroll_bar = false

config.exit_behavior = "Close"
config.keys = mykeys

config.front_end = "WebGpu"
local gpu_infos = {}
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu_infos[gpu.device_type] == nil then
    gpu_infos[gpu.device_type] = {
      [gpu.backend] = gpu,
    }
  else
    gpu_infos[gpu.device_type][gpu.backend] = gpu
  end
end

local gpu_info = gpu_infos["DiscreteGpu"] or gpu_infos["IntegratedGpu"]
local backend_fallback = { "Dx12", "Vulkan", "Metal" }
for _, backend in ipairs(backend_fallback) do
  local gpu = gpu_info[backend]
  if gpu ~= nil then
    config.webgpu_preferred_adapter = gpu
    break
  end
end

config.line_height = 0.95
config.font_size = 11.0
config.font_rules = font_rules
config.font = font_with_fallback({
  normal_font,
})
config.default_prog = { "wsl.exe", "~", "-d", "archlinux" }

config.enable_kitty_keyboard = true

-- FIXME(meijieru): sync to monitor
config.max_fps = 120

return config
