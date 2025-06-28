return {
  {
    "sam4llis/nvim-tundra",
    init = function()
      require("nvim-tundra").setup({
        transparent_background = false,
        dim_inactive_windows = {
          enabled = false,
          color = nil,
        },
        sidebars = {
          enabled = true,
          color = nil,
        },
        plugins = {
          lsp = true,
          semantic_tokens = true,
          treesitter = true,
          telescope = true,
          nvimtree = true,
          cmp = true,
          context = true,
          dbui = true,
          gitsigns = true,
          neogit = true,
          textfsm = true,
        },
        editor = {
          search = {},
          substitute = {},
        },
        diagnostics = {
          errors = {},
          warnings = {},
          information = {},
          hints = {},
        },
        syntax = {
          booleans = { bold = true, italic = true },
          comments = { bold = true, italic = true },
          conditionals = {},
          constants = { bold = true },
          fields = {},
          functions = {},
          keywords = {},
          loops = {},
          numbers = { bold = true },
          operators = { bold = true },
          punctuation = {},
          strings = {},
          types = { italic = true },
        },
        overwrite = {
          colors = {},
          highlights = {},
        },
      })

      vim.g.tundra_biome = "arctic" -- 'arctic' or 'jungle'
      vim.opt.background = "dark"
      vim.cmd("colorscheme tundra")
    end,
    dependencies = {
      {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = {
          theme = "tundra",
        },
      },
      {
        "ibhagwan/fzf-lua",
        optional = true,
        opts = function(_, opts)
          opts.fzf_colors = {
            true,
            bg = "-1",
            gutter = "-1",
          }
        end,
      },
    },
  },
}
