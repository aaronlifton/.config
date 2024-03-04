return {
  {
    "nvim-orgmode/orgmode",
    enabled = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
    },
    event = "VeryLazy",
    config = function()
      -- Load treesitter grammar for org
      require("orgmode").setup_ts_grammar()

      -- Setup treesitter
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "org" },
        },
        ensure_installed = { "org" },
      })

      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/Documents/org/**/*",
        org_default_notes_file = "~/Documents/org/refile.org",
      })

      vim.cmd([[
        syntax match OrgHeadlineStar1 /^\*\ze\s/me=e-1 conceal cchar=◉ containedin=OrgHeadlineLevel1 contained
        syntax match OrgHeadlineStar2 /^\*\{2}\ze\s/me=e-1 conceal cchar=○ containedin=OrgHeadlineLevel2 contained
        syntax match OrgHeadlineStar3 /^\*\{3}\ze\s/me=e-1 conceal cchar=✸ containedin=OrgHeadlineLevel3 contained
        syntax match OrgHeadlineStar4 /^\*{4}\ze\s/me=e-1 conceal cchar=✿ containedin=OrgHeadlineLevel4 contained
      ]])
    end,
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     vim.cmd([[highlight Headline1 guibg=#1e2718]])
  --     vim.cmd([[highlight Headline2 guibg=#21262d]])
  --     vim.cmd([[highlight CodeBlock guibg=#1c1c1c]])
  --     vim.cmd([[highlight Dash guibg=#D19A66 gui=bold]])
  --
  --     vim.tbl_deep_extend("force", opts, {
  --       org = {
  --         headline_highlights = { "Headline1", "Headline2" },
  --       },
  --     })
  --   end,
  -- },
}
