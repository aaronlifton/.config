require("config.options_pre")
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- TODO: when LazyVim dependency is removed
-- require("config.options")

vim.schedule(function()
  -- TODO: when LazyVim dependency is removed
  -- require("config.keymaps")

  local custom_modules = {
    {
      path = "util.cursor",
      cond = function()
        return vim.g.vscode and vim.env.CURSOR
      end,
    },
    {
      path = "util.myvscode",
      cond = function()
        -- return vim.g.vscode
        return false
      end,
    },
    {
      path = "util.neovide",
      cond = function()
        return vim.g.neovide
      end,
    },
  }

  for _, mod in ipairs(custom_modules) do
    if type(mod.cond) == "function" and mod.cond() == true then
      local ok, err = pcall(require, mod.path)
      local modname = mod.path:match("[^%.]+$") or mod.path
      if not ok then vim.notify(("Error loading %s module\n\n%s"):format(modname, err), vim.log.levels.ERROR) end

      vim.notify(("Loaded %s module"):format(modname), vim.log.levels.INFO)
    end
  end
end)
