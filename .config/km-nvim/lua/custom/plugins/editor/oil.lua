---@type NvPluginSpec
return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    optional = true,
  },
  opts = {
    delete_to_trash = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    float = {
      -- Padding around the floating window
      padding = 2,
      max_height = math.ceil(vim.o.lines * 0.8 - 4),
      max_width = math.ceil(vim.o.columns * 0.4),
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      override = function(conf)
        return conf
      end,
    },
    keymaps = {
      ["q"] = "actions.close",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  },
  keys = {
		-- stylua: ignore start
    { "<leader>;", function() require("oil").toggle_float() end, desc = "Toggle Oil" },
    -- stylua: ignore end
    {
      "<leader>O",
      function()
        if vim.bo.filetype == "oil" then
          vim.cmd("Bdelete!")
        else
          vim.cmd("Oil")
        end
      end,
      { desc = "Oil | Toggle Oil" },
    },
  },
}
