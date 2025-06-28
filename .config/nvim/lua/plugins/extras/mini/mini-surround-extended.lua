return {
  "echasnovski/mini.surround",
  optional = true,
  opts = {
    custom_surroundings = {
      M = {
        output = { left = "```\n", right = "\n```" },
      },
      -- Markdown URL surround
      L = {
        -- input = { "%[().*()%]%(.*%)" }, -- Matches [text](url)
        output = { left = "[", right = "]()" },
      },
      ["\\r"] = {
        output = function()
          local opts = { left = "\r", right = "\r" }
          return opts
        end,
      },
      -- L = {
      --   input = { "%[().-()%]%(.-%)"},
      --   output = function()
      --     local link = require("mini.surround").user_input("Link: ")
      --     return { left = "[", right = "](" .. link .. ")" }
      --   end,
      -- },
    },
  },
}
