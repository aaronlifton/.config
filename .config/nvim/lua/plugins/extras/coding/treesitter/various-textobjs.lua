-- | text object              | description                                                                                                                 | inner / outer                                                                             | forward-seeking    |     default keymaps      | filetypes (for default keymaps) |
-- | :----------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------- | :--------------    | :----------------------: | :------------------------------ |
-- | `indentation`            | surrounding lines with same or higher indentation                                                                           | [see overview from vim-indent-object](https://github.com/michaeljsmith/vim-indent-object) | \-                 | `ii`, `ai`, `aI`, (`iI`) | all                             |
-- | `restOfIndentation`      | lines downwards with same or higher indentation                                                                             | \-                                                                                        | \-                 |           `R`            | all                             |
-- | `greedyOuterIndentation` | outer indentation, expanded to blank lines; useful to get functions with annotations                                        | outer includes a blank (like `ap`/`ip`)                                                   | \-                 |        `ag`/`ig`         | all                             |
-- | `subword`                | segment of a camelCase, snake_case, and kebab-case words                                                                    | outer includes one trailing/leading `_` or `-`                                            | \-                 |        `iS`/`aS`         | all                             |
-- | `toNextClosingBracket`   | from cursor to next closing `]`, `)`, or `}`, can span multiple lines                                                       | \-                                                                                        | small              |           `C`            | all                             |
-- | `toNextQuotationMark`    | from cursor to next unescaped `"`, `'`, or `` ` ``, can span multiple lines                                                 | \-                                                                                        | small              |           `Q`            | all                             |
-- | `anyQuote`               | between any unescaped `"`, `'`, or `` ` `` in one line                                                                      | outer includes the quotation marks                                                        | small              |        `iq`/`aq`         | all                             |
-- | `anyBracket`             | between any `()`, `[]`, or `{}` in one line                                                                                 | outer includes the brackets                                                               | small              |        `io`/`ao`         | all                             |
-- | `restOfParagraph`        | like `}`, but linewise                                                                                                      | \-                                                                                        | \-                 |           `r`            | all                             |
-- | `entireBuffer`           | entire buffer as one text object                                                                                            | \-                                                                                        | \-                 |           `gG`           | all                             |
-- | `nearEoL`                | from cursor position to end of line minus one character                                                                     | \-                                                                                        | \-                 |           `n`            | all                             |
-- | `lineCharacterwise`      | current line, but characterwise                                                                                             | outer includes indentation & trailing spaces                                              | small, if on blank |        `i_`/`a_`         | all                             |
-- | `column`                 | column down until indent or shorter line; accepts `{count}` for multiple columns                                            | \-                                                                                        | \-                 |           `\|`           | all                             |
-- | `value`                  | value of key-value pair, or right side of assignment, excluding trailing comment (does not work for multi-line assignments) | outer includes trailing `,` or `;`                                                        | small              |        `iv`/`av`         | all                             |
-- | `key`                    | key of key-value pair, or left side of an assignment                                                                        | outer includes the `=` or `:`                                                             | small              |        `ik`/`ak`         | all                             |
-- | `url`                    | `http` links or any other protocol                                                                                          | \-                                                                                        | big                |           `L`            | all                             |
-- | `number`                 | numbers, similar to `<C-a>`                                                                                                 | inner: only digits, outer: number including minus sign and decimal *point*                | small              |        `in`/`an`         | all                             |
-- | `diagnostic`             | nvim diagnostic                                                                                                             | \-                                                                                        | ∞                  |           `!`            | all                             |
-- | `closedFold`             | closed fold                                                                                                                 | outer includes one line after the last folded line                                        | big                |        `iz`/`az`         | all                             |
-- | `chainMember`            | section of a chain connected with `.` (or `:`) like `foo.bar` or `foo.baz(para)`                                            | outer includes the leading `.` (or `:`)                                                   | small              |        `im`/`am`         | all                             |
-- | `visibleInWindow`        | all lines visible in the current window                                                                                     | \-                                                                                        | \-                 |           `gw`           | all                             |
-- | `restOfWindow`           | from the cursorline to the last line in the window                                                                          | \-                                                                                        | \-                 |           `gW`           | all                             |
-- | `lastChange`             | last non-deletion-change, yank, or paste (paste-manipulation plugins may interfere)                                         | \-                                                                                        | \-                 |           `g;`           | all                             |
-- | `mdLink`                 | markdown link like `[title](url)`                                                                                           | inner is only the link title (between the `[]`)                                           | small              |        `il`/`al`         | markdown, toml                  |
-- | `mdEmphasis`             | markdown text enclosed by `*`, `**`, `_`, `__`, `~~`, or `==`                                                               | inner is only the emphasis content                                                        | small              |        `ie`/`ae`         | markdown                        |
-- | `mdFencedCodeBlock`      | markdown fenced code (enclosed by three backticks)                                                                          | outer includes the enclosing backticks                                                    | big                |        `iC`/`aC`         | markdown                        |
-- | `cssSelector`            | class in CSS such as `.my-class`                                                                                            | outer includes trailing comma and space                                                   | small              |        `ic`/`ac`         | css, scss                       |
-- | `cssColor`               | color in CSS (hex, rgb, or hsl)                                                                                             | inner includes only the color value                                                       | small              |        `i#`/`a#`         | css, scss                       |
-- | `htmlAttribute`          | attribute in html/xml like `href="foobar.com"`                                                                              | inner is only the value inside the quotes                                                 | small              |        `ix`/`ax`         | html, xml, css, scss, vue       |
-- | `doubleSquareBrackets`   | text enclosed by `[[]]`                                                                                                     | outer includes the four square brackets                                                   | small              |        `iD`/`aD`         | lua, shell, neorg, markdown     |
-- | `shellPipe`              | segment until/after a pipe character (`\|`)                                                                                 | outer includes the pipe                                                                   | small              |        `iP`/`aP`         | bash, zsh, fish, sh             |
-- | `pyTripleQuotes`         | python strings surrounded by three quotes (regular or f-string); requires python Treesitter parser                          | inner excludes the `"""` or `'''`                                                         | \-                 |        `iy`/`ay`         | python                          |
-- | `notebookCell`           | cell delimited by [double percent comment][jupytext], such as `# %%`                                                        | outer includes the bottom cell border                                                     | \-                 |        `iN`/`aN`         | all                             |
--
return {
  "chrisgrieser/nvim-various-textobjs",
  opts = {
    keymaps = {
      useDefaults = false,
    },
    forwardLooking = {
      small = 5, -- default 5
      big = 50, -- default 15
    },
  },
  keys = {
    -- stylua: ignore start
    { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
    { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
    { "iC", ft = { "markdown", "AvanteChat", "mchat", "codecompanion" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
    { "aC", ft = { "markdown", "AvanteChat", "mchat", "codecompanion"  }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
    { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
    { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
    { "gd", mode = { "o", "x" }, function() require("various-textobjs").diagnostic() end, desc = "Diagnostics" },
    -- { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
    -- { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
    { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
    { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
    -- { "iK", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
    -- { "aK", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
    { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
    { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
    { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
    { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
    { "iH", ft = { "html, xml, css, scss, less", "astro" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute" },
    { "al", ft = { "markdown", "AvanteChat", "mchat", "codecompanion" }, mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
    { "aP", mode = {"o", "x"}, function() require("various-textobjs").chainMember("inner") end, desc = "Chain Member"},
    { "a<C-w>", mode = {"o", "x"}, function() require("various-textobjs").subword("inner") end, desc = "Subword"},
    { "a<C-i>", mode = {"o", "x"}, function() require("various-textobjs").greedyOuterIndentation("inner") end, desc = "Outer indentation (greedy)"},
    -- { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
    -- { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
    -- { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
    -- { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
    -- { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
    -- { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
    -- { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
    -- stylua: ignore end
    {
      "aR",
      ft = { "lua", "typescript", "typescriptreact", "javascript", "javascriptreact", "ruby", "rust" },
      mode = { "o", "x" },
      function()
        require("various-textobjs").restOfIndentation("outer")
      end,
      desc = "Rest of indentation",
    },
    {
      "aA",
      mode = { "o", "x" },
      function()
        -- select outer indentation
        require("various-textobjs").indentation("outer", "outer")

        -- plugin only switches to visual mode when a textobj has been found
        local indentationFound = vim.fn.mode():find("V")
        if not indentationFound then return end

        -- dedent indentation
        vim.cmd.normal({ "<", bang = true })

        -- delete surrounding lines
        local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
        local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
        vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
        vim.cmd(tostring(startBorderLn) .. " delete")
      end,
      desc = "Surrounding indentation",
    },
  },
}
