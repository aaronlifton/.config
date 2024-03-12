local filter_func = function(window_ids, filters)
  -- List of filetypes to exclude
  local excluded_filetypes = {
    "NvimTree",
    "neo-tree",
    "notify",
    "lazy",
    "qf",
    "diff",
    "fugitive",
    "fugitiveblame",
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui-repl",
    "dapui_console",
  }

  -- List of buftypes to exclude
  local excluded_buftypes = { "terminal" }

  -- Get the list of windows
  local windows = vim.api.nvim_list_wins()

  -- The table that will hold the IDs of the windows to include
  local include_windows = {}

  -- Iterate over each window
  for _, win in ipairs(windows) do
    -- Check if the window is valid and visible
    if not vim.api.nvim_win_is_valid(win) then
      goto continue
    end
    ---@type {topline: number, height: number}|nil
    local wininfo = vim.fn.getwininfo(win)
    if wininfo == nil then
      goto continue
    end
    -- local winbot = 0
    -- if wininfo and wininfo.topline ~= nil then
    --   winbot = winbot + wininfo.topline
    --   if wininfo.height ~= nil then
    --     winbot = winbot + wininfo.height
    --   end
    -- end
    local winbot = (wininfo.topline or 0) + wininfo.height
    -- local wininfo = vim.api.nvim_win_get_config(win)
    if vim.api.nvim_win_is_valid(win) and winbot ~= 0 then
      -- Get the buffer ID of the window
      local buf = vim.api.nvim_win_get_buf(win)

      -- Get the filetype and buftype of the buffer
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf, scope = "local" })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf, scope = "local" })

      -- Check if the filetype and buftype are not in the exclude lists
      if not vim.tbl_contains(excluded_filetypes, filetype) and not vim.tbl_contains(excluded_buftypes, buftype) then
        -- If they're not, add the window ID to the include list
        table.insert(include_windows, win)
      end
    end
    ::continue::
  end

  -- If there is only one window in the include list, return an empty table
  if #include_windows == 1 then
    return {}
  else
    return include_windows
  end
end

---
return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        -- -- type of hints you want to get
        -- -- following types are supported
        -- -- 'statusline-winbar' | 'floating-big-letter'
        -- -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
        -- -- 'floating-big-letter' draw big letter on a floating window
        -- -- used
        -- { hint = 'statusline-winbar' },
        hint = "statusline-winbar",
        -- hint = 'floating-big-letter',
        filter_func = filter_func,
        -- following filters are only applied when you are using the default filter
        -- defined by this plugin. If you pass in a function to "filter_func"
        -- property, you are on your own
        filter_rules = {
          -- when there is only one window available to pick from, use that window
          -- without prompting the user to select
          autoselect_one = true,

          -- whether you want to include the window you are currently on to window
          -- selection or not
          include_current_win = false,

          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = {
              "NvimTree",
              "neo-tree",
              "notify",
              "lazy",
              "qf",
              "diff",
              "fugitive",
              "fugitiveblame",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui-repl",
              "dapui_console",
              "neo-tree",
              "neo-tree-popup",
              "notify",
              "quickfix",
              "Trouble",
              "fidget",
              "noice",
            },

            -- if the file type is one of following, the window will be ignored
            -- buftype = { "terminal" },
            buftype = { "terminal", "nofile" },
          },

          -- filter using window options
          wo = {},

          -- if the file path contains one of following names, the window
          -- will be ignored
          file_path_contains = {},

          -- if the file name contains one of following names, the window will be
          -- ignored
          file_name_contains = {},
        },
      })
    end,
  },
}
