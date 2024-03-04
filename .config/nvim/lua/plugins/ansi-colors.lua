return {
  {
    "m00qek/baleia.nvim",
    tag = "v1.3.0",
    config = function()
      require("baleia").setup({})
    end,
    init = function()
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        local bufname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
        if bufname == "LazyTerm" then
          return
        end
        require("baleia").setup({}).automatically(vim.fn.bufnr())
      end, {})
    end,
  },
}
