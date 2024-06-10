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
      { "<C-m>a", ":M<cr>", mode = "n", desc = "Run a completion prompt" },
      { "<C-m><space>", ":Mchat<cr>", mode = "n", desc = "Open a chat buffer" },
      { "<C-m>d", ":Mdelete<cr>", mode = "n" },
      { "<C-m>s", ":Mselect<cr>", mode = "n" },
      { "<C-m>ma", ":MCadd<cr>", mode = "n", desc = "Add the current file into context" },
      { "<C-m>md", ":MCremove<cr>", mode = "n", desc = "Remove the current file into context" },
      { "<C-m>mD", ":MCclear<cr>", mode = "n", desc = "Clear the current context" },
      { "<C-m>mp", ":MCpaste<cr>", mode = "n", desc = "Paste file into context" },
      { "<C-m>l", ":Telescope model mchat<cr>", mode = "n", desc = "Paste file into context" },
      -- { "<leader>ag", "", "+gemini" },
      { "<leader>agc", "<cmd>Model commit2<cr>", desc = "Generate commit (Gemini)" },
      { "<leader>agv", "<cmd>Model commit:openai<cr>", desc = "Generate commit (OpenAI)" },
      { "<leader>agb", "<cmd>Model ConventionalCommit<cr>", desc = "Generate commit2 (OpenAI)" },
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
        pattern = "gitcommit",
        callback = function()
          local wk = require("which-key")
          vim.keymap.set(
            "n",
            "<C-m>g",
            ":M commit<cr>",
            { desc = "Generate git message", buffer = true, silent = true }
          )
          vim.api.nvim_echo({ { "Git commit message generator enabled", "Title" } }, true, {})
          wk.register({
            ["<C-m>g"] = {
              c = { ":Model commit<cr>", "Generate git message", noremap = true },
            },
          })
        end,
      })

      -- Override elixir-tools :M/:Mix command
      vim.api.nvim_command("command! M Model")

      -- Setup ruby embeddings functions
      require("util.model.store.ruby")
    end,
  },
}
