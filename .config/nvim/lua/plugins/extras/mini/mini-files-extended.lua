return {
  { import = "lazyvim.plugins.extras.editor.mini-files" },
  {
    "echasnovski/mini.files",
    optional = true,
    opts = {
      windows = {
        preview = true,
        width_nofocus = 30,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = false,
      },
    },
    keys = {
      { "<leader>fm", false },
      { "<leader>fM", false },
      {
        "<leader>fj",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        -- desc = "Explorer (Current File)",
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>fJ",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        -- desc = "Explorer (Current Directory)",
        desc = "Open mini.files (cwd)",
      },
    },
  },
  {
    "echasnovski/mini.files",
    optional = true,
    opts = function()
      local MiniFiles = require("mini.files")
      -- Yank in register full path of entry under cursor
      local yank_path = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify("Cursor is not on valid entry") end
        vim.fn.setreg(vim.v.register, path)
      end

      -- local augroup = vim.api.nvim_create_augroup("GitConflictKeymap", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local b = args.data.buf_id
          vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })

          vim.keymap.set("n", "<M-E>", function()
            local target_win = Util.win.last_window_with_ft("minifiles")
            if target_win then
              local width = math.floor(vim.o.columns * 0.5) -- 50% of total width
              vim.api.nvim_win_set_width(target_win, width)
            end
          end, { buffer = b, desc = "Expand preview window" })

          vim.keymap.set("n", "<M-e>", function()
            local current_win = vim.api.nvim_get_current_win()
            if current_win then
              local width = math.floor(vim.o.columns * 0.25) -- 25% of total width
              vim.api.nvim_win_set_width(current_win, width)
            end
          end, { buffer = b, desc = "Expand current window" })
        end,
      })

      -- Bookmarks
      local set_mark = function(id, path, desc)
        MiniFiles.set_bookmark(id, path, { desc = desc })
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesExplorerOpen",
        callback = function()
          set_mark("c", vim.fn.stdpath("config"), "Config") -- path
          set_mark("w", vim.fn.getcwd, "Working directory") -- callable
          set_mark("~", "~", "Home directory")
          set_mark("H", "~", "Home directory")
          set_mark("C", "~/Code", "Code")
          set_mark("P", get_lazyvim_plugins_dir, "LazyVim plugins")
          set_mark("?", function()
            vim.ui.input({ prompt = "Enter path:" }, function(path)
              if path ~= nil and path ~= "" then set_mark("?", path, path) end
            end)
          end, "Code")
        end,
      })
    end,
  },
}
