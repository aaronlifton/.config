return {
  {
    "ramilito/winbar.nvim",
    event = "VimEnter", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("winbar").setup({
        -- your configuration comes here, for example:
        icons = true,
        diagnostics = true,
        buf_modified = true,
        buf_modified_symbol = "M",
        -- or use an icon
        -- buf_modified_symbol = "●"
        background_color = "WinBarNC",
        -- or use a hex code:
        -- background_color = "#141415",
        -- or a different highlight:
        -- background_color = "Statusline"
        dim_inactive = {
          enabled = false,
          highlight = "WinBarNC",
          icons = true, -- whether to dim the icons
          name = true, -- whether to dim the name
        },
        exclude_if = nil,
        -- define a function that returns a boolean to exclude winbar in specific circumstances.
        -- the function should return true when you want to exclude the winbar, false otherwise.
        -- for example:
        -- exclude_if = function()
        --   return vim.w.magenta == true
        -- end
      })
    end,
  },
}
