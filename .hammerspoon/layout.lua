local rehome = require("functions.rehome").rehome
local screen1 = "Built-in Retina Display"
local screen2 = "Studio Display"
function init_layout()
  print("[debug] init_layout()")
  -- Left monitor: LG HDR
  rehome("Google Chrome", screen2, 3, { width = 1, height = 1 })
  rehome("Google Chrome", screen2, 3, { width = 1, height = 1 })

  rehome("Slack", screen1, 3, { left = 1 / 2, width = 1 / 2, height = 1 })
  rehome("Calendar", screen1, 3, { width = 1 / 2, height = 1 })
end
