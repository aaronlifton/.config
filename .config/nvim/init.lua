-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("pre-lazy")
vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"

require("config.lazy")

-- if vim.env.CURSOR then
--   require("util.cursor")
if vim.g.vscode then
  -- require("util.myvscode")
  vim.notify("Loading cursor settings", vim.log.levels.INFO)
  vim.api.nvim_echo({ { vim.inspect("Loading cursor settings"), "Normal" } }, true, {})
  require("util.cursor")
end
if vim.g.neovide then require("util.neovide") end
require("util.lazy.root").setup({
  integrations = {
    resolve_relative_path_implementation = function(args, get_relative_path)
      -- By default, the path is resolved from the file/dir yazi was focused on
      -- when it was opened. Here, we change it to resolve the path from
      -- Neovim's current working directory (cwd) to the target_file.
      local cwd = vim.fn.getcwd()
      local path = get_relative_path({
        selected_file = args.selected_file,
        source_dir = cwd,
      })
      return path
    end,
  },
})
