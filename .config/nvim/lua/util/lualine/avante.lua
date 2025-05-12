local icon = " "

return LazyVim.lualine.status(icon, function()
  if not package.loaded["avante"] then return nil end

  local sidebar = require("avante").get()
  return sidebar and sidebar.is_generating and "pending" or nil
end)
