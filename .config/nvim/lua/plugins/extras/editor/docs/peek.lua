return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        ft = { "markdown", "markdown.mdx", "mdx" },
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = {},
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
}
