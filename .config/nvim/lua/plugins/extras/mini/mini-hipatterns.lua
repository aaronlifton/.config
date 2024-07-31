local hi_words = require("mini.extra").gen_highlighter.words
return {
  {
    "echasnovski/mini.hipatterns",
    optional = true,
    opts = {
      highlighters = {
        todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
        { pattern = "%f[%s]%s*$", group = "Error" },
      },
    },
  },
}
