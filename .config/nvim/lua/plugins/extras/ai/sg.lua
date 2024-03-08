return {
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
    },
    -- If you have a recent version of lazy.nvim, you don't need to add this!
    -- build = "nvim -l build/init.lua",
    config = function()
      require("sg").setup({})
      -- require("sg-nvim").setup({
      --   -- Pass your own custom attach function
      --   --    If you do not pass your own attach function, then the following maps are provide:
      --   --        - gd -> goto definition
      --   --        - gr -> goto references
      --   on_attach = function(_, bufnr)
      --     -- vim.keymap.set("n", "Gd", vim.lsp.buf.definition, { buffer = bufnr })
      --     -- vim.keymap.set("n", "Gr", vim.lsp.buf.references, { buffer = bufnr })
      --     -- vim.keymap.set("n", "GK", vim.lsp.buf.hover, { buffer = bufnr })
      --   end,
      -- })
    end,
  },
}
