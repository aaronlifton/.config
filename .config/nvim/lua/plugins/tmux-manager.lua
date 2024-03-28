local tmux_enabled = false

if not tmux_enabled then
  return {}
else
  return {
    {
      "otavioschwanck/tmux-awesome-manager.nvim",
      event = "VeryLazy",
      config = function()
        require("tmux-awesome-manager").setup({
          session_name = "Neovim Terminals",
          use_icon = true,
          icon = " ",
        })
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        local function tma()
          return require("tmux-awesome-manager.src.integrations.status").open_terms()
        end
        -- Insert the icon
        table.insert(opts.sections.lualine_x, 2, {
          tma,
        })
      end,
    },
  }
end
