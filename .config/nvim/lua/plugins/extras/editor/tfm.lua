return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "rolv-apneseth/tfm.nvim",
    lazy = false,
    opts = {
      -- TFM to use
      -- Possible choices: "ranger" | "nnn" | "lf" | "vifm" | "yazi" (default)
      file_manager = "yazi",
      -- Replace netrw entirely
      -- Default: false
      replace_netrw = true,
      -- Enable creation of commands
      -- Default: false
      -- Commands:
      --   Tfm: selected file(s) will be opened in the current window
      --   TfmSplit: selected file(s) will be opened in a horizontal split
      --   TfmVsplit: selected file(s) will be opened in a vertical split
      --   TfmTabedit: selected file(s) will be opened in a new tab page
      -- Disabled because the key bindings are using pure lua functions
      enable_cmds = true,
      -- Custom keybindings only applied within the TFM buffer
      -- Default: {}
      keybindings = {
        ["<ESC>"] = "q",
        -- Override the open mode (i.e. vertical/horizontal split, new tab)
        -- Tip: you can add an extra `<CR>` to the end of these to immediately open the selected file(s) (assuming the TFM uses `enter` to finalise selection)
        ["<C-v>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.vsplit)<CR>",
        ["<C-x>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.split)<CR>",
        ["<C-t>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.tabedit)<CR>",
        ["<C-q>"] = "<C-q>",
        ["0"] = "<C-l>",
        -- Add H and L keybindings for yazi navigation
        ["H"] = "H", -- Go back in history
        ["L"] = "L", -- Go forward in history
      },
      -- Customise UI. The below options are the default
      ui = {
        border = "rounded",
        height = 1,
        width = 0.5,
        x = 0,
        y = 1,
      },
    },
    keys = {
      -- Make sure to change these keybindings to your preference,
      -- and remove the ones you won't use
      -- {
      --   "<leader>e",
      --   ":Tfm<CR>",
      --   desc = "TFM",
      -- },
      -- {
      --   "<leader>mh",
      --   ":TfmSplit<CR>",
      --   desc = "TFM - horizontal split",
      -- },
      -- {
      --   "<leader>mv",
      --   ":TfmVsplit<CR>",
      --   desc = "TFM - vertical split",
      -- },
      -- {
      --   "<leader>mt",
      --   ":TfmTabedit<CR>",
      --   desc = "TFM - new tab",
      {
        "<leader>fe",
        -- "<leader>e",
        function()
          require("tfm").open()
        end,
        desc = "TFM",
      },
      {
        "<leader>mh",
        function()
          local tfm = require("tfm")
          tfm.open(nil, tfm.OPEN_MODE.split)
        end,
        desc = "TFM - horizontal split",
      },
      {
        "<leader>mv",
        function()
          local tfm = require("tfm")
          tfm.open(nil, tfm.OPEN_MODE.vsplit)
        end,
        desc = "TFM - vertical split",
      },
      {
        "<leader>mt",
        function()
          local tfm = require("tfm")
          tfm.open(nil, tfm.OPEN_MODE.tabedit)
        end,
        desc = "TFM - new tab",
      },
      -- },
      {
        "<leader>mc",
        function()
          require("tfm").select_file_manager(vim.fn.input("Change file manager: "))
        end,
        desc = "TFM - change selected file manager",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        ft = "tfm",
        title = "TFM",
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
