local use_tailwind = false
if not use_tailwind then
  return {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes = {
            "astro",
            "astro-markdown",
            "svelte",
          },
        },
      },
    },
  }
end

return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  -- { import = "plugins.extras.ui.inline-fold" },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>cT", "<cmd>TWValues<cr>", desc = "Tailwind CSS values" },
    },
    opts = {},
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "tailwindcss",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = {
            -- "markdown",
            "erb",
            "eruby",
            "haml",
            "handlebars",
            "hbs",
            "html",
            "mustache",
            "css",
            "less",
            "sass",
            "scss",
            "javascript",
            "typescript",
          },
        },
      },
    },
  },
}
