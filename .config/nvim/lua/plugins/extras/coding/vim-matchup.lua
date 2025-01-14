return {
  "andymass/vim-matchup",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true,
    },
  },
  init = function()
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.matchup_matchparen_enabled = 0
    -- disable middle-word (return) matching
    vim.g.matchup_delim_noskips = 1
    -- don't enable on startup
    vim.g.matchup_delim_start_plaintext = 0
  end,
}
