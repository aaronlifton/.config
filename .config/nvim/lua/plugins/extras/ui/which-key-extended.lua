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
        -- /Users/$USER/.local/share/nvim/lazy/mini.icons/lua/mini/icons.lua:1853
        -- /Users/$USER/.local/share/nvim/lazy/which-key.nvim/lua/which-key/icons.lua
        -- https://github.com/8bitmcu/NerdFont-Cheat-Sheet/blob/main/nerdfont.txt
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
        { pattern = "%f[%a]avante", icon = "󱜚 ", color = "white" },
        { pattern = "%f[%a]xai", icon = " ", color = "black" },
        -- { pattern = "%f[%a]ai", icon = " ", color = "green" },
        { pattern = "%f[%a]chat with provider", icon = " ", color = "white" },
        { pattern = "%f[%a]toggle chat %([^%)]+%)", icon = " ", color = "white" },
        { pattern = "%f[%a]edit code %([^%)]+%)", icon = " ", color = "white" },
        { pattern = "%f[%a]toggle floating chat %([^%)]+%)", icon = " ", color = "white" },
        -- { plugin = "model.nvim", icon = " ", color = "white" },
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
      { "<leader>l", group = "lazy" },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>o", "", desc = "+options", mode = { "n" }, icon = { icon = " ", color = "grey" } },
      { "<leader>L", group = "Notepads", icon = { icon = "󰓩 ", color = "green" } },
      { "<leader>cp", group = "Copy path", icon = { icon = "󰓩 " } },
      { "<leader>gY", group = "Git Browse (copy)" },
      -- { "g<C-r>", group = "Modify register", icon = { icon = "󰈔 ", color = "orange" } },
      -- AI
      { "<leader>ax", group = "+controls", icon = { icon = "󰙵 ", color = "grey" } },
      { "<leader>au", group = "+utils", icon = { icon = " ", color = "grey" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Buffer Keymaps (which-key)",
      mode = "v",
    },
  },
}
