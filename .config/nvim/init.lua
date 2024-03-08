if vim.env.VSCODE then
  vim.g.vscode = true
end

-- vim.loader = false
if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
_G.bt = function(...)
  require("util.debug").bt(...)
end

vim.print = _G.dd

-- require("util.profiler").start()

require("config.lazy")
-- require("config.lazy")({
--   debug = false,
--   profiling = {
--     loader = false,
--     require = false,
--   },
-- })

_G.lv = require("lazyvim.util")

-- require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
--
-- local function reload()
--   -- source the current file
--   vim.api.nvim_command("source %")
-- end
-- local w = vim.uv.new_fs_event()
-- local on_change
-- local function watch_file(fname)
--   if w == nil then
--     return
--   end
--
--   w:start(fname, {}, vim.schedule_wrap(on_change))
-- end
-- on_change = function(err, fname, status)
--   reload()
--   -- Debounce: stop/start.
--   if w == nil then
--     return
--   end
--
--   w:stop()
--   watch_file(fname)
-- end
-- -- Create nvim command to watch the current file
-- vim.api.nvim_command("command! -nargs=1 Watch call luaeval('watch_file(_A)', expand('<args>'))")
