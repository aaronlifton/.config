local util = require("util")
local map = util.keymap.map

local M = {}
-- Todo: move any plugin that can be considered "core" (permanent) to this file. This will allow us to easily manage
-- which plugins are core and which are not, while bringing the core plugins closer to "metal", ala doom emacs/vim/lunarvim style.
M.init = function()
  require("util.conceal_html")
  local cspell = require("util.cspell.lua")
  map("n", "<leader>zd", function() cspell.addWordToDictionary() end)
  util.set_user_var("IS_NVIM", true)
end

M.init()
return M
