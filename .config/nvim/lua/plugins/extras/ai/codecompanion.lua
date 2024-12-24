local prefix = "<leader>A"
local user = vim.env.USER or "User"

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
          -- adapter = "openai",
          adapter = "anthropic",
          -- roles = {
          --   llm = "  CodeCompanion",
          --   user = " " .. user:sub(1, 1):upper() .. user:sub(2),
          -- },
          keymaps = {
            close = { modes = { n = "q", i = "<C-c>" } },
            stop = { modes = { n = "<C-c>" } },
          },
        },
        inline = { adapter = "anthropic" },
        agent = { adapter = "anthropic" },
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
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
      { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
      { prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Code" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
      { prefix .. "C", "<cmd>CodeCompanion Toggle<cr>", mode = "n", desc = "Toggle Chat" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "CodeCompanion", icon = "󱚦 " },
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
