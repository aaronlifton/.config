if LazyVim.has("cmp") then
  require("cmp").setup.buffer({
    sources = {
      { name = "buffer" },
      { name = "path" },
      { name = "path" },
      -- Disable codeium
      -- { name = "codeium" },
    },
  })
end