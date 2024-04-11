return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    -- opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git", "config.fish")
    -- Ruby, C/C++, Go, and Lua
    opts.root_dir = require("null-ls.utils").root_pattern(
      ".null-ls-root",
      ".neoconf.json",
      "Makefile",
      "config.fish",
      "Gemfile",
      "go.mod",
      ".git"
    )
  end,
}
