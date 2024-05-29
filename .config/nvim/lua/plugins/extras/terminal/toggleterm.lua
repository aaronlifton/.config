return {
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "ToggleTerm",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
      "ToggleTermSendVisualLines",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualSelection",
    },
    opts = {
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.40
        end
      end,
      on_open = function()
        -- Prevent infinite calls from freezing neovim.
        -- Only set these options specific to this terminal buffer.
        vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
        vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
        vim.keymap.set("n", "<C-\\>", function()
          vim.api.nvim_command("ToggleTermToggleAll")
        end, { silent = "true", noremap = true })
      end,
      highlights = {
        Normal = {
          link = "Normal",
        },
        NormalFloat = {
          link = "NormalFloat",
        },
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      open_mapping = false, -- [[<c-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      persist_mode = false,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
      -- size = function(term)
      --   if term.direction == "horizontal" then
      --     return 30 -- 15
      --   elseif term.direction == "vertical" then
      --     return vim.o.columns * 0.4
      --   end
      -- end,
      -- open_mapping = [[<c-\>]],
      -- hide_numbers = true, -- hide the number column in toggleterm buffers
      -- shade_filetypes = {},
      -- shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
      -- shading_factor = "-10", -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
      -- start_in_insert = true,
      -- insert_mappings = true, -- whether or not the open mapping applies in insert mode
      -- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      -- persist_size = true,
      -- persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      -- direction = "horizontal",
      -- close_on_exit = true, -- close the terminal window when the process exits
      -- -- Change the default shell. Can be a string or a function returning a string
      -- shell = vim.o.shell,
      -- -- This field is only relevant if direction is set to 'float'
      -- float_opts = {
      --   -- The border key is *almost* the same as 'nvim_open_win'
      --   -- see :h nvim_open_win for details on borders however
      --   -- the 'curved' border is a custom border type
      --   -- not natively supported but implemented in this plugin.
      --   border = "curved",
      --   -- like `size`, width and height can be a number or function which is passed the current terminal
      --   highlights = { border = "Normal", background = "Normal" },
      --   winblend = 3,
      -- },
    },
    -- stylua: ignore
    keys = {
      { [[<c-\>]], "<cmd>ToggleTerm direction=horizontal<cr>", mode = "n", desc = "Toggle Terminal" },
      { [[<A-\>]], "<cmd>ToggleTerm direction=vertical<cr>", mode = "n", desc = "Toggle Terminal (Vert)" },
    },
  },
  -- {
  --   "ryanmsnyder/toggleterm-manager.nvim",
  --   opts = {},
  --   keys = {
  --     { "<c-/>", "<cmd>Telescope toggleterm_manager<cr>", desc = "Terminals" },
  --   },
  -- },
}
