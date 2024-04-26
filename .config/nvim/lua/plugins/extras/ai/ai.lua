local ui_util = require("util.ui")
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
      { "<M-=>", "<cmd>NeoAIToggle<cr>", desc = "Toggle NeoAI" },
      {
        "<leader>wfa",
        function()
          -- require("neoai").open()
          local wins = vim.api.nvim_list_wins()
          local neoai_win = nil
          local neoai_buf = nil

          local bufs = vim.api.nvim_list_bufs()
          for _, buf in ipairs(bufs) do
            if vim.bo[buf].ft == "neoai-input" then
              ui_util.goto_leftmost_win()
              return
            end
          end

          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[buf].ft == "neoai-input" then
              neoai_win = win
              neoai_buf = buf
              break
            end
          end

          if neoai_win and neoai_buf then
            -- move focus to the buffer
            vim.api.nvim_set_current_win(neoai_win)
          else
            require("neoai").open()
          end
        end,
        desc = "Focus NeoAI",
      },
    },
    opts = {},
    config = function(_, opts)
      require("neoai").setup(vim.tbl_extend("force", opts, {}))
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
