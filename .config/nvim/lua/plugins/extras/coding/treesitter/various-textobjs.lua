--          ╭─────────────────────────────────────────────────────────╮
--          │                      Legend                             │
--          │         anyBracket             = <function 1>,          │
--          │         anyQuote               = <function 2>,          │
--          │         chainMember            = <function 3>,          │
--          │         closedFold             = <function 4>,          │
--          │         column                 = <function 5>,          │
--          │         *cssColor              = <function 6>,          │
--          │         *cssSelector           = <function 7>,          │
--          │         diagnostic             = <function 8>,          │
--          │         doubleSquareBrackets   = <function 9>,          │
--          │         entireBuffer           = <function 10>,         │
--          │         greedyOuterIndentation = <function 11>,         │
--          │         *htmlAttribute         = <function 12>,         │
--          │         indentation            = <function 13>,         │
--          │         key                    = <function 14>,         │
--          │         lastChange             = <function 15>,         │
--          │         lineCharacterwise      = <function 16>,         │
--          │         mdEmphasis             = <function 17>,         │
--          │         *mdFencedCodeBlock     = <function 18>,         │
--          │         mdlink                 = <function 19>,         │
--          │         nearEoL                = <function 20>,         │
--          │         notebookCell           = <function 21>,         │
--          │         number                 = <function 22>,         │
--          │         pyTripleQuotes         = <function 23>,         │
--          │         *restOfIndentation     = <function 24>,         │
--          │         restOfParagraph        = <function 25>,         │
--          │         restOfWindow           = <function 26>,         │
--          │         setup                  = <function 27>,         │
--          │         *shellPipe             = <function 28>,         │
--          │         subword                = <function 29>,         │
--          │         toNextClosingBracket   = <function 30>,         │
--          │         toNextQuotationMark    = <function 31>,         │
--          │         *url                   = <function 32>,         │
--          │         value                  = <function 33>,         │
--          │         visibleInWindow        = <function 34>          │
--          │                                                         │
--          ╰─────────────────────────────────────────────────────────╯

return {
  "chrisgrieser/nvim-various-textobjs",
  opts = { useDefaultKeymaps = false },
  -- stylua: ignore
  keys = {
    { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
    { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
    { "iC", ft = { "markdown", "neoai-output" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
    { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
    { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
    { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
    -- { "gd", mode = { "o", "x" }, function() local textobjs = pcall(require, "various-textobjs") if textobjs then textobjs.diagnostics() end end, desc = "Diagnostics" },
    -- { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
    -- { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
    { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
    { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
    { "iK", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
    { "aK", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
    { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
    { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
    { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
    { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
    { "iH", ft = { "html, xml, css, scss, less", "astro" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
    { "al", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
    -- { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
    -- { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
    -- { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
    -- { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
    -- { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
    -- { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
    -- { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
    {
      "aR",
      ft = {"lua", "typescript", "typescriptreact", "javascript", "javascriptreact", "ruby"},
      mode = { "o", "x" },
      function() require("various-textobjs").restOfIndentation("outer") end,
      desc = "Rest of indentation",
    },
  },
}
