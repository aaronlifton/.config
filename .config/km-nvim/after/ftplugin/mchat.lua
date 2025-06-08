if Util.lazy.has_plugin("cmp") then
  require("cmp").setup.buffer({
    sources = {
      { name = "buffer" },
      { name = "path" },
      -- Disable codeium
      -- { name = "codeium" },
    },
  })
end
