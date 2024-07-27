-- return {
--   {
--     "zbirenbaum/copilot.lua",
--     cmd = "Copilot",
--     build = ":Copilot auth",
--     event = "InsertEnter",
--     enabled = not vim.g.vscode,
--     opts = {
--       suggestion = { enabled = false },
--       panel = { enabled = false },
--       -- filetypes = {
--       --   markdown = true,
--       --   help = true,
--       -- },
--     },
--   },
-- }
return {
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.coding.copilot-chat" },
  -- {
  --     "nvim-lualine/lualine.nvim",
  --     optional = true,
  --     event = "VeryLazy",
  --     opts = function(_, opts)
  --       local Utils = require "utils"
  --       local colors = {
  --         [""] = Utils.fg "Special",
  --         ["Normal"] = Utils.fg "Special",
  --         ["Warning"] = Utils.fg "DiagnosticError",
  --         ["InProgress"] = Utils.fg "DiagnosticWarn",
  --       }
  --       table.insert(opts.sections.lualine_x, 2, {
  --         function()
  --           local icon = require("config.icons").icons.kinds.Copilot
  --           local status = require("copilot.api").status.data
  --           return icon .. (status.message or "")
  --         end,
  --         cond = function()
  --           local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
  --           return ok and #clients > 0
  --         end,
  --         color = function()
  --           if not package.loaded["copilot"] then
  --             return
  --           end
  --           local status = require("copilot.api").status.data
  --           return colors[status.status] or colors[""]
  --         end,
  --       })
  --     end,
  --   }
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        -- auto_trigger = false,
        -- enabled = true,
        -- auto_trigger = true,
        keymap = {
          accept = "<M-C-CR>",
          accept_line = "<M-C-l>",
          accept_word = "<M-C-k>",
          next = "<M-C-]>",
          prev = "<M-C-[>",
          dismiss = "<M-C-c>",
        },
        -- keymap = {
        --   accept = "<M-l>",
        --   accept_word = false,
        --   accept_line = false,
        --   next = "<M-]>",
        --   prev = "<M-[>",
        --   dismiss = "<C-]>",
        -- },
      },
      -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
      panel = { enabled = false },
      -- panel = { enabled = true, auto_refresh = true },
      -- filetypes = {
      --   markdown = true,
      --   help = true,
      --   "javascript",
      --   "javascriptreact",
      --   "typescript",
      --   "typescript.tsx",
      --   "typescriptreact",
      --   "javascript",
      --   "javascript.jsx",
      --   "javascriptreact",
      --   "vue",
      --   "css",
      --   "scss",
      --   "less",
      --   "html",
      --   "json",
      --   "jsonc",
      --   "yaml",
      --   "markdown",
      --   "markdown.mdx",
      --   "markdown",
      --   "markdown.mdx",
      --   "graphql",
      --   "handlebars",
      --   "lua",
      --   "astro",
      --   "svelte",
      --   "vim",
      --   "python",
      --   "sh",
      --   "zsh",
      --   "bash",
      --   "fish",
      --   "zig",
      --   "go",
      --   "gohtml",
      --   "goimports",
      -- },
      keys = {
        {
          "<leader>cIt",
          function()
            require("copilot.suggestion").toggle_auto_trigger()
          end,
          desc = "Toggle auto trigger",
        },
        -- {
        --   "<leader>avp",
        --   function()
        --     require("copilot.panel").open({ "bottom", 0.25 })
        --   end,
        --   desc = "Toggle Copilot Panel",
        -- },
        -- {
        --   "<leader>c]",
        --   function()
        --     require("copilot.panel").jump_next()
        --   end,
        --   desc = "Jump next (Copilot Panel)",
        -- },
        -- {
        --   "<leader>c[",
        --   function()
        --     require("copilot.panel").jump_prev()
        --   end,
        --   desc = "Jump prev (Copilot Panel)",
        -- },
        -- {
        --   "<leader>cg",
        --   function()
        --     require("copilot.panel").accept()
        --   end,
        --   desc = "Jump prev (Copilot Panel)",
        -- },
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    opts = {},
    config = function(_, opts)
      local has_words_before = function()
        -- if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        },
      })
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      require("lazyvim.util").lsp.on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      --     { "<leader>a", false },
      --     { "<leader>cha", "", desc = "+󰚩 Copilot Chat" },
      --     {
      --       "<leader>aa",
      --       false,
      --     },
      {
        "<M-0>",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Chat (Copilot)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        false,
      },
      --     {
      --       "<leader>chx",
      --       function()
      --         return require("CopilotChat").reset()
      --       end,
      --       desc = "Clear (CopilotChat)",
      --       mode = { "n", "v" },
      --     },
      --     {
      --       "<leader>aq",
      --       false,
      --     },
      --     {
      --       "<leader>chq",
      --       function()
      --         local input = vim.fn.input("Quick Chat: ")
      --         if input ~= "" then
      --           require("CopilotChat").ask(input)
      --         end
      --       end,
      --       desc = "Quick Chat (CopilotChat)",
      --       mode = { "n", "v" },
      --     },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.keymap.set({ "n", "v" }, "ax", function()
            return require("CopilotChat").reset()
          end, { desc = "Clear (CopilotChat)" })
        end,
      })

      chat.setup(opts)
    end,
  },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   keys = {
  --     -- Show help actions with telescope
  --     { "<leader>ad", false },
  --     {
  --       "<leader>Ad",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         local help = actions.help_actions()
  --         if not help then
  --           LazyVim.warn("No diagnostics found on the current line")
  --           return
  --         end
  --         require("CopilotChat.integrations.telescope").pick(help)
  --       end,
  --       desc = "Diagnostic Help (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     -- Show prompts actions with telescope
  --     { "<leader>ap", false },
  --     {
  --       "<leader>Ap",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  --       end,
  --       desc = "Prompt Actions (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --   },
  -- },
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>Ap"] = { name = "+󰚩 Copilot" },
  --     },
  --   },
  -- },
}
