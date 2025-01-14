local icon = " "
local processing
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequest*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionRequestStarted" then
      processing = true
    elseif request.match == "CodeCompanionRequestFinished" then
      processing = false
    end
  end,
})
return LazyVim.lualine.status(icon, function()
  return processing and "pending" or nil
end)
