return {
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
    optional = true,
    -- opts = function(_, opts)
    --   local nls = require("null-ls")
    --   local sources = {
    --     "nls.builtins.formatting.fish_indent",
    --     "nls.builtins.diagnostics.fish",
    --     "nls.builtins.formatting.stylua",
    --     "nls.builtins.formatting.shfmt",
    --     "nls.builtins.completion.spell",
    --   }
    --   for _, v in pairs(opts.sources) do
    --     table.insert(sources, v)
    --   end
    --   -- table.insert(opts.sources, nls.builtins.formatting.prettierd)
    --   -- setup = function(_, opts)
    --   --   require("null-ls").config({
    --   --     sources = opts.sources,
    --   --     -- debug = true,
    --   --   })
    --   -- end,
    -- end,
  },
}
