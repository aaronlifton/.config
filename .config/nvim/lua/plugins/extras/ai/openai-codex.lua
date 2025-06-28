return {
  "johnseth97/codex.nvim",
  lazy = true,
  cmd = { "Codex", "CodexToggle" }, -- Optional: Load only on command execution
  build = "npm install -g @openai/codex",
  keys = {
    {
      "<leader>cc", -- Change this to your preferred keybinding
      function()
        require("codex").toggle()
      end,
      desc = "Toggle Codex popup",
    },
  },
  opts = {
    keymaps = {}, -- Disable internal default keymap (<leader>cc -> :CodexToggle)
    border = "rounded", -- Options: 'single', 'double', or 'rounded'
    width = 0.8, -- Width of the floating window (0.0 to 1.0)
    height = 0.8, -- Height of the floating window (0.0 to 1.0)
    model = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
    autoinstall = true, -- Automatically install the Codex CLI if not found
  },
}

-- ### Usage:
-- - Call `:Codex` (or `:CodexToggle`) to open or close the Codex popup.
-- -- Map your own keybindings via the `keymaps.toggle` setting.
-- - Add the following code to show backgrounded Codex window in lualine:
--
-- ```lua
-- require('codex').status() -- drop in to your lualine sections
