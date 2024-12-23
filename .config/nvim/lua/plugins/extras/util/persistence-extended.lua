local isActive = true

return {
  "folke/persistence.nvim",
  keys = {
    {
      "<leader>qk",
      function()
        require("persistence").save()
        vim.notify("Session saved", vim.log.levels.INFO, { title = "Persistence" })
      end,
      desc = "Save Session",
    },
    -- stylua: ignore start
    { "<leader>qt",
      function()
        local p = require("persistence")
        if isActive then
          p.stop()
          isActive = false
          vim.notify("Stopped session recording", vim.log.levels.INFO, { title = "Persistence" })
        else
          p.start()
          isActive = true
          vim.notify("Started session recording", vim.log.levels.INFO, { title = "Persistence" })
        end
      end,
      desc = "Toggle Current Session Recording"
    },
    -- stylua: ignore end
  },
}
