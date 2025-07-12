return {
  "stevearc/conform.nvim",
  config = function(_, opts)
    local slow_format_filetypes = {}
    require("conform").setup(vim.tbl_extend("force", {
      -- Disable synchronous formatting, use async only
      format_on_save = nil,
      
      format_after_save = function(bufnr)
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    }, opts))
  end,
}
