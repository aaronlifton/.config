local isActive = true
local file_icon = require("lazyvim.config").icons.kinds.File

return {
  "olimorris/persisted.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("telescope").load_extension("persisted")
      end,
      keys = {
        { "<leader>sL", "<cmd>Telescope persisted<cr>", desc = ("%sSessions"):format(file_icon) },
      },
    },
  },
  lazy = false, -- make sure the plugin is always loaded at startup
  config = true,
  opts = {
    save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
    silent = false, -- silent nvim message when sourcing session file
    use_git_branch = true, -- create session files based on the branch of the git enabled repository
    autosave = true, -- automatically save session files when exiting Neovim
    should_autosave = function()
      if vim.bo.filetype == "dashboard" then
        return false
      end
      return true
    end, -- function to determine if a session should be autosaved
    -- Set `lazy = false` in `plugins/editor.lua` to enable this
    autoload = false, -- automatically load the session for the cwd on Neovim startup
    on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
    follow_cwd = true, -- change session file name to match current working directory if it changes
    allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
    ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
    telescope = { -- options for the telescope extension
      reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
    },
  },
  keys = {
    {
      "<leader>qs",
      function()
        vim.cmd("SessionLoad")
      end,
      desc = "Restore Session",
    },
    {
      "<leader>ql", -- in favor of <leader>sl
      function()
        vim.cmd("SessionLoadLast")
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        vim.cmd("SessionDelete")
      end,
      desc = "Delete Session",
    },
    {
      "<leader>qS",
      function()
        vim.cmd("SessionSave")
        vim.notify("Session saved", vim.log.levels.INFO, { title = "Persisted" })
      end,
      desc = "Save Session",
    },
    -- stylua: ignore start
    { "<leader>qt",
      function()
        if isActive then
          vim.cmd("SessionStop")
          isActive = false
          vim.notify("Stopped session recording", vim.log.levels.INFO, { title = "Persisted" })
        else
          vim.cmd("SessionStart")
          isActive = true
          vim.notify("Started session recording", vim.log.levels.INFO, { title = "Persisted" })
        end
      end,
      desc = "Toggle Current Session Recording"
    },
    -- stylua: ignore end
  },
}
