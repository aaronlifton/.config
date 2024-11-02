local openai = require("model.providers.openai")
local mode = require("model").mode

return {
  ["to spanish"] = {
    provider = openai,
    hl_group = "SpecialComment",
    builder = function(input)
      return {
        messages = {
          {
            role = "system",
            content = "Translate to Spanish",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
    mode = mode.REPLACE,
  },
  ["to javascript"] = {
    provider = openai,
    builder = function(input, ctx)
      return {
        messages = {
          {
            role = "system",
            content = "Convert the code to javascript",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
  },
  ["to rap"] = {
    provider = openai,
    hl_group = "Title",
    builder = function(input)
      return {
        messages = {
          {
            role = "system",
            content = "Explain the code in 90's era rap lyrics",
          },
          {
            role = "user",
            content = input,
          },
        },
      }
    end,
  },
}
