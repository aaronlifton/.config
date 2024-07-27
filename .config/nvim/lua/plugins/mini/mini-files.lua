return {
  {
    "echasnovski/mini.files",
    optional = true,
    opts = {
      windows = {
        preview = true,
        width_nofocus = 30,
        width_preview = 60,
        -- max_number = 2,
      },
      options = {
        use_as_default_explorer = true,
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
        desc = "Explorer (Current File)",
      },
      {
        "<leader>fJ",
        function()
          require("mini.files").open(vim.loop.cwd(), true)
        end,
        desc = "Explorer (Current Directory)",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local mini_utils = require("plugins.mini.utils")
          local leap_util = require("util.leap")
          local keymap = vim.keymap
          local buf_id = args.data.buf_id
          local map_split = mini_utils.map_split
          map_split(buf_id, "gs", "belowright horizontal")
          map_split(buf_id, "gv", "belowright vertical")

          keymap.set("n", "J", leap_util.get_leap_for_buf(buf_id), { buffer = buf_id, desc = "Leap" })
        end,
      })
    end,
  },
}
