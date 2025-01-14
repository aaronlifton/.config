-- which-key.nvim/lua/which-key/presets.lua
local helix_width = 45 -- default 30

return {
  "folke/which-key.nvim",
  opts = {
    -- preset = "helix",
    triggers = {
      { "<auto>", mode = "nixsoc" },
    },
    icons = {
      group = "",
      rules = {
        -- /Users/alifton/.local/share/nvim/lazy/mini.icons/lua/mini/icons.lua:1853
        { pattern = "main", cat = "filetype", name = "git" },
        -- { pattern = "main", icon = " ", color = "orange" },
        { plugin = "overseer.nvim", icon = "󰑮 ", color = "orange" },
        { pattern = "overseer", icon = "󰑮 ", color = "orange" },
        { plugin = "refactoring.nvim", icon = " ", color = "orange" },
        -- { plugin = "refactoring.nvim", icon = " ", color = "orange" },-- 󰴒
        { plugin = "multicursors.nvim", icon = "󱊁 ", color = "white" }, -- 󰙅 󱢓 
        { pattern = "%f[%a]twilight", icon = "󱅻 ", color = "purple" },
        { pattern = "Git Branches", icon = "󰊢 ", color = "orange" },
        { pattern = "%f[%a]branches", icon = "󰊢 ", color = "orange" },
        -- { pattern = "Git Blame Line", icon = " ", color = "orange" },
        { pattern = "%f[%a]blame", icon = " ", color = "orange" },
        { pattern = "blame.nvim", icon = " ", color = "orange" },
        { pattern = "Blame View", icon = " ", color = "orange" },
        -- { pattern = "openai", icon = "", color = "white" },
        { pattern = "%f[%a]gemini", icon = "󰊭 ", color = "white" },
        { pattern = "%f[%a]rails", icon = " ", color = "red" },
        { pattern = "%f[%a]keywords", icon = " ", color = "white" },
      },
    },
    win = {
      width = { min = helix_width, max = helix_width * 2 },
    },
    layout = {
      width = { min = helix_width },
      -- align = "center",
    },
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
      { "g<C-r>", group = "Modify register", icon = { icon = "󰈔 ", color = "orange" } },
      { "<leader>fl", group = "My Config", icon = { icon = " " } },
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
