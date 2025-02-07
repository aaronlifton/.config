local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function set_priority(sources, target_name, new_priority)
  for _, source in ipairs(sources) do
    if source.name == target_name then
      source.priority = new_priority
      break
    end
  end
end

local astrovim_style = false
local follow_cursor = false

return {
  {
    import = "lazyvim.plugins.extras.coding.nvim-cmp",
    cond = function()
      return LazyVim.cmp_engine() == "nvim-cmp"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-nvim-lua", lazy = true },
    },
    keys = {
      { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local auto_select = true

      -- Performance
      opts.performance = {
        debounce = 20,
        throttle = 20,
        fetching_timeout = 20,
        -- fetching_timeout = 500,
        confirm_resolve_timeout = 20,
        async_budget = 1,
        max_view_entries = 50,
      }

      -- Format with nvim-highlight-colors
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
      set_priority(opts.sources, "codeium", 101)
      -- Supermaven is too fast, so that buffer/lsp completions come after it, so lower the priority
      set_priority(opts.sources, "supermaven", 90)

      -- Index 4 is nvim_lsp
      table.insert(opts.sources, 3, { name = "nvim_lua", group_index = 1 })

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

      if astrovim_style then
        opts.preselect = cmp.PreselectMode.None
        opts.formatting.format = function(entry, item)
          local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
          local color_item = highlight_colors_avail and highlight_colors.format(entry, { kind = item.kind })
          local icons = require("util.icons").kinds
          if icons[item.kind] then item.kind = icons[item.kind] end
          if color_item and color_item.abbr and color_item.abbr_hl_group then
            item.kind, item.kind_hl_group = color_item.abbr, color_item.abbr_hl_group
          end
          return item
        end
        opts.formatting.fields = { "kind", "abbr", "menu" }
        opts.window.completion.col_offset = -2
      end

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
          matching = { disallow_symbol_nonprefix_matching = false, disallow_fuzzy_matching = true },
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
        -- Supertab
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
        --     cmp.select_next_item()
        --   elseif vim.snippet.active({ direction = 1 }) then
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
        --   elseif vim.snippet.active({ direction = -1 }) then
        --     vim.schedule(function()
        --       vim.snippet.jump(-1)
        --     end)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      })

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
