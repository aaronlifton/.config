local M = {}

function M.shrink_transform(canvas, center_x, center_y)
  local shrink_transform =
    hs.canvas.matrix.translate(center_x, center_y):scale(0.0, 0.0):translate(-center_x, -center_y)
  local shrink_timer = hs.timer.doAfter(0.1, function()
    -- Apply transform to canvas
    canvas:transformation(shrink_transform)
  end)
  shrink_timer:start()
end

function M.fade(canvas, fade_duration, on_close)
  on_close = on_close or function() end
  local screen = hs.screen.mainScreen()
  -- local alert_width = 300
  local cf = canvas:frame()
  local alert_width = cf.w
  local alert_height = cf.h
  local frame = screen:frame()
  local alert_x = (frame.w - alert_width) / 2
  local alert_y = frame.h * 0 -- Position in upper third of screen

  -- Fade out and shrink animation
  local steps = 20
  local step_duration = fade_duration / steps
  local alpha_step = 0.9 / steps -- from 0.9 to 0
  local scale_step = 1.0 / steps -- from 1.0 to 0

  local step_count = 0
  local elements = canvas:canvasElements()
  local center_x = alert_x + alert_width / 2
  local center_y = alert_y + alert_height / 2

  local fade_timer = hs.timer.doEvery(step_duration, function()
    step_count = step_count + 1
    local new_alpha = 0.9 - (alpha_step * step_count)
    local new_scale = 1.0 - (scale_step * step_count)

    if new_alpha <= 0 or step_count >= steps then
      on_close()
      return false -- Stop the timer
    else
      -- Create transform matrix for scaling from center
      local scale_matrix = hs.canvas.matrix.translate(center_x, center_y)
      scale_matrix = scale_matrix:scale(new_scale, new_scale)
      scale_matrix = scale_matrix:translate(-center_x, -center_y)

      -- Update background alpha
      canvas[1].fillColor.alpha = new_alpha
      M.logger.d("Fading alert, new alpha:", new_alpha, "scale:", new_scale)
      -- Update all text elements alpha
      for i = 2, #elements do
        local textColor = canvas:elementAttribute(i, "textColor")
        if canvas:elementAttribute(i, "textColor") then
          local newTextColor = hs.fnutils.copy(textColor)
          newTextColor.alpha = textColor.alpha * (new_alpha / 0.9)
          canvas:elementAttribute(i, "textColor", newTextColor)
        end
      end
    end
  end)

  return fade_timer
end

return M
