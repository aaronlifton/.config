-- Test file to check if we can access nested functions directly
local util = require("util")

-- Test direct access to util.lang.go.ginkgo.prepare_ginkgo_command_from_clipboard
print("Testing direct access to prepare_ginkgo_command_from_clipboard...")
if util.lang.prepare_ginkgo_command_from_clipboard then
  print("Success! Direct access to prepare_ginkgo_command_from_clipboard works!")
else
  print("Failed! Could not access prepare_ginkgo_command_from_clipboard directly")
end

-- Test accessing the function through the normal path as well
print("\nTesting normal access path...")
if util.lang.go.ginkgo.prepare_ginkgo_command_from_clipboard then
  print("Success! Normal access to prepare_ginkgo_command_from_clipboard works!")
else
  print("Failed! Could not access prepare_ginkgo_command_from_clipboard through normal path")
end

