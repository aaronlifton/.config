-- This works well with Lua and JS/TS, but to reduce the performance hit on LSP
-- servers and number of open file descriptors, it's disabled.
return {
  "VidocqH/lsp-lens.nvim",
  event = "LspAttach",
  opts = {
    sections = {
      definition = false,
      references = function(count)
        return "󰌹 Ref: " .. count
      end,
      implements = function(count)
        return "󰡱 Imp: " .. count
      end,
      git_authors = false,
    },
    ignore_filetype = {
      "ruby",
    },
  },
  keys = {
    { "<leader>ue", "<cmd>LspLensToggle<cr>", desc = "Toggle Lsp Lens" },
  },
}
