if lazy.is_installed("firenvim") then
  vim.api.nvim_create_autocmd({ "UIEnter" }, {
    callback = function(event)
      local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
      if client ~= nil and client.name == "Firenvim" then
        vim.o.laststatus = 0
      end
    end,
  })

  vim.api.nvim_create_autocmd({
    "BufEnter",
    {
      pattern = "riot.im_*",
      command = [[inoremap <CR> <Esc>:w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa]],
    },
  })

  vim.g.firenvim_config = {
    globalSettings = {
      ["<C-w>"] = "noop",
      ["<C-n>"] = "default",
    },
  }
end
