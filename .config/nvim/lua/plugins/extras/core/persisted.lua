local isActive = true
local file_icon = require("lazyvim.config").icons.kinds.File

return {
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "olimorris/persisted.nvim",
    init = function()
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "PersistedTelescopeLoadPre",
        callback = function(session)
          -- Save the currently loaded session using a global variable
          require("persisted").save({ session = vim.g.persisted_loaded_session })

          -- Delete all of the open buffers
          vim.api.nvim_input("<ESC>:%bd!<CR>")
        end,
      })
    end,
    lazy = false, -- make sure the plugin is always loaded at startup
    opts = {
      use_git_branch = true, -- create session files based on the branch of the git enabled repository
      should_save = function()
        if vim.bo.filetype == "dashboard" then return false end
        return true
      end, -- function to determine if a session should be autosaved
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
      -- silent = false, -- silent nvim message when sourcing session file
      -- autosave = true, -- automatically save session files when exiting Neovim
      -- -- Set `lazy = false` in `plugins/editor.lua` to enable this
      -- autoload = false, -- automatically load the session for the cwd on Neovim startup
      -- on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
      -- follow_cwd = true, -- change session file name to match current working directory if it changes
      -- allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
      -- ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
      -- telescope = { -- options for the telescope extension
      --   reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
      -- },
    },
    config = function(_, opts)
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").setup({
          extensions = {
            persisted = {
              layout_config = {
                height = 0.6,
                width = 0.6,
              },
            },
          },
        })
        require("telescope").load_extension("persisted")
      end)
      require("persisted").setup(opts)
    end,
    keys = {
      {
        "<leader>qs",
        function()
          require("persisted").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persisted").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persisted").stop()
        end,
        desc = "Don't Save Current Session",
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
          require("persisted").save()
          vim.notify("Session saved", vim.log.levels.INFO, { title = "Persisted" })
        end,
        desc = "Save Session",
      },
      {
        "<leader>qT",
        function()
          if isActive then
            require("persisted").stop()
            isActive = false
            vim.notify("Stopped session recording", vim.log.levels.INFO, { title = "Persisted" })
          else
            require("persisted").save()
            isActive = true
            vim.notify("Started session recording", vim.log.levels.INFO, { title = "Persisted" })
          end
        end,
        desc = "Toggle Current Session Recording",
      },
      {
        "<leader>qt",
        "<cmd>Telescope persisted<cr>",
        desc = "Search Sessions (Telescope)",
      },
    },
  },
  {
    "echasnovski/mini.starter",
    optional = true,
    opts = function(_, opts)
      local util = require("util.dashboard")
      opts.items = vim.list_extend(opts.items, {
        util.new_section(" Restore Session", 'lua require("persisted").load()', "Telescope"),
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      -- Remove the older session plugin entry
      for i, section in ipairs(opts.config.center) do
        if section.key == "s" then
          table.remove(opts.config.center, i)
          break
        end
      end

      local session = {
        action = 'lua require("persisted").load()',
        desc = " Restore Session",
        icon = " ",
        key = "s",
      }

      session.desc = session.desc .. string.rep(" ", 43 - #session.desc)
      session.key_format = "  %s"

      table.insert(opts.config.center, 9, session)
    end,
  },
}
