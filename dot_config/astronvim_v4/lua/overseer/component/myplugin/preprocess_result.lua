return {
  desc = "Call a callback when get result",
  params = {
    on_preprocess_result = {
      desc = "Callback that modify the result in place",
      type = "opaque",
    },
  },
  serializable = false,
  constructor = function(params)
    return {
      on_preprocess_result = function(self, task, result) params.on_preprocess_result(self, task, result) end,
    }
  end,
}
