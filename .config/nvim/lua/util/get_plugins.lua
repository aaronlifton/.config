local Lazy = require("lazy")
local Plugin = require("lazy.core.plugin")

for _, plugin in ipairs(Lazy.plugins()) do
	local opts = Plugin.values(plugin, "opts")
	print(plugin.name, vim.inspect(opts))
end
