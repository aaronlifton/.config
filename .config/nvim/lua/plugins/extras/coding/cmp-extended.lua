local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end
local function has_words_before()
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

local ai_icons = { HF = "", OpenAI = "", Codestral = "", Bard = "" }
local format = function(entry, item)
  local icons = LazyVim.config.icons.kinds
  if icons[item.kind] then item.kind = icons[item.kind] .. item.kind end

  local widths = {
    abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
    menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
  }

  for key, width in pairs(widths) do
    if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
      item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
    end
  end

  return item
end

local astrovim_style = false
local follow_cursor = false

return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "hrsh7th/cmp-nvim-lua", lazy = true },
      -- "ray-x/cmp-treesitter",
      -- "tzachar/cmp-ai",
    },
    keys = {
      { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local copilot = require("copilot.suggestion")
      local auto_select = true
      local source_names = {
        nvim_lsp = "(LSP)",
        nvim_lua = "(Lua)",
        cmp_yanky = "(Yanky)",
        snippet = "(Snippet)",
        buffer = "(Buffer)",
        path = "(Path)",
        git = "(Git)",
      }
      local duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        -- nvim_lua = 1,
      }

      -- Comparators
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
      --   --   compare.offset,-- Items closer to cursor will have lower priority
      --   --   compare.exact,
      --   --   -- compare.scopes,
      --   --   compare.score,
      --   --   compare.recently_used,
      --   --   compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
      --   --   compare.kind,
      --   --   -- compare.sort_text,
      --   --   compare.length,
      --   --   compare.order,
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
      -- opts.performance = {
      --   debounce = 20,
      --   throttle = 20,
      --   -- fetching_timeout = 20,
      --   fetching_timeout = 500,
      --   confirm_resolve_timeout = 20,
      --   async_budget = 1,
      --   -- max_view_entries = 50,
      --   max_view_entries = 200,
      --   -- Defaults
      --   -- debounce = 60,
      --   -- throttle = 30,
      --   -- fetching_timeout = 500,
      --   -- confirm_resolve_timeout = 80,
      --   -- async_budget = 1,
      --   -- max_view_entries = 200,
      -- }

      -- Debug default LazyVim sources
      -- vim.api.nvim_echo({ { vim.inspect(opts.sources), "Normal" } }, true, {})

      -- Format
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
      -- opts.formatting.format = function(entry, item)
      --   local new_item = item
      --   new_item.menu = source_names[entry.source.name]
      --   new_item.dup = duplicates[entry.source.name] or 0
      --   return old_format(entry, new_item)
      -- end

      -- Sources
      set_priority(opts.sources, "codeium", 101)
      -- move_before(opts.sources, "codeium", "copilot")
      -- Index 4 is nvim_lsp
      table.insert(opts.sources, 3, { name = "nvim_lua", group_index = 1 })
      -- vim.list_extend(opts.sources, {
      --   { name = "treesitter", group_index = 1 },
      -- })

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
      -- opts.window = {
      --   completion = {
      --     -- border = ui_util.square_border("Normal"),
      --     border = "rounded",
      --     winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
      --     scrollbar = false,
      --     -- col_offset = -1,
      --     col_offset = -1,
      --     side_padding = 1,
      --   },
      --   documentation = {
      --     -- border = ui_util.square_border("Normal"),
      --     border = "rounded",
      --     winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
      --     scrollbar = false,
      --   },
      -- }

      if vim.g.copilot_ghost_text then
        opts.confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }
        opts.preselect = cmp.PreselectMode.None
        opts.experimental.ghost_text = nil
      end

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
      local cmdline_mapping = cmp.mapping.preset.cmdline({
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = search_mapping,
        sources = {
          { name = "buffer" },
        },
        completion = { autocomplete = false },
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

      -- cmp.setup.filetype("gitcommit", {
      --   sources = cmp.config.sources({
      --     { name = "git" },
      --   }, {
      --     name = "buffer",
      --   }),
      -- })
      -- require("cmp_git").setup()

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if copilot.is_visible() then
            copilot.accept()
          elseif is_visible(cmp) then
            cmp.select_next_item()
          elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_prev_item()
          elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

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
