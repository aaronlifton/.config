local textobjs = pcall(require, "various-textobjs")
if not textobjs then
  textobjs = {
    diagnostics = function() end,
  }
end
return {
  "chrisgrieser/nvim-various-textobjs",
  opts = { useDefaultKeymaps = false },
  -- stylua: ignore
  keys = {
    { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
    { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
    { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
    { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
    { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
    { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
    -- {
    --   "gd", mode = { "o", "x" }, 
    --   function()
    --     local textobjs = pcall(require, "various-textobjs")
    --     if textobjs then
    --       textobjs.diagnostics()
    --     end
    --   end,
    --   desc = "Diagnostics"
    -- },
    -- { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
    -- { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
    { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
    { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
    { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
    { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
    { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
    { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
    { "iH", ft = { "html, xml, css, scss, less", "astro" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
    { "aC", ft = {"lua", "typescript.tsx", "typescript", "javascript", "javascript.jsx"}, mode = { "o", "x" },  function() require("various-textobjs").multiCommentedLines("outer") end, desc = "Mult-line comment" },
    { "aR", ft = {"lua"}, mode = { "o", "x" },  function() require("various-textobjs").restOfIndentation("outer") end, desc = "Rest of indentation" },
    -- { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
    -- { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
    -- { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
    -- { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
    { "l", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
    -- { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
    -- { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
  },
}
