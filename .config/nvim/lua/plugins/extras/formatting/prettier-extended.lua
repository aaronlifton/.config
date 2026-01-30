local function has_config(ctx)
  vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
  return vim.v.shell_error == 0
end

return {
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.prettier.prepend_args = function(_, ctx)
        if not has_config(ctx) then return { "--config", vim.fn.stdpath("config") .. "/rules/.prettierrc.json" } end
      end
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "prettier",
      },
    },
  },
}
