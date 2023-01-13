local null_ls = require "null-ls"
local is_registered = require("null-ls.sources").is_registered
local source = require "typescript.extensions.null-ls.code-actions"
if not is_registered { name = source.name, method = source.method } then
  null_ls.register { sources = { source } }
end
