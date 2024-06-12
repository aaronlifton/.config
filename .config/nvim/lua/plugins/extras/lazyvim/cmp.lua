-- local border = function(hl)
--   return {
--     { "┌", hl },
--     { "─", hl },
--     { "┐", hl },
--     { "│", hl },
--     { "┘", hl },
--     { "─", hl },
--     { "└", hl },
--     { "│", hl },
--   }
-- end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
      "tzachar/cmp-ai",
    },
    keys = {
      { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local neogen = require("neogen")
      local has_words_before = require("util.editor").has_words_before

      compare.lsp_scores = function(entry1, entry2)
        local diff
        if entry1.completion_item.score and entry2.completion_item.score then
          diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
        else
          diff = entry2.score - entry1.score
        end
        return (diff < 0)
      end

      opts.performance = {
        debounce = 20,
        throttle = 20,
        fetching_timeout = 20,
        confirm_resolve_timeout = 20,
        async_budget = 1,
        max_view_entries = 50,
      }

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", max_item_count = 15 },
        { name = "codeium", priority = 100 },
        { name = "copilot", priority = 100 },
        { name = "cmp_ai", priority = 100 },
        -- { name = "nvim_lua" },
        { name = "treesitter" },
        { name = "path" },
        { name = "snippets" },
      }, {
        { name = "buffer" },
      })
      opts.window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          scrollbar = false,
          col_offset = -1,
          side_padding = 1,
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          scrollbar = false,
        },
      }
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- Already set by LazyVim
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<C-x>"] = cmp.mapping(
          cmp.mapping.complete({
            config = {
              sources = cmp.config.sources({
                { name = "cmp_ai" },
              }),
            },
          }),
          { "i" }
        ),

        -- Already set by LazyVim
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            -- cmp.select_next_item()
            cmp.confirm({ select = true })
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
            -- vim.snippet.jump(1)
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif neogen.jumpable() then
            neogen.jump_next()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet and vim.snippet.active({ direction = -1 }) then
            -- vim.snippet.jump(-1)
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          elseif neogen.jumpable(true) then
            neogen.jump_prev()
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "garymjr/nvim-snippets",
    opts = {
      extended_filetypes = {
        ruby = { "rails" },
        lua = { "nvim" },
      },
    },
  },
}
