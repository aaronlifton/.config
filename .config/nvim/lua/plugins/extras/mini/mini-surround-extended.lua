return {
  "nvim-mini/mini.surround",
  optional = true,
  opts = {
    custom_surroundings = {
      -- Markdown Code block
      M = {
        output = { left = "```\n", right = "\n```" },
      },
      -- Markdown Inline code
      m = {
        output = { left = "`", right = "`" },
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
      n = {
        output = function()
          return { left = "\n", right = "\n" }
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
