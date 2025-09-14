-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- NOTE(meijieru): This guarantees that the specs are processed before any user plugins.

local spec = {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.editing-support.conform-nvim" },
  -- import/override with your plugins folder
}

if myvim.plugins.machine_specific.is_development_machine and not myvim.plugins.machine_specific.is_using_corp_lsp then
  return vim.list_extend(spec, {
    { import = "astrocommunity.pack.bash" },
    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.toml" },
    { import = "astrocommunity.pack.yaml" },
    { import = "astrocommunity.pack.xml" },
    { import = "astrocommunity.pack.html-css" },
    { import = "astrocommunity.pack.markdown" },
    { import = "astrocommunity.pack.cpp" },
    { import = "astrocommunity.pack.biome" },
  })
end

return spec
