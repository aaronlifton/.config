-- https://github.com/yutkat/dotfiles/blob/a80b83c66c8e2b8fab68b32486a1a02afd3adddb/.config/nvim/lua/rc/pluginconfig/nvim-insx.lua#L6
return {
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   optional = true,
  --   dependencies = {
  --     "RRethy/nvim-treesitter-endwise",
  --     lazy = true,
  --     ft = { "ruby", "lua", "vimscript", "bash", "elixir", "fish", "julia" },
  --     -- event = { "BufReadPost", "BufNewFile" },
  --     event = { "InsertEnter" },
  --   },
  --   opts = {
  --     endwise = {
  --       enable = true,
  --     },
  --   },
  -- },
  {
    -- https://github.com/RRethy/nvim-treesitter-endwise/issues/41
    -- "RRethy/nvim-treesitter-endwise",
    "brianhuster/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "vimscript", "bash", "elixir", "fish", "julia" },
    -- event = { "BufReadPost", "BufNewFile" },
    event = { "InsertEnter" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          endwise = {
            enable = true,
          },
        },
      },
    },
  },
}
