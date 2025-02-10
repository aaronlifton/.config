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
          set_mark("C", "~/Code", "Code")
        end,
      })
    end,
  },
}
