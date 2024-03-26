return {
  {
    "echasnovski/mini.files",
    optional = true,
    opts = {
      windows = {
        preview = true,
        width_nofocus = 30,
        width_preview = 60,
        max_number = 2,
      },
      options = {
        use_as_default_explorer = true,
      },
    },
    keys = {
      -- {
      --   "<leader>F",
      --   function()
      --     require("mini.files").open()
      --   end,
      -- },
      {
        "<leader>Fe",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Explorer (Current File)",
      },
      {
        "<leader>F",
        function()
          require("mini.files").open(vim.loop.cwd(), true)
        end,
        desc = "Explorer (Current Directory)",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          local mini_utils = require("plugins.mini.utils")
          local map_split = mini_utils.map_split
          local keymap = vim.keymap

          -- Split view
          map_split(buf_id, "gs", "belowright horizontal")
          map_split(buf_id, "gv", "belowright vertical")

          -- File actions
          keymap.set("n", "g.", mini_utils.toggle_dotfiles, { buffer = buf_id, desc = "Hidden Files" })
          keymap.set("n", "s", mini_utils.jump, { buffer = buf_id, desc = "Jump" })
          keymap.set("n", "M", function()
            mini_utils.file_actions(buf_id)
          end, { buffer = buf_id, desc = "File Actions" })
          keymap.set("n", "m", function()
            mini_utils.folder_actions(buf_id)
          end, { buffer = buf_id, desc = "Folder Actions" })
        end,
      })
    end,
  },
}
