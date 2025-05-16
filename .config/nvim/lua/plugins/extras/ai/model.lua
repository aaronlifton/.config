local gen_prefix = "<leader>ag"
local provider_prefix = "<leader>ap"
-- local mod_prefix = "<leader>am"
--
return {
  {
    "gsuuon/model.nvim",
    -- Don't need these if lazy = false
    cmd = { "M", "Model", "Mchat" },
    -- Adds 0.92 - 1.41ms to init time
    -- init = function()
    --   vim.filetype.add({
    --     extension = {
    --       mchat = "mchat",
    --     },
    --   })
    -- end,
    -- Doesn't add to init time
    -- opts = function(_, opts)
    --   vim.filetype.add({
    --     extension = {
    --       mchat = "mchat",
    --     },
    --   })
    -- end,
    -- If the markdown in the chat is not getting highlighting, run this:
    build = ":TSInstall mchat",
    ft = "mchat",
    dependencies = {
      {
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
      -- { "<C-m>", "", ft = "mchat", group = "+model" },
      { "<C-m>a", ":M<cr>", ft = "mchat", mode = "n", desc = "Run a completion prompt" },
      { "<C-m><space>", ":Mchat<cr>", ft = "mchat", mode = "n", desc = "Open a chat buffer" },
      { "<C-m>d", ":Mdelete<cr>", ft = "mchat", mode = "n", desc = "Delete" },
      { "<C-m>s", ":Mselect<cr>", ft = "mchat", mode = "n", desc = "Select" },
      { "<C-m>ma", ":MCadd<cr>", ft = "mchat", mode = "n", desc = "Add the current file into context" },
      { "<C-m>md", ":MCremove<cr>", ft = "mchat", mode = "n", desc = "Remove the current file into context" },
      { "<C-m>mD", ":MCclear<cr>", ft = "mchat", mode = "n", desc = "Clear the current context" },
      { "<C-m>mp", ":MCpaste<cr>", ft = "mchat", mode = "n", desc = "Paste file into context" },
      -- Neovim maps this as <CR>c which conflicts with neorg
      -- { "<C-m>c", "<cmd>Model codestral:fim<cr>", desc = "Complete (Codestral FIM)" },
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
        desc = "Toggle Chat (Claude Sonnet)",
      },
      -- { provider_prefix .. "c", function() vim.cmd(":vsplit | Mchat claude") end, desc = "Claude Sonnet" },
      { provider_prefix .. "c", "<cmd>tab Mchat claude<cr>", desc = "Claude Sonnet" },
      -- { provider_prefix .. "g", function() vim.cmd(":vsplit | Mchat gemini:flash") end, desc = "Gemini Flash" },
      { provider_prefix .. "g", "<cmd>tab Mchat gemini:flash-2.5<cr>", desc = "Gemini Flash 2.5" },
      { provider_prefix .. "G", "<cmd>tab Mchat gemini:pro-2.5<cr>", desc = "Gemini Pro 2.5" },
      { provider_prefix .. "s", "<cmd>tab Mchat gemini:flash-2.5-think<cr>", desc = "Gemini Flash 2.5 (Search Tool)" },
      -- { provider_prefix .. "g", "<cmd>vsplit | Mchat gemini:flash<cr>", desc = "Gemini Flash" },
      { provider_prefix .. "x", "<cmd>tab Mchat xai<cr>", desc = "xAI" },
      { provider_prefix .. "p", "<cmd>tab Mchat pplx<cr>", desc = "Perplexity" },
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
                  { visual = Util.selection.is_visual_mode() }
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
      {
        "<leader>a<C-c>",
        function()
          local FloatingWindow = require("util.nui.floating_window")
          local window = FloatingWindow({
            id = "model-claude-chat",
            title = "Claude",
            on_mount = function(_popup)
              vim.cmd(":Mchat claude")
            end,
          })
          window:mount()
        end,
        mode = "n",
        desc = "Toggle Floating Chat (Claude)",
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
        -- Autoload
        chats = util.module.autoload("util.model.chat_library"),
        -- prompts = util.module.autoload("util.model.prompt_library"),
        -- chats = require("util.model.chat_library"),
        prompts = require("util.model.prompt_library"),
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

      -- Setup ruby embeddings functions
      -- require("util.model.store.ruby")

      -- LazyVim.on_very_lazy(function() end)
      vim.filetype.add({
        extension = {
          mchat = "mchat",
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        {
          "<C-m>",
          "",
          group = "+model",
          icon = { icon = " ", color = "white" },
          cond = function()
            local buf = vim.api.nvim_get_current_buf()
            return vim.bo[buf].filetype == "mchat"
          end,
        },
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
