return {
  "folke/which-key.nvim",
  opts = {
    triggers = {
      { "<auto>", mode = "nixsoc" },
    },
    icons = {
      group = "",
      rules = {
        { pattern = "main", cat = "filetype", name = "git" },
        -- { pattern = "main", icon = " ", color = "orange" },
      },
    },
    -- layout = {
    --   align = "center",
    -- },
    defaults = {},
    spec = {
      mode = { "n" },
      -- ["<leader><tab>"] = { name = "󰓩 tabs" },
      -- ["<leader>b"] = { name = "󰖯 buffer" },
      -- ["<leader>c"] = { name = " code" },
      -- ["<leader>f"] = { name = "󰈔 file/find" },
      -- ["<leader>g"] = { name = " git" },
      -- ["<leader>q"] = { name = "󰗼 quit/session" },
      -- ["<leader>s"] = { name = " search" },
      -- ["<leader>u"] = { name = " ui" },
      -- ["<leader>w"] = { name = "󱂬 windows" },
      -- ["<leader>x"] = { name = "󰁨 diagnostics/quickfix" },
      -- ["<leader>uU"] = { name = "ui utilities" },
      { "<leader>l", group = "lazy" },
      { "<leader>cI", group = "AI Controls" },
      { "<leader>L", group = "Notepads", icon = { icon = "󰓩 ", color = "green" } },
      { "<leader>cp", group = "Copy path", icon = { icon = "󰓩 " } },
      -- ---LazyVim
      -- { "<leader><tab>", group = "tabs" },
      -- { "<leader>b", group = "buffer" },
      -- { "<leader>c", group = "code" },
      -- { "<leader>f", group = "file/find" },
      -- { "<leader>g", group = "git" },
      -- { "<leader>gh", group = "hunks" },
      -- { "<leader>q", group = "quit/session" },
      -- { "<leader>s", group = "search" },
      -- { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
      -- { "<leader>w", group = "windows" },
      -- { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      -- { "[", group = "prev" },
      -- { "]", group = "next" },
      -- { "g", group = "goto" },
      -- { "gz", group = "surround" },
      -- { "z", group = "fold" },
    },
  },
}