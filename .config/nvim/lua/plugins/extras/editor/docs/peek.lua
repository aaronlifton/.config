if vim.g.markdown_previewer == "markdown-preview" then
  return {
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function(plugin)
        if vim.fn.executable("npx") then
          vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
        else
          vim.cmd([[Lazy load markdown-preview.nvim]])
          vim.fn["mkdp#util#install"]()
        end
      end,
      init = function()
        if vim.fn.executable("npx") then
          vim.g.mkdp_filetypes = { "markdown", "markdown.mdx" }
        end
      end,
    },
  }
end

return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        ft = { "markdown", "markdown.mdx" },
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
