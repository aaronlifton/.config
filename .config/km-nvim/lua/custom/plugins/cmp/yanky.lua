return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "chrisgrieser/cmp_yanky",
  },
  opts = function(_, opts)
    table.insert(opts.sources, { name = "cmp_yanky", group_index = 1 })
  end,
}
