if not vim.g.native_snippets_enabled then
  return {}
end
return {
  desc = "Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!",
  { import = "lazyvim.plugins.extras.coding.native_snippets" },
  {
    "L3MON4D3/LuaSnip",
    enabled = false,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      return vim.tbl_deep_extend("force", opts, {
        mapping = cmp.mapping.preset.insert({
          ["<C-g>"] = cmp.mapping.confirm({ select = true }),
        }),
      })
      -- Default lazyvim mapping
      -- mapping = cmp.mapping.preset.insert({
      --   ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      --   ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      --   ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --   ["<C-Space>"] = cmp.mapping.complete(),
      --   ["<C-e>"] = cmp.mapping.abort(),
      --   ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      --   ["<S-CR>"] = cmp.mapping.confirm({
      --     behavior = cmp.ConfirmBehavior.Replace,
      --     select = true,
      --   }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      --   ["<C-CR>"] = function(fallback)
      --     cmp.abort()
      --     fallback()
      --   end,
      -- })
    end,
  },
}
