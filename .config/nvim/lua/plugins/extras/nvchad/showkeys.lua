return {
  "nvzone/showkeys",
  cmd = "ShowkeysToggle",
  opts = {
    -- Defaults
    -- :h nvim_open_win params
    winopts = {
      -- focusable = false,
      relative = "editor",
      style = "minimal",
      border = "single",
      height = 1,
      row = 1,
      col = 0,
      zindex = 100,
    },

    winhl = "FloatBorder:Comment,Normal:Normal",

    timeout = 1, -- 3 (in secs)
    maxkeys = 5, -- 3
    show_count = false,
    excluded_modes = {}, -- example: {"i"}

    -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
    position = "bottom-right",

    keyformat = {
      ["<BS>"] = "󰁮 ",
      ["<CR>"] = "󰘌",
      ["<Space>"] = "󱁐",
      ["<Up>"] = "󰁝",
      ["<Down>"] = "󰁅",
      ["<Left>"] = "󰁍",
      ["<Right>"] = "󰁔",
      ["<PageUp>"] = "Page 󰁝",
      ["<PageDown>"] = "Page 󰁅",
      ["<M>"] = "Alt",
      ["<C>"] = "Ctrl",
    },
  },
}
