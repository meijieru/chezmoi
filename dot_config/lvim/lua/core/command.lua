vim.api.nvim_add_user_command("MyInspect", function(kwargs)
  local vars = vim.split(kwargs.args, ".", { plain = true, trimempty = true })
  local var = _G
  for _, key in ipairs(vars) do
    var = var[key]
  end
  print(vim.inspect { var })
end, { desc = "Lua Inspect", nargs = "+" })
