local M = {}

-- speed up startup
-- $ANACONDA_HOME should be set in shell
local anaconda_home = os.getenv "ANACONDA_HOME"
if anaconda_home ~= nil then
  vim.g.python3_host_prog = anaconda_home .. "/bin/python3"
else
  vim.g.python3_host_prog = "/usr/bin/python3"
end

function M.rust_tools()
  require("rust-tools").setup {}
end

-- disable languages
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

require("modules.lang.lvim").setup()

function M.markdown_preview()
  vim.g.mkdp_auto_start = 0
  -- vim.g.mkdp_browser = "msedge"
  vim.g.mkdp_browserfunc = "auxlib#url_open"
end

return M
