local gen_prefix = "<leader>ag"
local provider_prefix = "<leader>ap"
-- local mod_prefix = "<leader>am"
--
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
    dependencies = {
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "mchat" },
        },
        ft = { "mchat" },
      },
    },
    keys = {
      -- Chat keymaps
      { "<C-m>a", ":M<cr>", ft = "mchat", mode = "n", desc = "Run a completion prompt" },
      { "<C-m><space>", ":Mchat<cr>", ft = "mchat", mode = "n", desc = "Open a chat buffer" },
      { "<C-m>d", ":Mdelete<cr>", ft = "mchat", mode = "n", desc = "Delete" },
      { "<C-m>s", ":Mselect<cr>", ft = "mchat", mode = "n", desc = "Select" },
      { "<C-m>ma", ":MCadd<cr>", ft = "mchat", mode = "n", desc = "Add the current file into context" },
      { "<C-m>md", ":MCremove<cr>", ft = "mchat", mode = "n", desc = "Remove the current file into context" },
      { "<C-m>mD", ":MCclear<cr>", ft = "mchat", mode = "n", desc = "Clear the current context" },
      { "<C-m>mp", ":MCpaste<cr>", ft = "mchat", mode = "n", desc = "Paste file into context" },
      { "<C-m>c", "<cmd>Model codestral:fim<cr>", desc = "Complete (Codestral FIM)" },
      -- Editor keymaps
      { gen_prefix .. "c", "<cmd>Model commit:gemini<cr>", desc = "Commit message (Gemini)" },
      { gen_prefix .. "v", "<cmd>Model commit:openai<cr>", desc = "Commit message (OpenAI)" },
      {
        gen_prefix .. "b",
        "<cmd>Model commit-conventional:openai<cr>",
        desc = "Conventional commit (OpenAI)",
      },
      { gen_prefix .. "d", "<cmd>Model DiffExplain:main<cr>", desc = "Diff explanation (Gemini)" },
      -- stylua: ignore start
      {
        "<leader>ac",
        function()
          -- Need to prefix messages with ">> cache\n" to set ephemeral tag
          -- vim.cmd(":tab Mchat claude:cache")
          vim.cmd(":tab Mchat claude")
        end,
        desc = "Toggle Chat (Claude Sonnet (Cache))",
      },
      { provider_prefix .. "c", function() vim.cmd(":vsplit | Mchat claude") end, desc = "Claude Sonnet" },
      { provider_prefix .. "g", function() vim.cmd(":vsplit | Mchat gemini:flash") end, desc = "Gemini Flash" },
      { provider_prefix .. "x", "<cmd>tab Mchat xai<cr>", desc = "xAI" },
      -- stylua: ignore end
      -- Disabled in favor of Avante edit
      -- {
      --   "<leader>ae",
      --   function()
      --     local nui = require("util.nui.input")
      --     nui.cursor_input("Prompt", function(value)
      --       vim.cmd(("'<,'>Model %s %s"):format("anthropic:claude-code", value))
      --     end, { size = { width = 40, height = 2 } })
      --   end,
      --   mode = { "n", "v" },
      --   desc = "Edit Code (Claude Sonnet)",
      -- },
      {
        "<leader>aE",
        function()
          local InputBox = require("util.nui.input_box")
          local input = InputBox({
            title = " Prompt ",
            on_submit = function(content)
              vim.schedule(function()
                require("util.model.api").prompt(
                  "anthropic:claude-code",
                  require("model").mode.INSERT_OR_REPLACE,
                  content,
                  { visual = true }
                )
              end)
            end,
            on_close = function() end,
            size = {
              height = 5,
              width = 50,
            },
          })
          input:mount()
        end,
        mode = { "n", "v" },
        desc = "Edit Code (Claude Sonnet)",
      },
    },
    -- To override defaults add a config field and call setup()
    config = function()
      local openai = require("model.providers.openai")
      local hf = require("model.providers.huggingface")
      -- local gemini = require("model.providers.gemini")
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
        callback = function(_event)
          vim.keymap.set("n", "<leader><cr>", ":Mchat<cr>", { buffer = true, silent = true })
          vim.cmd.setlocal("foldmethod=manual")
          -- local win = vim.fn.bufwinid(ev.buf)
          -- vim.api.nvim_set_option_value("wrap", true, { win = win })
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

      -- Override mchat filetype to support render-markdown.nvim
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
        { gen_prefix, group = "+generate" },
        { provider_prefix, group = "+Chat with provider" },
      },
    },
  },
  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       ft = "mchat",
  --       title = "Model.nvim",
  --       size = { width = 70 },
  --     })
  --   end,
  -- },
}
