return {
  {
    "huggingface/hfcc.nvim",
    event = "InsertEnter",
    enabled = false,
    opts = {
      model = "bigcode/starcoder",
    },
  },
  {
    "mthbernardes/codeexplain.nvim",
    enabled = false,
    cmd = "CodeExplain",
    build = function()
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
      "NeoAIShortcut",
    },
    keys = {
      { "<leader>czt", desc = "Summarize Text" },
      { "<leader>czg", desc = "Generate Git Message" },
    },
    opts = {},
    config = function()
      require("neoai").setup({
        -- Options go here
      })
    end,
  },
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  --stylua: ignore
  keys = {
    { "<leader>sD", function() require("wtf").ai() end, desc = "Search Diagnostic with AI" },
    { "<leader>sd", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
  },
  },
}
