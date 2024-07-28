return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
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
      local has_words_before = require("util.editor").has_words_before
      local source_names = {
        nvim_lsp = "(LSP)",
        nvim_lua = "(Lua)",
        cmp_yanky = "(Yanky)",
        snippet = "(Snippet)",
        buffer = "(Buffer)",
        path = "(Path)",
      }
      local duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        -- nvim_lua = 1,
      }
      compare.lsp_scores = function(entry1, entry2)
        local diff
        if entry1.completion_item.score and entry2.completion_item.score then
          diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
        else
          diff = entry2.score - entry1.score
        end
        return (diff < 0)
      end
      -- opts.sorting.comparators = {
      --   -- compare.lsp_scores,
      --   --   -- Defaults
      --   --   compare.offset,
      --   --   compare.exact,
      --   --   -- compare.scopes,
      --   --   compare.score,
      --   --   compare.recently_used,
      --   --   compare.locality,
      --   --   compare.kind,
      --   --   -- compare.sort_text,
      --   --   compare.length,
      --   --   compare.order,
      --   --   -- Modern-neovim
      --   -- compare.score,
      --   compare.kind,
      --   compare.order,
      --   compare.recently_used,
      --   compare.offset,
      --   compare.exact,
      --   compare.sort_text,
      --   compare.length,
      --   --   -- Modern-neovim
      --   -- compare.score,
      --   -- compare.recently_used,
      --   -- compare.offset,
      --   -- compare.exact,
      --   -- compare.kind,
      --   -- compare.sort_text,
      --   -- compare.length,
      --   -- compare.order,
      -- }

      opts.performance = {
        debounce = 20,
        throttle = 20,
        -- fetching_timeout = 20,
        fetching_timeout = 500,
        confirm_resolve_timeout = 20,
        async_budget = 1,
        -- max_view_entries = 50,
        max_view_entries = 200,
        -- Defaults
        -- debounce = 60,
        -- throttle = 30,
        -- fetching_timeout = 500,
        -- confirm_resolve_timeout = 80,
        -- async_budget = 1,
        -- max_view_entries = 200,
      }

      -- Debug default LazyVim sources
      -- vim.api.nvim_echo({ { vim.inspect(opts.sources), "Normal" } }, true, {})

      local old_format = opts.formatting.format
      opts.formatting.format = function(entry, item)
        local new_item = item
        new_item.menu = source_names[entry.source.name]
        new_item.dup = duplicates[entry.source.name] or 0
        return old_format(entry, new_item)
      end

      -- Index 4 is nvim_lsp
      -- table.insert(opts.sources, 2, { name = "codeium", priority = 100, group_index = 1 })
      table.insert(opts.sources, 3, { name = "nvim_lua", group_index = 1 })
      -- opts.sources = vim.list_extend(opts.sources, {
      --   { name = "codeium", priority = 100, group_index = 1 },
      --   { name = "nvim_lua", priority = 99, group_index = 1 },
      --   -- { name = "treesitter", group_index = 1 },
      -- })

      -- local ui_util = require("util.ui")
      opts.window = {
        completion = {
          -- border = ui_util.square_border("Normal"),
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          scrollbar = false,
          -- col_offset = -1,
          col_offset = -3,
          side_padding = 1,
        },
        documentation = {
          -- border = ui_util.square_border("Normal"),
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
          scrollbar = false,
        },
      }

      local cmdline_mapping =
        cmp.mapping.preset.cmdline({ ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }) })
      cmp.setup.cmdline("/", {
        mapping = cmdline_mapping,
        sources = {
          { name = "buffer" },
        },
        completion = { autocomplete = false },
      })
      -- cmp.setup.cmdline(":", {
      --   mapping = cmdline_mapping,
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     { name = "cmdline" },
      --   }),
      --   completion = { autocomplete = false },
      --   matching = { disallow_symbol_nonprefix_matching = false, disallow_fuzzy_matching = true },
      -- })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        --   ["<C-x>"] = cmp.mapping(
        --     cmp.mapping.complete({
        --       config = {
        --         sources = cmp.config.sources({
        --           { name = "cmp_ai" },
        --         }),
        --       },
        --     }),
        --     { "i" }
        --   ),
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
        --     -- cmp.select_next_item()
        --     cmp.confirm({ select = true })
        --   elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
        --     vim.schedule(function()
        --       vim.snippet.jump(1)
        --     end)
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif vim.snippet and vim.snippet.active({ direction = -1 }) then
        --     vim.schedule(function()
        --       vim.snippet.jump(-1)
        --     end)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      })

      return opts
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
