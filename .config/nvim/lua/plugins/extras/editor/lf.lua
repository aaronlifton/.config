-- Sample configuration is supplied
return {
  "lmburns/lf.nvim",
  dependencies = {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = true, -- Runs require("toggleterm").setup()
    },
  },
  config = function()
    -- This feature will not work if the plugin is lazy-loaded
    vim.g.lf_netrw = 1

    require("lf").setup({
      escape_quit = false,
      border = "rounded",
    })

    vim.keymap.set("n", "<M-o>", "<Cmd>Lf<CR>")

    vim.api.nvim_create_autocmd({ "User" }, {
      event = "User",
      pattern = "LfTermEnter",
      callback = function(a)
        vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
      end,
    })
  end,
}
