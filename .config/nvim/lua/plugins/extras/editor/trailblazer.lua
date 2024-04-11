 {
    "LeonHeidelbach/trailblazer.nvim",
    enabled = false,
    keys = {
      "<a-l>",
      { "<leader>ma", require("plugins.motion.utils").add_trail_mark_stack, desc = "TrailBlazer: Add Stack" },
      {
        "<leader>md",
        require("plugins.motion.utils").delete_trail_mark_stack,
        desc = "TrailBlazer: Delete Stack",
      },
      {
        "<leader>mg",
        function()
          require("plugins.motion.utils").get_available_stacks(true)
        end,
        desc = "TrailBlazer: Get Stacks",
      },
      {
        "<leader>ms",
        "<Cmd>TrailBlazerSaveSession<CR>",
        desc = "TrailBlazer: Save Session",
      },
      {
        "<leader>ml",
        "<Cmd>TrailBlazerLoadSession<CR>",
        desc = "Trailblazer: Load Session",
      },
    },
    opts = function()
      local bookmark = require("config.icons").ui.BookMark
      return {
        auto_save_trailblazer_state_on_exit = true,
        auto_load_trailblazer_state_on_enter = false,
        trail_mark_symbol_line_indicators_enabled = true,
        trail_options = {
          newest_mark_symbol = bookmark,
          cursor_mark_symbol = bookmark,
          next_mark_symbol = bookmark,
          previous_mark_symbol = bookmark,
          number_line_color_enabled = false,
        },
        mappings = {
          nv = {
            motions = {
              peek_move_next_down = "<a-k>",
              peek_move_previous_up = "<a-j>",
            },
          },
        },
      }
    end,
  },
