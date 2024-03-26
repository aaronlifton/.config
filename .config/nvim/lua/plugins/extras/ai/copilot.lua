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
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        -- enabled = false,
        -- auto_trigger = false,
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-CR>",
          accept_line = "<M-l>",
          accept_word = "<M-k>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-c>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        "javascript",
        "javascriptreact",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
        "javascript",
        "javascript.jsx",
        "javascriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
        "lua",
        "astro",
        "svelte",
        "vim",
        "python",
        "sh",
        "zsh",
        "bash",
        "fish",
        "zig",
        "go",
        "gohtml",
        "goimports",
      },
      keys = {
        { "<leader>cI", "<cmd>Copilot toggle<cr>", desc = "Toggle IA" },
        {
          "<leader>cP",
          function()
            require("copilot.panel").open({ "bottom", 0.25 })
          end,
          desc = "Toggle Copilot Panel",
        },
        {
          "<leader>c]",
          function()
            require("copilot.panel").jump_next()
          end,
          desc = "Jump next (Copilot Panel)",
        },
        {
          "<leader>c]",
          function()
            require("copilot.panel").jump_prev()
          end,
          desc = "Jump prev (Copilot Panel)",
        },
        {
          "<leader>cg",
          function()
            require("copilot.panel").accept()
          end,
          desc = "Jump prev (Copilot Panel)",
        },
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
}
