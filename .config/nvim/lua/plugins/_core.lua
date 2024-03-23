local editor = require("plugins/core/editor")
local M = {}
-- Todo: move any plugin that can be considered "core" (permanent) to this file. This will allow us to easily manage
-- which plugins are core and which are not, while bringing the core plugins closer to "metal", ala doom emacs/vim/lunarvim style.

for _, p in ipairs(editor) do
  table.insert(M, p)
end

return M
