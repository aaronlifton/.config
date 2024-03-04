return {
  {
    "gbprod/substitute.nvim",
    opts = function(opts)
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- {
      --   on_substitute = nil,
      --   yank_substituted_text = false,
      --   preserve_cursor_position = false,
      --   modifiers = nil,
      --   highlight_substituted_text = {
      --     enabled = true,
      --     timer = 500,
      --   },
      --   range = {
      --     prefix = "s",
      --     prompt_current_text = false,
      --     confirm = false,
      --     complete_word = false,
      --     subject = nil,
      --     range = nil,
      --     suffix = "",
      --     auto_apply = false,
      --     cursor_position = "end",
      --   },
      --   exchange = {
      --     motion = false,
      --     use_esc_to_cancel = true,
      --     preserve_cursor_position = false,
      --   },
      -- }
      vim.tbl_deep_extend("force", opts, {
        range = {
          prefix = "s",
          confirm = false,
          complete_word = false,
          subject = nil,
          range = nil,
          suffix = "",
          auto_apply = false,
          cursor_position = "end",
        },
      })
      return opts
    end,
    config = function(_, opts)
      require("substitute").setup(opts)
    end,
  },
}
