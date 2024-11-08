return {
  {
    "gsuuon/model.nvim",
    -- Don't need these if lazy = false
    cmd = { "M", "Model", "Mchat" },
    init = function()
      vim.filetype.add({
        extension = {
          mchat = "mchat",
        },
      })
    end,
    ft = "mchat",
    keys = {
      {
        "<C-m>a",
        ":M<cr>",
        mode = "n",
        desc = "Run a completion prompt",
      },
      {
        "<C-m><space>",
        ":Mchat<cr>",
        mode = "n",
        desc = "Open a chat buffer",
      },
      { "<C-m>d", ":Mdelete<cr>", mode = "n", desc = "Delete" },
      { "<C-m>s", ":Mselect<cr>", mode = "n", desc = "Select" },
      {
        "<C-m>ma",
        ":MCadd<cr>",
        mode = "n",
        desc = "Add the current file into context",
      },
      {
        "<C-m>md",
        ":MCremove<cr>",
        mode = "n",
        desc = "Remove the current file into context",
      },
      {
        "<C-m>mD",
        ":MCclear<cr>",
        mode = "n",
        desc = "Clear the current context",
      },
      {
        "<C-m>mp",
        ":MCpaste<cr>",
        mode = "n",
        desc = "Paste file into context",
      },
      -- {
      --   "<C-m>l",
      --   ":Telescope model mchat<cr>",
      --   mode = "n",
      --   desc = "Paste file into context",
      -- },
      -- { "<leader>ag", "", "+gemini" },
      { "<leader>agc", "<cmd>Model commit:gemini<cr>", desc = "Generate commit (Gemini)" },
      { "<leader>agv", "<cmd>Model commit:openai<cr>", desc = "Generate commit (OpenAI)" },
      { "<leader>agb", "<cmd>Model commit-conventional:openai<cr>", desc = "Generate conventional commit (OpenAI)" },
      { "<leader>agd", "<cmd>Model DiffExplain:main<cr>", desc = "Generate diff explanation (Gemini)" },
      { "<C-m>c", "<cmd>Model codestral:fim<cr>", desc = "Complete (Codestral FIM)" },
    },

    -- To override defaults add a config field and call setup()

    config = function()
      local openai = require("model.providers.openai")
      local hf = require("model.providers.huggingface")
      local gemini = require("model.providers.gemini")
      local llamacpp = require("model.providers.llamacpp")
      local model = require("model")
      local util = require("model.util")

      openai.initialize({
        model = "gpt-4o",
      })
      llamacpp.setup({
        binary = "~/Code/ai/llama.cpp/build/bin/server",
        models = "~/Code/ai/llama.cpp/models",
      })
      model.setup({
        default_prompt = hf.default_prompt,
        chats = util.module.autoload("plugins.extras.ai.config.chat_library"),
        prompts = util.module.autoload("plugins.extras.ai.config.prompt_library"),
      })

      local augroup = vim.api.nvim_create_augroup("ai_model", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "mchat",
        -- command = "nnoremap <silent><buffer> <leader>w :Mchat<cr>",
        callback = function()
          vim.keymap.set("n", "<leader><cr>", ":Mchat<cr>", { buffer = true, silent = true })
          vim.cmd.setlocal("foldmethod=manual")
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = { "gitcommit", "NeogitCommitMessage" },
        callback = function()
          local wk = require("which-key")
          vim.keymap.set(
            "n",
            "<C-m>g",
            ":M commit<cr>",
            { desc = "Generate git message", buffer = true, silent = true }
          )
          vim.api.nvim_echo({ { "Git commit message generator enabled", "Title" } }, true, {})
          wk.add({
            { "<C-m>", group = "AI (Model)" },
            { "<C-m>g", ":Model commit<cr>", desc = "Generate git message" },
          })
        end,
      })

      -- Override elixir-tools :M/:Mix command
      vim.api.nvim_command("command! M Model")

      vim.treesitter.language.register("markdown", "mchat")

      -- Setup ruby embeddings functions
      -- require("util.model.store.ruby")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<C-m>", group = "AI (Model)", icon = " " },
      },
    },
  },
}
