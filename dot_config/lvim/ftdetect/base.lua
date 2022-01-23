local Log = require "core.log"
if vim.filetype == nil then
  Log:info "Skip customized filetypes"
  return
end

vim.filetype.add {
  extension = {
    tl = "teal",
  },
  filename = {
    [".tasks"] = "dosini",
  },
  pattern = {
    -- [".*/etc/foo/.*%.conf"] = "foorc",
  },
}
