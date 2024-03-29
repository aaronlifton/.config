local tailwind_filetypes = {
  "astro",
  "svelte",
  "vue",
  "html",
  "css",
  "scss",
  "less",
  "styl",
  "javascript",
  "typescript",
  "javascriptreact",
  "javascript.jsx",
  "typescriptreact",
  "typescript.tsx",
  "jsx",
  "tsx",
  "slim",
  "ex",
  "exs",
  "heex",
  "gotmpl",
  "templ",
  "rust",
  "rs",
}

return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "plugins.extras.ui.inline-fold" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "stylelint" })
    end,
  },
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
          filetypes_include = tailwind_filetypes,
        },
        -- emmet_ls = {
        --   filetypes = tailwind_filetypes,
        -- },
      },
    },
  },
}
