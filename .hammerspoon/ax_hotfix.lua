-- https://github.com/indirect/miro-windows-manager/blob/61b5a4cb261645b4704f1ee40057d82c55cb88fa/MiroWindowsManager.spoon/init.lua#L35
-- https://github.com/Hammerspoon/hammerspoon/issues/3224

-- Patch hs.window to work around accessibility forcing animations
local function axHotfix(win)
  if not win then win = hs.window.frontmostWindow() end

  local axApp = hs.axuielement.applicationElement(win:application())
  if not axApp then return end

  local wasEnhanced = axApp.AXEnhancedUserInterface
  axApp.AXEnhancedUserInterface = false

  return function()
    hs.timer.doAfter(hs.window.animationDuration * 2, function()
      axApp.AXEnhancedUserInterface = wasEnhanced
    end)
  end
end

local function withAxHotfix(fn, position)
  if not position then position = 1 end
  return function(...)
    local revert = axHotfix(select(position, ...))
    fn(...)
    if revert then revert() end
  end
end

local windowMT = hs.getObjectMetatable("hs.window")
---@diagnostic disable: need-check-nil
windowMT.setFrame = withAxHotfix(windowMT.setFrame)
windowMT.maximize = withAxHotfix(windowMT.maximize)
windowMT.moveToUnit = withAxHotfix(windowMT.moveToUnit)
---@diagnostic enable: need-check-nil

return windowMT
