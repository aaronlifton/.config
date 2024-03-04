local source_action = function()
  local errors = {}

  for line in io.lines("check.log") do
    local parts = vim.split(line, ":")
    local filename = parts[1]
    local linenr = parts[2]
    local colnr = parts[3]
    local text = parts[4]

    table.insert(errors, {
      filename = filename,
      lnum = linenr,
      col = colnr,
      text = text
    })
  end
  vim.fn.setqflist(errors)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "astro" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "astro-language-server" })
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "astro",
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>xa"] = { name = " database" },
      },
    },
  },
  { "virchau13/tree-sitter-astro" }
}
