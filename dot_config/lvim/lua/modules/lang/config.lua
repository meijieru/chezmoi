local config = {}

-- speed up startup
-- $ANACONDA_HOME should be set in shell
local anaconda_home = os.getenv "ANACONDA_HOME"
if anaconda_home ~= nil then
  vim.g.python_host_prog = anaconda_home .. "/bin/python2"
  vim.g.python3_host_prog = anaconda_home .. "/bin/python3"
else
  vim.g.python_host_prog = "/usr/bin/python2"
  vim.g.python3_host_prog = "/usr/bin/python3"
end

require("modules.lang.lvim").setup()

-- TODO(meijieru): wait for https://github.com/nvim-treesitter/nvim-treesitter/issues/872
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.markdown = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "markdown",
}

function config.markdown_preview()
  vim.g.mkdp_auto_start = 0
  vim.g.mkdp_browser='wsl-open'
end

return config
