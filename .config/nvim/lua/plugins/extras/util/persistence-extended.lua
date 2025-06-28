local isActive = true

local function delete_hidden_buffers()
  local visible = {}
  for _, win in pairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if not visible[buf] then
      -- Skip if buffer doesn't exist anymore
      if not vim.api.nvim_buf_is_valid(buf) then goto continue end

      -- Check if buffer is modified
      local modified = vim.api.nvim_get_option_value("modified", { buf = buf })

      -- Use pcall to handle potential errors
      local success, err = pcall(function()
        vim.api.nvim_buf_delete(buf, { force = not modified })
      end)

      if not success and not modified then
        -- Try again with force if it failed and wasn't modified
        local ok = pcall(function()
          vim.api.nvim_buf_delete(buf, { force = true })
        end)
        if not ok then
          -- vim.api.nvim_echo(
          --   { { "Failed to delete buffer\n", "Title" }, { vim.inspect(err), "Normal" } },
          --   true,
          --   { err = true }
          -- )
          vim.notify("Failed to delete buffer " .. buf .. ": " .. err, vim.log.levels.ERROR, { title = "Persistence" })
        end
      end

      ::continue::
    end
  end
end

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "PersistenceLoadPost",
--   callback = function(session)
--     require("fredrik.utils.private").toggle_copilot()
--   end,
-- })

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceSavePre",
  callback = function(session)
    delete_hidden_buffers()
  end,
})

return {
  "folke/persistence.nvim",
  keys = {
    -- stylua: ignore start
    { "<leader>ql", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qs", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>qL", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    -- stylua: ignore end
    {
      "<leader>qS",
      function()
        require("persistence").save()
        LazyVim.notify("Session Saved", { title = "Persistence" })
      end,
      desc = "Save Session",
    },
    {
      "<leader>qt",
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
      desc = "Toggle Current Session Recording",
    },
  },
}
