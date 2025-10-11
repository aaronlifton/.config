return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      -- <leader>fe
      { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi (Root Dir)" },
      -- <leader>fE
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Yazi (Cwd)" },
      { "<a-e>", "<cmd>Yazi toggle<cr>", desc = "Resume Last Yazi Session" },
    },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 0.8,
      -- when yazi is closed with no file chosen, change the Neovim working
      -- directory to the directory that yazi was in before it was closed. Defaults
      -- to being off (`false`)
      yazi_floating_window_border = "none",
      change_neovim_cwd_on_close = true,
      integrations = {
        grep_in_directory = "fzf-lua",
        grep_in_selected_files = "fzf-lua",
        resolve_relative_path_application = "grealpath",
      },
      keymaps = {
        ["show-help"] = "~",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- mark netrw as loaded so it's not loaded at all
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       hijack_netrw_behavior = "disabled",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   enabled = false,
  -- },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        ft = "yazi",
        title = "Yazi",
        size = { width = 45 },
        keys = {
          ["<C-Right>"] = function(win)
            win:resize("width", 4)
          end,
          -- decrease width
          ["<C-Left>"] = function(win)
            win:resize("width", -4)
          end,
        },
      })
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
    end,
  },
}
