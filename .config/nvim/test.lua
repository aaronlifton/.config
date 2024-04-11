local inspect = require("inspect")
local pp = function(e)
  print(inspect(e))
end
x = { 1, 2, 3, 4 }
for idx = 2, #x, 1 do
  x[idx - 1] = x[idx]
  ridx = #x - 1
  -- print("trying to remove " .. idx .. "(" .. x[idx] .. ")")
  -- print("from " .. pp(x))
  print("removing idx " .. ridx .. " from ")
  pp(x)
  table.remove(x, ridx)
end
for idx, item in ipairs(x) do
  print("index: " .. idx .. " value: " .. item)
end
print("x len: " .. #x)
pp(x)

-- for idx = #x - 2, #x, 1 do
--   table.remove(x, idx)
-- end
-- for idx, item in ipairs(x) do
--   print("index: " .. idx .. " value: " .. item)
-- end
