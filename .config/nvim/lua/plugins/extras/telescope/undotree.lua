return {
  {
    "debugloop/telescope-undo.nvim",
    opts = {},
    config = function()
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").setup({
          extensions = {
            undo = {
              use_delta = true,
              side_by_side = true,
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.6, -- 0.8
              },
            },
          },
        })
        require("telescope").load_extension("undo")
      end)
    end,
    keys = {
      { "<leader>U", "<cmd>Telescope undo<cr>", desc = "Undo history" },
    },
  },
}
