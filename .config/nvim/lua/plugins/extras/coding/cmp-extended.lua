local function set_priority(sources, target_name, new_priority)
  for _, source in ipairs(sources) do
    if source.name == target_name then
      source.priority = new_priority
      break
    end
  end
end
local cmdline_has_words_before = function()
  unpack = unpack or table.unpack
  local line = vim.fn.getcmdline()
  local col = vim.fn.getcmdpos()
  return col ~= 1 and line:sub(col - 1, col - 1):match("%s") == nil
end

local follow_cursor = false

return {
  {
    import = "lazyvim.plugins.extras.coding.nvim-cmp",
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      -- "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-buffer",
      -- "hrsh7th/cmp-path",
      -- { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-nvim-lua", lazy = true },
      { "chrisgrieser/cmp_yanky" },
      { "Snikimonkd/cmp-go-pkgs" },
    },
    keys = {
      { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local auto_select = true

      -- Performance
      opts.performance = {
        -- debounce = 20,
        -- throttle = 20,
        debounce = 0,
        throttle = 0,
        fetching_timeout = 20,
        -- fetching_timeout = 500,
        confirm_resolve_timeout = 20,
        async_budget = 1,
        max_view_entries = 50,
      }

      -- Format with nvim-highlight-colors
      if vim.g.highlight_provider == "nvim-highlight-colors" then
        local old_format = opts.formatting.format
        opts.formatting.format = function(entry, item)
          item = old_format(entry, item)
          local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
          local color_item = highlight_colors_avail and highlight_colors.format(entry, { kind = item.kind })
          if color_item and color_item.abbr and color_item.abbr_hl_group then
            item.kind, item.kind_hl_group = color_item.abbr, color_item.abbr_hl_group
          end
          return item
        end
      end

      -- Max width
      -- opts.formatting.format = function(entry, item)
      --   local icons = LazyVim.config.icons.kinds
      --   if icons[item.kind] then
      --     item.kind = icons[item.kind] .. item.kind
      --   end
      --   local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
      --   local color_item = highlight_colors_avail and highlight_colors.format(entry, { kind = item.kind })
      --   if color_item and color_item.abbr and color_item.abbr_hl_group then
      --     item.kind, item.kind_hl_group = color_item.abbr, color_item.abbr_hl_group
      --   end
      --
      --   return item
      -- end

      -- Sources
      -- Make codeium appear before copilot
      -- set_priority(opts.sources, "codeium", 101)
      -- Supermaven is too fast, so buffer/lsp completions come after it, so lower the priority
      -- set_priority(opts.sources, "supermaven", 90)

      -- Index 4 is nvim_lsp
      -- opts.sources = opts.sources or {}
      -- opts.sources = vim.tbl_extend(
      --   "force",
      --   opts.sources,
      --   cmp.config.sources({
      --     { name = "nvim_lua", group_index = 1 },
      --     { name = "go_pkgs", group_index = 1 },
      --     {
      --       name = "cmp_yanky",
      --       option = {
      --         onlyCurrentFiletype = true,
      --         minLength = 3,
      --       },
      --     },
      --   })
      -- )
      table.insert(opts.sources, 3, { name = "nvim_lua", group_index = 1 })
      table.insert(opts.sources, 4, { name = "go_pkgs", group_index = 1 })
      table.insert(opts.sources, 5, { name = "cmp_yanky", group_index = 1 })

      -- opts.matching.disallow_symbol_nonprefix_matching = false -- to use . and / in urls for go_pkgs

      -- Window
      opts.window = {
        completion = cmp.config.window.bordered({
          scrollbar = false,
          side_padding = 0,
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
      }

      if follow_cursor then
        opts.view = {
          entries = {
            follow_cursor = true,
            selection_order = "near_cursor", -- "top_down"
          },
        }
      end

      local search_mapping = cmp.mapping.preset.cmdline({
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<CR>"] = cmp.mapping(
          cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
          { "i", "c" }
        ),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = search_mapping,
        sources = {
          { name = "buffer" },
        },
        completion = { autocomplete = false },
      })

      if require("util.table").get(LazyVim.opts("noice.nvim"), "popupmenu", "backend") == "cmp" then
        local cmdline_mapping = cmp.mapping.preset.cmdline({
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.confirm({ select = true })
          --     -- cmp.select_next_item()
          --   elseif cmdline_has_words_before() then
          --     cmp.complete()
          --   else
          --     fallback()
          --   end
          -- end, { "c" }),
        })
        cmp.setup.cmdline(":", {
          mapping = cmdline_mapping,
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
            { name = "noice_popupmenu" },
          }),
          completion = { autocomplete = false },
          matching = {
            disallow_symbol_nonprefix_matching = false,
            disallow_fuzzy_matching = true, -- fmodify -> fnamemodify
            disallow_partial_fuzzy_matching = false,
            disallow_fullfuzzy_matching = false,
            disallow_partial_matching = false, -- fb -> foo_bar
            disallow_prefix_unmatching = true, -- bar -> foo_bar
          },
        })
      end

      -- cmp.setup.filetype("gitcommit", {
      --   sources = cmp.config.sources({
      --     { name = "git" },
      --   }, {
      --     name = "buffer",
      --   }),
      -- })
      -- require("cmp_git").setup()

      -- local copilot = require("copilot.suggestion")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
      })
      opts.mapping["<C-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      opts.mapping["<S-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end

      -- opts.mapping = cmp.mapping.preset.insert({
      --   ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --   ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      --   ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      --   ["<C-Space>"] = cmp.mapping.complete(),
      --   -- ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
      --   ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
      --   ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      --   ["<C-CR>"] = function(fallback)
      --     cmp.abort()
      --     fallback()
      --   end,
      --   ["<tab>"] = function(fallback)
      --     return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
      --   end,
      -- })

      if LazyVim.has("supermaven.nvim") and vim.g.ai_accept_word_provider == "supermaven" then
        opts.mapping = vim.tbl_extend("force", opts.mapping, {
          ["<C-w>"] = require("cmp").mapping(function(fallback)
            local suggestion = require("supermaven-nvim.completion_preview")
            if suggestion.has_suggestion() then
              LazyVim.create_undo()
              vim.schedule(function()
                suggestion.on_accept_suggestion(true)
              end)
              return true
            end
          end, { "i" }),
        })
      end

      if not auto_select then
        opts.preselect = cmp.PreselectMode.None
        opts.experimental.ghost_text = nil
        opts.mapping["<S-CR>"] =
          cmp.mapping(cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }))
      end

      require("util.cmp.debounce").setup()

      -- local emmet_comparator = function(entry1, entry2)
      --   if entry1.source.name == "nvim_lsp" and entry2.source.name == "nvim_lsp" then
      --     local source1 = entry1.source.source
      --     local source2 = entry2.source.source
      --
      --     local client_name1 = source1.client and source1.client.name or ""
      --     local client_name2 = source2.client and source2.client.name or ""
      --
      --     -- If one is emmet-ls and the other isn't, prioritize the non-emmet one
      --     if client_name1 == "emmet_language_server" and client_name2 ~= "emmet_language_server" then
      --       return false
      --     elseif client_name1 ~= "emmet_language_server" and client_name2 == "emmet_language_server" then
      --       return true
      --     end
      --   end
      --
      --   return nil
      -- end
      --
      -- opts.sorting.comparators = opts.sorting.comparators or {}
      -- opts.sorting.comparators[#opts.sorting.comparators + 1] = emmet_comparator

      return opts
    end,
  },
  {
    "garymjr/nvim-snippets",
    optional = true,
    opts = {
      extended_filetypes = {
        ruby = { "rails" },
        lua = { "nvim" },
      },
    },
  },
}
