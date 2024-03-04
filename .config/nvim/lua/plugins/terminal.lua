return {
  {
    "rebelot/terminal.nvim",
    config = function()
      require("terminal").setup({
        layout = {
          open_cmd = "botright new",
          -- width = "0.25"
        },
        cmd = { vim.o.shell },
        autoclose = false,
      })
    end,
    keys = {
      {
        "<leader>yt",
        function()
          require("terminal").toggle()
        end,
        { expr = true },
      },
      -- {
      --   "<leader>yo",
      --   function()
      --     require("terminal").run()
      --   end,
      -- },
      -- {
      --   "<leader>yr",
      --   function()
      --     require("terminal.mappings").run()
      --   end,
      -- },
      -- {
      --   "<leader>yr",
      --   function()
      --     require("terminal.mappings").run(nil, { layout = { open_cmd = "enew" } })
      --   end,
      -- },
      -- {
      --   "<leader>yk",
      --   function()
      --     require("terminal.mappings").kill()
      --   end,
      -- },
      -- {
      --   "<leader>y]",
      --   function()
      --     require("terminal.mappings").cycle_next()
      --   end,
      -- },
      -- {
      --   "<leader>y[",
      --   function()
      --     require("terminal.mappings").cycle_prev()
      --   end,
      -- },
      -- {
      --   "<leader>yl",
      --   function()
      --     require("terminal.mappings").move({ open_cmd = "belowright vnew" })
      --   end,
      -- },
      -- {
      --   "<leader>yl",
      --   function()
      --     require("terminal.mappings").move({ open_cmd = "botright vnew" })
      --   end,
      -- },
      -- {
      --   "<leader>yh",
      --   function()
      --     require("terminal.mappings").move({ open_cmd = "belowright new" })
      --   end,
      -- },
      -- {
      --   "<leader>yh",
      --   function()
      --     require("terminal.mappings").move({ open_cmd = "botright new" })
      --   end,
      -- },
      -- {
      --   "<leader>yf",
      --   function()
      --     require("terminal.mappings").move({ open_cmd = "float" })
      --   end,
      -- },
    },
  },
}
