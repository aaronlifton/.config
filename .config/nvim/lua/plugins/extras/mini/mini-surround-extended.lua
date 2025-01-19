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
    },
  },
}
