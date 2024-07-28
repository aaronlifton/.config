return {
  {
    "vuki656/package-info.nvim",
    event = {
      "BufRead package.json",
      "BufRead package-lock.json",
    },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>Pwv", function() require('package-info').show({ force = true }) end, desc = "Show Package Versions" },
      { "<leader>Pwu", function() require('package-info').update() end, desc = "Update Package" },
      { "<leader>Pwr", function() require('package-info').delete() end, desc = "Remove Package" },
      { "<leader>Pwc", function() require('package-info').change_version() end, desc = "Change Package Version" },
      { "<leader>Pwi", function() require('package-info').install() end, desc = "Install New Dependency" },
    },
  },
  {
    "voldikss/vim-floaterm",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>Pwp", "<cmd>FloatermNew --disposable --name=lazynpm --opener=edit --titleposition=center --height=0.85 --width=0.85 --cwd=<root> lazynpm<CR>", desc = "Lazynpm" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>P", group = "packages/dependencies", icon = " " },
        { "<leader>Pw", group = "web", icon = "󰖟 " },
      },
    },
  },
}
