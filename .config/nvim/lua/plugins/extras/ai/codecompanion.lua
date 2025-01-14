local prefix = "<leader>A"
local generate_prefix = "<leader>ag"
local analyze_prefix = "<leader>an"
local modify_prefix = "<leader>am"
local user = vim.env.USER or "User"
-- local adapter = "anthropic"
-- local adapter = "openai"
local adapter = "gemini"

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatAdapter",
  callback = function(args)
    if args.data.adapter == nil or vim.tbl_isempty(args.data) then return end
    vim.g.llm_name = args.data.adapter.name
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    dependencies = {
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "codecompanion" },
        },
        ft = { "codecompanion" },
      },
      {
        "echasnovski/mini.diff",
        optional = true,
      },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])

      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionInline*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionInlineFinished" then
            -- Format the buffer after the inline request has completed
            require("conform").format({ bufnr = request.buf })
          end
        end,
      })
    end,
    opts = {
      prompt_library = require("plugins.extras.ai.config.codecompanion.prompt_library"),
      adapters = {
        -- deepseek_coder = function()
        --   return require("codecompanion.adapters").extend("ollama", {
        --     name = "deepseek_coder",
        --     schema = {
        --       model = {
        --         default = "deepseek-coder-v2:latest",
        --       },
        --     },
        --   })
        -- end,
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              max_tokens = {
                default = 8192,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = adapter,
          roles = {
            llm = "  CodeCompanion",
            user = " " .. user:sub(1, 1):upper() .. user:sub(2),
          },
          keymaps = {
            close = { modes = { n = "q", i = "<C-c>" } },
            stop = { modes = { n = "<C-c>" } },
          },
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
      },
      display = {
        chat = {
          show_settings = true,
          render_headers = false,
        },
        diff = {
          provider = "mini_diff",
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
      { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Code" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
      { prefix .. "C", "<cmd>CodeCompanion Toggle<cr>", mode = "n", desc = "Toggle Chat" },
      { generate_prefix .. "C", "<cmd>CodeCompanion conventional-commit<cr>", mode = "n", desc = "Conventional Commit" },
      { analyze_prefix .. "e", function() require("codecompanion").prompt("explain") end, mode = "v", desc = "Explain code"},
      { analyze_prefix .. "E", function() require("codecompanion").prompt("code-explain") end, mode = "v", desc = "Explain code 2"},
      { analyze_prefix .. "d", function() require("codecompanion").prompt("lsp") end, mode = { "n", "v" }, desc = "Diagnostics"},
      -- stylua: ignore end
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "CodeCompanion", icon = "󱚦 ", mode = { "n", "v" } },
        { generate_prefix, group = "+generate" },
        { analyze_prefix, group = "+analyze", mode = "n" },
        { analyze_prefix, group = "+analyze", mode = "v" },
        { modify_prefix, group = "+modify", mode = "v" },
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "codecompanion",
        title = "CodeCompanion",
        size = { width = 70 },
      })
    end,
  },
}
